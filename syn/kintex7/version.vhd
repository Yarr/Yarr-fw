library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

package version_pkg is
    constant c_FW_VERSION : std_logic_vector(31 downto 0) := x"08a9cdd6";
end version_pkg;
