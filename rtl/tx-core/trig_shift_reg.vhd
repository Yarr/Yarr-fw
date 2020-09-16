-- ####################################
-- # Project: Yarr
-- # Author: Lauren Choquer
-- # E-Mail: choquerlauren@gmail.com
-- # Comments: 8b-wide shift reg for  
-- # storing trigger pulses to be encoded
-- ####################################

library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity trig_shift_reg is 
    generic (
        g_DATA_WIDTH : integer := 4
    );
    port (
        clk_i   : in std_logic;   --160 MHz
        rst_n_i : in std_logic;

        shift_i : in std_logic;   --Only shift bits when this input high
        data_i  : in std_logic;
        rd_en_i : in std_logic;   --For reading when register fills

        data_o  : out std_logic_vector(g_DATA_WIDTH-1 downto 0) 
    );
end trig_shift_reg;

architecture behavioral of trig_shift_reg is

    signal sreg : std_logic_vector(g_DATA_WIDTH-1 downto 0);
begin

    pr_shift : process(clk_i, rst_n_i, shift_i)
    begin
        if(rst_n_i = '0') then
            sreg <= (others => '0');
        elsif rising_edge(clk_i) then
            if(shift_i = '1') then 
                sreg(g_DATA_WIDTH-1 downto 0) <= sreg(g_DATA_WIDTH-2 downto 0) & data_i;
            end if;
        end if;
    end process;

    pr_output : process(clk_i, rst_n_i, rd_en_i)
    begin
        if (rst_n_i = '0') then
            data_o <= (others => '0');
        elsif rising_edge(clk_i) then
            if (rd_en_i = '1') then
                data_o <= sreg(g_DATA_WIDTH-1 downto 0);
            end if;
        end if;
    end process;


end behavioral;