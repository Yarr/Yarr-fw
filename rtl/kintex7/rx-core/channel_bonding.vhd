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

    signal data_d : rx_data_array(g_NUM_LANES-1 downto 0);

    signal rx_data_s : rx_data_array(g_NUM_LANES-1 downto 0);
    
begin    
    
    pr_shift_data : process(clk)
    begin
        if rising_edge(clk) then
            for I in 0 to g_NUM_LANES-1 loop
                data_d(I) <= rx_data_i(I);
            end loop;
        end if;
    end process;

    --Need to detect which lanes are currently sending channel bonding frames
    pr_detect_cb_frames : process(rx_data_i, rx_header_i)
    begin
        for I in 0 to g_NUM_LANES-1 loop
            is_cb_frame_prev(I) <= is_cb_frame(I);
            --Aurora spec: idle frame with bits 53:50 = "0100" is channel bonding frame
            if ((rx_header_i(I) = c_CMD_HEADER) and (rx_data_i(I)(63 downto 56) = c_AURORA_IDLE) and rx_data_i(I)(53 downto 50) = "0100") then                    
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
            --update when first seeing new channel bonding frames
            elsif (is_cb_frame_prev = c_ALL_ZEROS) then
                lane_early <= is_cb_frame; 
            end if;
        end if;
    end process;

    --If a lane is early, output from its shift reg. Else, lane itself is outputted
    --Inactive lanes are directly outputted
    pr_output : process(rx_data_i, data_d)
    begin
        for I in 0 to g_NUM_LANES-1 loop
            if (lane_early(I) = '1' and active_lanes_i(I) = '1') then
                rx_data_s(I) <= data_d(I);
            else
                rx_data_s(I) <= rx_data_i(I);
            end if;
        end loop;
    end process;

    --Set empty high if output data is in unkown state, or data is not good to be read
    --Set empty low if it was high and valid goes high
    pr_set_empty : process(rx_read_i, rx_valid_i, rx_data_s)
    begin
        for I in 0 to g_NUM_LANES-1 loop
            if ((rx_read_i(I) = '1') or (rx_valid_i(I) = '0') or (rx_data_s(I) = c_ALL_UNDEFINED)) then
                empty(I) <= '1';
            elsif ((rx_valid_i(I) = '1') and (empty(I) = '1')) then
                empty(I) <= '0'; 
            else
                empty(I) <= '0';
            end if;
        end loop;
    end process;

    rx_empty_o <= empty;
    rx_data_o <= rx_data_s;
    
end behavioral;
