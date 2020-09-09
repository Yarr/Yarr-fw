-- ####################################
-- # Project: Yarr
-- # Author: Lauren Choquer
-- # E-Mail: choquerlauren@gmail.com
-- # Comments: Receives trig pattern, 
-- #    outputs RD53A trig encoding
-- ####################################

library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity encoder is 
    port (
        pattern_i   : in std_logic_vector(3 downto 0);

        code_o      : out std_logic_vector(7 downto 0)  
    );
end encoder;

architecture behavioral of encoder is

begin

    code_o <=           "0010_1011" when pattern_i <= "0001"
                else    "0010_1101" when pattern_i <= "0010"
                else    "0010_1110" when pattern_i <= "0011"

                else    "0011_0011" when pattern_i <= "0100"
                else    "0011_0101" when pattern_i <= "0101"
                else    "0011_0110" when pattern_i <= "0110"
                else    "0011_1001" when pattern_i <= "0111"
                else    "0011_1010" when pattern_i <= "1000"
                else    "0011_1100" when pattern_i <= "1001"

                else    "0100_1011" when pattern_i <= "1010"
                else    "0100_1101" when pattern_i <= "1011"
                else    "0100_1110" when pattern_i <= "1100"

                else    "0101_0011" when pattern_i <= "1101"
                else    "0101_0101" when pattern_i <= "1110"
                else    "0101_0110" when pattern_i <= "1111";

end behavioral;