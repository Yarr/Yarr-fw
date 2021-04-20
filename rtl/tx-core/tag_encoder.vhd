----------------------------------------------------------------------------
--  Project : Yarr
--  File    : tag_encoder.vhd
--  Author  : Lucas Cendes
--  E-Mail  : lucascendes@gmail.com
--  Comments: Outputs a RD53B tag encoding
----------------------------------------------------------------------------

library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tag_encoder is
      port (
        base_tag_i  : in unsigned(5 downto 0);
        code_o      : out std_logic_vector(7 downto 0)
      );
end tag_encoder;

architecture behavioral of tag_encoder is

begin
    
    code_o <=        x"6a" when base_tag_i <= 0
                else x"6c" when base_tag_i <= 1
                else x"71" when base_tag_i <= 2
                else x"72" when base_tag_i <= 3
                else x"74" when base_tag_i <= 4
                else x"8b" when base_tag_i <= 5
                else x"8d" when base_tag_i <= 6
                else x"8e" when base_tag_i <= 7
                else x"93" when base_tag_i <= 8
                else x"95" when base_tag_i <= 9
                else x"96" when base_tag_i <= 10
                else x"99" when base_tag_i <= 11
                else x"9a" when base_tag_i <= 12
                else x"9c" when base_tag_i <= 13
                else x"a3" when base_tag_i <= 14
                else x"a5" when base_tag_i <= 15
                else x"a6" when base_tag_i <= 16
                else x"a9" when base_tag_i <= 17
                else x"59" when base_tag_i <= 18
                else x"ac" when base_tag_i <= 19
                else x"b1" when base_tag_i <= 20
                else x"b2" when base_tag_i <= 21
                else x"b4" when base_tag_i <= 22
                else x"c3" when base_tag_i <= 23
                else x"c5" when base_tag_i <= 24
                else x"c6" when base_tag_i <= 25
                else x"c9" when base_tag_i <= 26
                else x"ca" when base_tag_i <= 27
                else x"cc" when base_tag_i <= 28
                else x"d1" when base_tag_i <= 29
                else x"d2" when base_tag_i <= 30
                else x"d4" when base_tag_i <= 31
                else x"63" when base_tag_i <= 32
                else x"5a" when base_tag_i <= 33
                else x"5c" when base_tag_i <= 34
                else x"aa" when base_tag_i <= 35
                else x"65" when base_tag_i <= 36
                else x"69" when base_tag_i <= 37
                else x"2b" when base_tag_i <= 38
                else x"2d" when base_tag_i <= 39
                else x"2e" when base_tag_i <= 40
                else x"33" when base_tag_i <= 41
                else x"35" when base_tag_i <= 42
                else x"36" when base_tag_i <= 43
                else x"39" when base_tag_i <= 44
                else x"3a" when base_tag_i <= 45
                else x"3c" when base_tag_i <= 46
                else x"4b" when base_tag_i <= 47
                else x"4d" when base_tag_i <= 48
                else x"4e" when base_tag_i <= 49
                else x"53" when base_tag_i <= 50
                else x"55" when base_tag_i <= 51
                else x"56" when base_tag_i <= 52
                else x"66" when base_tag_i <= 53;
              

end behavioral;
