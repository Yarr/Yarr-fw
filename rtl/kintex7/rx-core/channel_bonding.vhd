-- ####################################
-- # Project: Yarr
-- # Author: Lauren Choquer
-- # E-Mail: choquerlauren@gmail.com
-- # Comments: For use bonding Aurora lanes
-- ####################################


library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library unisim ;
use unisim.vcomponents.all ;

library work;
use work.aurora_rx_pkg.all;

entity channel_bonding is
    generic (
        g_NUM_LANES : integer range 1 to 4 := 1
    );
    port (
        clk             : in std_logic;
        -- Input
        enable_i        : in std_logic;
        rx_data_i       : in rx_data_array(g_NUM_LANES-1 downto 0);
        rx_header_i     : in rx_header_array(g_NUM_LANES-1 downto 0);
        rx_valid_i      : in std_logic_vector(g_NUM_LANES-1 downto 0);
        active_lanes_i  : in std_logic_vector(g_NUM_LANES-1 downto 0);
        rx_read_i       : in std_logic_vector(g_NUM_LANES-1 downto 0);

        -- Output
        rx_data_o       : out rx_data_array(g_NUM_LANES-1 downto 0);
        rx_empty_o      : out std_logic_vector(g_NUM_LANES-1 downto 0)      
    );
end channel_bonding;

architecture behavioral of channel_bonding is

    constant c_ALL_ZEROS : std_logic_vector(g_NUM_LANES-1 downto 0) := (others => '0');
    constant c_ALL_UNDEFINED : std_logic_vector(63 downto 0) := (others => 'X');

    signal is_cb_frame : std_logic_vector(g_NUM_LANES-1 downto 0);
    signal is_cb_frame_prev : std_logic_vector(g_NUM_LANES-1 downto 0);
    signal lane_early : std_logic_vector(g_NUM_LANES-1 downto 0);

    -- Used by rx_channel to decide if data can be read out
    signal empty : std_logic_vector(g_NUM_LANES-1 downto 0);

    signal data_d   : rx_data_array(g_NUM_LANES-1 downto 0);
    signal header_d : rx_header_array(g_NUM_LANES-1 downto 0);
    signal valid_d  : std_logic_vector(g_NUM_LANES-1 downto 0);
    signal valid_filt_d  : std_logic_vector(g_NUM_LANES-1 downto 0);
    signal read_d  : std_logic_vector(g_NUM_LANES-1 downto 0);
    signal read_dd  : std_logic_vector(g_NUM_LANES-1 downto 0);

    -- Bonded version of data, header, and valid signals
    signal rx_data_b    : rx_data_array(g_NUM_LANES-1 downto 0);  
    signal rx_header_b  : rx_header_array(g_NUM_LANES-1 downto 0);  
    signal rx_valid_b   : std_logic_vector(g_NUM_LANES-1 downto 0);

    signal valid_filtered : std_logic_vector(g_NUM_LANES-1 downto 0);
    
