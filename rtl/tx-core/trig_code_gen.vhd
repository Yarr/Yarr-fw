-- ####################################
-- # Project: Yarr
-- # Author: Lauren Choquer
-- # E-Mail: choquerlauren@gmail.com
-- # Comments: Converts trigger pulses 
-- #    into RD53A trig encoding
-- ####################################

library IEEE;
use ieee.std_logic_1164.all;
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
    port (
        clk_i   : in std_logic;   --160 MHz
        rst_n_i : in std_logic;

        shift_i : in std_logic;   --Only shift bits when this input high
        data_i  : in std_logic;
        rd_en_i : in std_logic;   --For reading when register fills

        data_o  : out std_logic_vector(7 downto 0) 
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

    signal pulse_prev : std_logic;
    signal pulse_edge : std_logic;

    signal shift : std_logic;
    signal sr_rd_en : std_logic;
    signal trig_bit : std_logic;  

    signal sr_word_o : std_logic_vector(7 downto 0);

begin

    --Shift trig_bit into reg at the end of each bunch crossing
    shift <= (counter4 = "11");
    sr_rd_en <= (counter32 = "11111");

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

    pr_pulse : process(clk_i)
    begin
        if rising_edge(clk_i) then
            pulse_prev <= pulse_i;
        end if;
    end process;

    --Detecting rising edge of pulse
    pulse_edge <= pulse_i and (not pulse_prev);

    pr_trig_bit : process(clk_i)
    begin
        if rising_edge(clk_i) then
            if (pulse_edge = '1') then
                trig_bit <= '1';
            elsif (counter4 = '0') then
                trig_bit <= '0';
            end if;
        end if;
    end process;

    cmp_sr : trig_shift_reg PORT MAP(
        clk_i   => clk_i,
        rst_n_i => rst_n_i,
        shift_i => shift,
        data_i  => trig_bit,
        rd_en_i => sr_rd_en,
        data_o  => sr_word_o
    );

    cmp_code1 : encoder PORT MAP(
        pattern_i => sr_word_o(7 downto 4),
        code_o => code_o(15 downto 8)
    );

    cmp_code2 : encoder PORT MAP(
        pattern_i => sr_word_o(3 downto 0),
        code_o => code_o(7 downto 0)
    );


end behavioral;