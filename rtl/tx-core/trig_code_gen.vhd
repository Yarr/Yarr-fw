-- ####################################
-- # Project: Yarr
-- # Author: Lauren Choquer
-- # E-Mail: choquerlauren@gmail.com
-- # Comments: Converts trigger pulses 
-- #    into RD53A trig encoding
-- ####################################

library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;
use ieee.numeric_std.all;

entity trig_code_gen is 
    port (
        clk_i       : in std_logic;
        rst_n_i     : in std_logic;

        enable_i    : in std_logic;
        pulse_i     : in std_logic;

        code_o      : out std_logic_vector(15 downto 0)  --two 8-bit encodings
    );
end trig_code_gen;

architecture behavioral of trig_code_gen is

    component trig_shift_reg
    generic (
        g_DATA_WIDTH : integer
    ); 
    port (
        clk_i   : in std_logic;   --160 MHz
        rst_n_i : in std_logic;

        shift_i : in std_logic;   --Only shift bits when this input high
        data_i  : in std_logic;
        rd_en_i : in std_logic;   --For reading when register fills

        data_o  : out std_logic_vector(g_DATA_WIDTH-1 downto 0) 
    );
    end component;

    component encoder
    port (
        pattern_i   : in std_logic_vector(3 downto 0);
        code_o      : out std_logic_vector(7 downto 0)  
    );
    end component;

    signal counter4 : unsigned(1 downto 0);
    signal counter32 : unsigned(4 downto 0);

    signal reg8_shift : std_logic;
    signal reg4_rd_en : std_logic;   --for reading 4b shift reg
    signal reg8_rd_en : std_logic;   --for reading 8b shift reg

    signal trig_bit : std_logic;  

    signal reg4_word_o : std_logic_vector(3 downto 0);
    signal reg8_word_o : std_logic_vector(7 downto 0);

begin

    --Increment counters for bunch crossing (4) and reg filling (32)
    pr_incr_cnt : process(clk_i)
    begin
        if (rst_n_i = '0') then
            counter4 <= (others => '0');
            counter32 <= (others => '0');
        elsif rising_edge(clk_i) then
            counter4 <= counter4 + 1;
            counter32 <= counter32 + 1;
        end if;
    end process;
    
    --Shift trig_bit into reg at the end of each bunch crossing
    pr_enable_sr : process(counter4, counter32)
    begin
        if (counter4 = "11") then
            reg8_shift <= '1';
        else
            reg8_shift <= '0';
        end if;

        if (counter4 = "00") then
            reg4_rd_en <= '1';
        else
            reg4_rd_en <= '0';
        end if;
        
        if (counter32 = "00000") then
            reg8_rd_en <= '1';
        else
            reg8_rd_en <= '0';
        end if;
    end process;

    trig_bit <= or_reduce(reg4_word_o);  --computes an OR of all bits in vector

    cmp_sr4 : trig_shift_reg 
    GENERIC MAP (g_DATA_WIDTH => 4)
    PORT MAP(
        clk_i   => clk_i,
        rst_n_i => rst_n_i,
        shift_i => '1',
        data_i  => pulse_i,
        rd_en_i => reg4_rd_en,
        data_o  => reg4_word_o
    );

    cmp_sr8 : trig_shift_reg 
    GENERIC MAP (g_DATA_WIDTH => 8)
    PORT MAP(
        clk_i   => clk_i,
        rst_n_i => rst_n_i,
        shift_i => reg8_shift,
        data_i  => trig_bit,
        rd_en_i => reg8_rd_en,
        data_o  => reg8_word_o
    );

    cmp_code1 : encoder PORT MAP(
        pattern_i => reg8_word_o(7 downto 4),
        code_o => code_o(15 downto 8)
    );

    cmp_code2 : encoder PORT MAP(
        pattern_i => reg8_word_o(3 downto 0),
        code_o => code_o(7 downto 0)
    );


end behavioral;