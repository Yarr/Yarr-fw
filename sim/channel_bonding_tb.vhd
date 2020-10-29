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
        rx_data_i       : in rx_data_array(g_NUM_LANES-1 downto 0);
        rx_header_i     : in rx_header_array(g_NUM_LANES-1 downto 0);
        rx_valid_i      : in std_logic_vector(g_NUM_LANES-1 downto 0);
        rx_stat_i       : in rx_status_array(g_NUM_LANES-1 downto 0);
        active_lanes_i  : in std_logic_vector(g_NUM_LANES-1 downto 0);
        rx_read_i       : in std_logic_vector(g_NUM_LANES-1 downto 0);

        -- Output
        rx_data_o       : out rx_data_array(g_NUM_LANES-1 downto 0);
        rx_empty_o      : out std_logic_vector(g_NUM_LANES-1 downto 0)      
    );
    end component channel_bonding;
    
    constant g_NUM_LANES : integer := 2;
    constant c_52_ZEROS : std_logic_vector(51 downto 0) := (others => '0');
    constant c_CB_FRAME : std_logic_vector(63 downto 0) := c_AURORA_IDLE & "0001" & c_52_ZEROS;   

    signal clk_rx_i : std_logic := '0';    
    constant RX_CLK_PERIOD : time := 6.4ns; 
    
    signal rx_cb_din : rx_data_array(g_NUM_LANES-1 downto 0);
    signal rx_cb_header : rx_header_array(g_NUM_LANES-1 downto 0);
    signal rx_cb_dvalid : std_logic_vector(g_NUM_LANES-1 downto 0);
    signal rx_cb_status : rx_status_array(g_NUM_LANES-1 downto 0);
    signal rx_cb_dout : rx_data_array(g_NUM_LANES-1 downto 0);
    signal rx_cb_header_o : rx_header_array(g_NUM_LANES-1 downto 0);
    signal rx_cb_dvalid_o : std_logic_vector(g_NUM_LANES-1 downto 0);
    signal rx_empty_o : std_logic_vector(g_NUM_LANES-1 downto 0);
    signal rx_read_i : std_logic_vector(g_NUM_LANES-1 downto 0);
    signal counter : unsigned(1 downto 0) := "00";
    
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
            rx_data_i       => rx_cb_din,
            rx_header_i     => rx_cb_header,
            rx_valid_i      => rx_cb_dvalid,
            rx_stat_i       => rx_cb_status,
            active_lanes_i    => (others => '1'),
            rx_read_i       => rx_read_i,
            rx_data_o       => rx_cb_dout,
            rx_empty_o      => rx_empty_o
    );
    
    pr_incr_cnt : process(clk_rx_i)
    begin
        if rising_edge(clk_rx_i) then
            counter <= counter + 1;
        end if;
    end process;

    pr_set_input : process(clk_rx_i)
    begin
        if rising_edge(clk_rx_i) then
            if (counter = "00") then
                rx_cb_din(0) <= c_CB_FRAME;
                rx_cb_header(0) <= "10";
                rx_cb_din(1) <= (others => '0');
                rx_cb_header(1) <= "01";
                rx_read_i <= "00";
            elsif (counter = "01") then
                rx_cb_din(0) <= (others => '0');
                rx_cb_header(0) <= "01";
                rx_cb_din(1) <= c_CB_FRAME;
                rx_cb_header(1) <= "10";
                rx_read_i <= "11";
            else
                rx_cb_din(0) <= (others => '1');
                rx_cb_header(0) <= "01";
                rx_cb_din(1) <= (others => '1');
                rx_cb_header(0) <= "01";
                rx_read_i <= "00";
            end if;
        end if;
    end process;
                 
end Behavioral;
