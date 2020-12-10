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

    code_o <=           "00101011" when pattern_i <= "0001"
                else    "00101101" when pattern_i <= "0010"
                else    "00101110" when pattern_i <= "0011"

                else    "00110011" when pattern_i <= "0100"
                else    "00110101" when pattern_i <= "0101"
                else    "00110110" when pattern_i <= "0110"
                else    "00111001" when pattern_i <= "0111"
                else    "00111010" when pattern_i <= "1000"
                else    "00111100" when pattern_i <= "1001"

                else    "01001011" when pattern_i <= "1010"
                else    "01001101" when pattern_i <= "1011"
                else    "01001110" when pattern_i <= "1100"

                else    "01010011" when pattern_i <= "1101"
                else    "01010101" when pattern_i <= "1110"
                else    "01010110" when pattern_i <= "1111";

end behavioral;