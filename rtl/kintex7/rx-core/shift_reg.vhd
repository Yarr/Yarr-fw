
library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library unisim ;
use unisim.vcomponents.all ;

entity shift_reg is
    generic (
        sr_depth : integer := 2;
        sr_width : integer := 64
    );
    port (
        clk : in std_logic;
        din : in std_logic_vector(sr_width-1 downto 0);
        dout : out std_logic_vector(sr_width-1 downto 0)
    );
end;

architecture rtl of shift_reg is

    type sr_type is array (sr_depth-2 downto 0) of std_logic_vector(sr_width-1 downto 0);
    signal sr : sr_type;

begin

    pr_slicing : process(clk)
    begin
        if rising_edge(clk) then
            sr <= sr(sr'high-1 downto sr'low) & din;
            dout <= sr(sr'high);
        end if;
    end process;

end architecture rtl;