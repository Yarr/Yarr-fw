
library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package aurora_rx_pkg is 
    type rx_data_array is array(natural range <>) of std_logic_vector(63 downto 0);
    type rx_header_array is array(natural range <>) of std_logic_vector(1 downto 0);
    type rx_status_array is array(natural range <>) of std_logic_vector(7 downto 0);

    constant c_DATA_HEADER : std_logic_vector(1 downto 0) := "01";
    constant c_CMD_HEADER : std_logic_vector(1 downto 0) := "10";
    constant c_AURORA_IDLE : std_logic_vector(7 downto 0) := x"78";
    constant c_AURORA_SEP : std_logic_vector(7 downto 0) := x"1E";
end package;