begin    
    
    pr_add_delay : process(clk)
    begin
        if rising_edge(clk) then
            for I in 0 to g_NUM_LANES-1 loop
                data_d(I) <= rx_data_i(I);
                header_d(I) <= rx_header_i(I);
                valid_d(I) <= rx_valid_i(I);
                valid_filt_d(I) <= valid_filtered(I);
                read_d(I) <= rx_read_i(I);
                read_dd(I) <= read_d(I);
            end loop;
        end if;
    end process;

    --Need to detect which lanes are currently sending channel bonding frames
    --Note: cb frames on inactive lanes will not be detected
    pr_detect_cb_frames : process(rx_data_i, rx_header_i)
    begin
        for I in 0 to g_NUM_LANES-1 loop
            is_cb_frame_prev(I) <= is_cb_frame(I);
            --Aurora spec: idle frame with bits 53:50 = "0100" is channel bonding frame
            if ((active_lanes_i(I) = '1') and (rx_header_i(I) = c_CMD_HEADER) and 
                (rx_data_i(I)(63 downto 56) = c_AURORA_IDLE) and rx_data_i(I)(53 downto 50) = "0100") then                    
                is_cb_frame(I) <= '1'; 
            else 
                is_cb_frame(I) <= '0';                   
            end if;
        end loop;
    end process;

    --Based on which lanes are sending cb frames, can determine if a lane is early
    pr_detect_early_lanes : process(clk)
    begin
        if rising_edge(clk) then
            --don't need to update when not seeing channel bonding frames
            if (is_cb_frame = c_ALL_ZEROS) then
                lane_early <= lane_early;
            --update when first seeing new channel bonding frames:
            --the early lane(s) will be the ones where cb frames first appear
            elsif (is_cb_frame_prev = c_ALL_ZEROS) then
                lane_early <= is_cb_frame; 
            end if;
        end if;
    end process;

    --If a lane is early, output from its shift reg. Else, lane itself is outputted
    --Inactive lanes are directly outputted
    pr_bonding : process(clk)
    begin
        if rising_edge(clk) then
            for I in 0 to g_NUM_LANES-1 loop
                if (lane_early(I) = '1' and active_lanes_i(I) = '1') then
                    rx_data_b(I)    <= data_d(I);
                    rx_header_b(I)  <= header_d(I);
                    rx_valid_b(I)   <= valid_d(I);
                else
                    rx_data_b(I)    <= rx_data_i(I);
                    rx_header_b(I)  <= rx_header_i(I);
                    rx_valid_b(I)   <= rx_valid_i(I);
                end if;
            end loop;
        end if;
    end process;
 
    --Notes from filter (previously in aurora_rx_channel):
    -- We expect these types of data:
    -- b01 - D[63:0] - 64 bit data
    -- b10 - 0x1E - 0x04 - 0xXXXX - D[31:0] - 32 bit data
    -- b10 - 0x1E - 0x00 - 0x0000 - 0x00000000 - 0 bit data
    -- b10 - 0x78 - Flag[7:0] - 0xXXXX - 0xXXXXXXXX - Idle
    -- b10 - 0xB4 - D[55:0] - Register read (MM)
    pr_filter : process(rx_header_b, rx_data_b)
    begin
        for I in 0 to g_NUM_LANES-1 loop
            if (rx_header_b(I) = c_DATA_HEADER) then
                -- Swapping [63:32] and [31:0] to reverse swapping by casting 64-bit to uint32_t
                rx_data_o(I) <= rx_data_b(I)(31 downto 0) & rx_data_b(I)(63 downto 32);
                valid_filtered(I) <= rx_valid_b(I);
            elsif (rx_data_b(I)(63 downto 56) = c_AURORA_SEP) then
                rx_data_o(I) <= rx_data_b(I)(31 downto 0) & x"FFFFFFFF";
                valid_filtered(I) <= rx_valid_b(I);
            elsif (rx_header_b(I) = c_CMD_HEADER) then
                if ((rx_data_b(I)(63 downto 56) = x"55") or (rx_data_b(I)(63 downto 56) = x"99") or (rx_data_b(I)(63 downto 56) = x"D2")) then
                    rx_data_o(I) <= rx_data_b(I)(31 downto 0) & rx_data_b(I)(63 downto 32);
                    valid_filtered(I) <= rx_valid_b(I);
                else
                    rx_data_o(I) <= x"FFFFFFFFFFFFFFFF";
                    valid_filtered(I) <= '0';
                end if;
            else
                rx_data_o(I) <= x"FFFFFFFFFFFFFFFF";
                valid_filtered(I) <= '0';
            end if;
        end loop;
    end process;

    --Set empty high if output data is not good to read, or once good data has been read
    --Set empty low at beginning of new valid data
    pr_set_empty : process(read_dd, valid_filtered, valid_filt_d) 
    begin
        for I in 0 to g_NUM_LANES-1 loop
            if ((read_dd(I) = '1') or (valid_filtered(I) = '0')) then
                empty(I) <= '1';
            elsif ((valid_filtered(I) = '1') and (valid_filt_d(I) = '0')) then
                empty(I) <= '0';
            end if;
        end loop;
    end process;

    rx_empty_o <= empty;
    
end behavioral;
