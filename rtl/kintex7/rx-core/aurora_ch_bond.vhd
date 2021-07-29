-- ####################################
-- # Project: Yarr
-- # Author: Lauren Choquer & Timon Heim
-- # E-Mail: choquerlauren@gmail.com
-- # Comments: Original code taken from Lauren 
--             and modified by Timon
-- ####################################

library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.aurora_rx_pkg.all;

library unisim ;
use unisim.vcomponents.all ;

entity aurora_ch_bond is 
    generic (
        g_NUM_LANES : integer range 1 to 4 := 1
    );
    port (
        -- Sys connect
        rst_n_i : in std_logic;
        clk_rx_i : in std_logic;

        -- Config
        active_lanes_i : in std_logic_vector(g_NUM_LANES-1 downto 0);

        -- Input
        rx_data_i : in rx_data_array(g_NUM_LANES-1 downto 0);
        rx_header_i : in rx_header_array(g_NUM_LANES-1 downto 0);
        rx_valid_i : in std_logic_vector(g_NUM_LANES-1 downto 0);

        -- Output
        rx_data_o : out rx_data_array(g_NUM_LANES-1 downto 0);
        rx_header_o : out rx_header_array(g_NUM_LANES-1 downto 0);
        rx_valid_o : out std_logic_vector(g_NUM_LANES-1 downto 0);
        rx_bond_o : out std_logic
    );
end aurora_ch_bond;

architecture behavioral of aurora_ch_bond is
	
    constant c_ALL_ZEROS : std_logic_vector(g_NUM_LANES-1 downto 0) := (others => '0');
	constant c_ALL_ONES : std_logic_vector(g_NUM_LANES-1 downto 0) := (others => '1');
    
    -- Delayed copies
    signal rx_data_t0 : rx_data_array(g_NUM_LANES-1 downto 0); 
    signal rx_data_t1 : rx_data_array(g_NUM_LANES-1 downto 0); 
    signal rx_data_t2 : rx_data_array(g_NUM_LANES-1 downto 0); 
    signal rx_header_t0 : rx_header_array(g_NUM_LANES-1 downto 0);
    signal rx_header_t1 : rx_header_array(g_NUM_LANES-1 downto 0);
    signal rx_header_t2 : rx_header_array(g_NUM_LANES-1 downto 0);

    signal is_cb_frame_t0 : std_logic_vector(g_NUM_LANES-1 downto 0);
    signal is_cb_frame_t1 : std_logic_vector(g_NUM_LANES-1 downto 0);
    signal is_cb_frame_t2 : std_logic_vector(g_NUM_LANES-1 downto 0);

    signal delay_lane : std_logic_vector(g_NUM_LANES-1 downto 0);
    signal double_delay_lane : std_logic_vector(g_NUM_LANES-1 downto 0);

    signal rx_bond : std_logic;

begin

    lane_loop: for I in 0 to g_NUM_LANES-1 generate
        -- Create pipeline to pick which lanes need to be delayed
        delay_proc : process(clk_rx_i, rst_n_i)
        begin
            if (rst_n_i = '0') then
                rx_data_t0(I) <= (others => '0');
                rx_data_t1(I) <= (others => '0');
                rx_data_t2(I) <= (others => '0');
                rx_header_t0(I) <= (others => '0');
                rx_header_t1(I) <= (others => '0');
                rx_header_t2(I) <= (others => '0');
                rx_valid_o(I) <= '0';
            elsif rising_edge(clk_rx_i) then
                if (rx_valid_i(I) = '1') then
                    rx_data_t0(I) <= rx_data_i(I);
                    rx_header_t0(I) <= rx_header_i(I);
                    rx_data_t1(I) <= rx_data_t0(I);
                    rx_header_t1(I) <= rx_header_t0(I);
                    rx_data_t2(I) <= rx_data_t1(I);
                    rx_header_t2(I) <= rx_header_t1(I);
                end if;
                rx_valid_o(I) <= rx_valid_i(I);
            end if;
        end process delay_proc;

        -- CB frames are transmitted at the same time on all lanes
        is_cb_frame_t0(I) <= '1' when ((rx_header_t0(I) = c_CMD_HEADER) and (rx_data_t0(I)(63 downto 56) = c_AURORA_IDLE) and (rx_data_t0(I)(55 downto 52) = "0100") and (active_lanes_i(I) = '1')) else '0';
        is_cb_frame_t1(I) <= '1' when ((rx_header_t1(I) = c_CMD_HEADER) and (rx_data_t1(I)(63 downto 56) = c_AURORA_IDLE) and (rx_data_t1(I)(55 downto 52) = "0100") and (active_lanes_i(I) = '1')) else '0';
        is_cb_frame_t2(I) <= '1' when ((rx_header_t2(I) = c_CMD_HEADER) and (rx_data_t2(I)(63 downto 56) = c_AURORA_IDLE) and (rx_data_t2(I)(55 downto 52) = "0100") and (active_lanes_i(I) = '1')) else '0';

        -- Output
        rx_data_o(I) <= rx_data_t1(I) when delay_lane(I) = '1' else
                        rx_data_t2(I) when double_delay_lane(I) = '1' else rx_data_t0(I);
        rx_header_o(I) <= rx_header_t1(I) when delay_lane(I) = '1' else
                          rx_header_t2(I) when double_delay_lane(I) = '1' else rx_header_t0(I);

    end generate lane_loop;

    -- Need to choose which lanes should be delayed by one or two valid cycles
    -- i.e. we can identify which lanes need to be delayed by noting which CB frames
    -- are in timeslot t0, t1, and t2 when all CB frames are visible
    -- Need to avoid bopnding multiple times in a row
    rx_bond_o <= rx_bond;
    bond_proc : process(clk_rx_i, rst_n_i)
    begin
            if (rst_n_i = '0') then
                delay_lane <= (others => '0');
                double_delay_lane <= (others => '0');
                rx_bond <= '0';
            elsif rising_edge(clk_rx_i) then
                if (rx_valid_i(0) = '1') then
                    if (((is_cb_frame_t0 or is_cb_frame_t1 or is_cb_frame_t2) = active_lanes_i) and
                        is_cb_frame_t0 /= active_lanes_i and is_cb_frame_t1 /= active_lanes_i and
                        rx_bond = '0') then
                        delay_lane <= is_cb_frame_t1; -- Delay those lanes one cycle ahead
                        double_delay_lane <= is_cb_frame_t2; -- Double Delay those lanes two cycles ahead
                        rx_bond <= '1';
                    else
                        rx_bond <= '0';
                    end if;
                end if;
            end if;
    end process bond_proc;

end behavioral;
