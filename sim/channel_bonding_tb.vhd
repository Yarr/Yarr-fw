-- Simulation testbench for channel_bonding.vhd


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
library UNISIM;
use UNISIM.VComponents.all;

library work;
use work.aurora_rx_pkg.all;

entity channel_bonding_tb is
--  Port ( );
end channel_bonding_tb;

architecture Behavioral of channel_bonding_tb is
    component channel_bonding
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
    end component channel_bonding;
    
    constant g_NUM_LANES : integer := 2;
    constant c_52_ZEROS : std_logic_vector(51 downto 0) := (others => '0');
    constant c_56_ZEROS : std_logic_vector(55 downto 0) := (others => '0');
    constant c_CB_FRAME : std_logic_vector(63 downto 0) := c_AURORA_IDLE & "0001" & c_52_ZEROS; 
    constant c_IDLE_FRAME : std_logic_vector(63 downto 0) := c_AURORA_IDLE & c_56_ZEROS;  

    signal clk_rx_i : std_logic := '0';    
    constant RX_CLK_PERIOD : time := 6.4ns; 
    
    signal cb_enable : std_logic;
    signal cb_din : rx_data_array(g_NUM_LANES-1 downto 0);
    signal cb_header : rx_header_array(g_NUM_LANES-1 downto 0);
    signal cb_dvalid : std_logic_vector(g_NUM_LANES-1 downto 0);
    signal cb_active_lanes : std_logic_vector(g_NUM_LANES-1 downto 0);
    signal cb_read : std_logic_vector(g_NUM_LANES-1 downto 0);
    signal cb_dout : rx_data_array(g_NUM_LANES-1 downto 0);
    signal cb_empty : std_logic_vector(g_NUM_LANES-1 downto 0);
    
    
begin

    rx_clk_proc: process
    begin
        clk_rx_i <= '1';
        wait for RX_CLK_PERIOD/2;
        clk_rx_i <= '0';
        wait for RX_CLK_PERIOD/2;
    end process rx_clk_proc;
    
    dut_channel_bond : channel_bonding
        generic map (g_NUM_LANES => 2)
        port map (
            clk             => clk_rx_i,
            enable_i        => cb_enable,
            rx_data_i       => cb_din,
            rx_header_i     => cb_header,
            rx_valid_i      => cb_dvalid,
            active_lanes_i  => cb_active_lanes,
            rx_read_i       => cb_read,
            rx_data_o       => cb_dout,
            rx_empty_o      => cb_empty
    );


    pr_set_input : process
    begin
                    
        cb_enable <= '1';
        cb_dvalid <= "00";
        cb_active_lanes <= "11";

        cb_din(0) <= c_CB_FRAME;
        cb_header(0) <= c_CMD_HEADER;
        cb_din(1) <= c_IDLE_FRAME;
        cb_header(1) <= c_CMD_HEADER;
        cb_read <= "00";

        wait for RX_CLK_PERIOD;

        cb_dvalid <= "01";
        cb_din(0) <= x"000000000000AAAA";
        cb_header(0) <= c_DATA_HEADER;
        cb_din(1) <= c_CB_FRAME;
        cb_header(1) <= c_CMD_HEADER;

        wait for RX_CLK_PERIOD;

        cb_dvalid <= "10";
        cb_din(0) <= x"000000000000AAAA";
        cb_header(0) <= c_DATA_HEADER;
        cb_din(1) <= x"000000000000AAAA";
        cb_header(1) <= c_DATA_HEADER;

        wait for RX_CLK_PERIOD;
        cb_dvalid <= "00";
        cb_read <= "01";
        wait for RX_CLK_PERIOD;
        cb_read <= "10";
        wait for RX_CLK_PERIOD;
        cb_read <= "00";
        ------------------------------------------------
        wait for 4 * RX_CLK_PERIOD;

        cb_din(0) <= x"000000000000BBBB";
        cb_din(1) <= x"000000000000AAAA";

        wait for RX_CLK_PERIOD;

        cb_din(0) <= x"000000000000BBBB";
        cb_din(1) <= x"000000000000BBBB";
        ------------------------------------------------
        wait for 7 * RX_CLK_PERIOD;

        cb_dvalid <= "01"; 
        cb_din(0) <= x"000000000000CCCC";
        cb_din(1) <= x"000000000000BBBB";

        wait for RX_CLK_PERIOD;

        cb_dvalid <= "10";
        cb_din(0) <= x"000000000000CCCC";
        cb_din(1) <= x"000000000000CCCC";

        wait for RX_CLK_PERIOD;
        cb_dvalid <= "00";
        wait for RX_CLK_PERIOD;
        cb_read <= "01";
        wait for RX_CLK_PERIOD;
        cb_read <= "10";
        wait for RX_CLK_PERIOD;
        cb_read <= "00";
        
        ------------------------------------------------
        wait for 3 * RX_CLK_PERIOD;
 
        cb_din(0) <= x"000000000000DDDD";
        cb_din(1) <= x"000000000000CCCC";

        wait for RX_CLK_PERIOD;

        cb_din(0) <= x"000000000000DDDD";
        cb_din(1) <= x"000000000000DDDD";
        ------------------------------------------------
        wait for 7 * RX_CLK_PERIOD;
        
    end process;
                 
end Behavioral;
