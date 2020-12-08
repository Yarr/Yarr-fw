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

        --enable_i    : in std_logic;
        pulse_i     : in std_logic;

        code_o      : out std_logic_vector(15 downto 0);  --two 8-bit encodings
        --code_ready_o : out std_logic
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
    signal counter8 : unsigned(2 downto 0);

    signal trig_vec : std_logic_vector(3 downto 0);
    signal trig_word : std_logic_vector(3 downto 0);
    signal trig_bit : std_logic;
    
    signal command_vec : std_logic_vector (7 downto 0);  
    signal command_word : std_logic_vector(7 downto 0);
begin

    --Increment counters for bunch crossing (4) and reg filling (32)
    pr_incr_cnt : process(clk_i)
    begin
        if (rst_n_i = '0') then
            counter4 <= (others => '0');
            counter8 <= (others => '0');
        elsif rising_edge(clk_i) then
            counter4 <= counter4 + 1;
            if (counter4 = "11") then
                counter8 <= counter8 + 1;
            end if;
        end if;
    end process;
    
    shift_vect : process (clk_i)
    begin
        if (rst_n_i = '0') then
            trig_vec <= (others => '0');
        elsif rising_edge(clk_i) then
            trig_vec(3 downto 0) <= trig_vec(2 downto 0) & pulse_i;
        end if;
    end process;

    trig_bit <= or_reduce(trig_word);  --computes an OR of all bits in vector
    
    shift_command : process (clk_i)
    begin
        if (rst_n_i = '0') then
            command_vec <= (others => '0');
        elsif (rising_edge(clk_i) and counter4 = "11") then
            command_vec(7 downto 0) <= command_vec(6 downto 0) & trig_bit;
        end if;
    end
    
    --Shift trig_bit into reg at the end of each bunch crossing
    pr_enable_sr : process(counter4, counter8)
    begin
        if (counter4 = "00") then
            trig_word <= trig_vec;
        else
            trig_word <= trig_word;
        end if;
        
        if (counter8 = "000") begin
            command_word <= command_vec;
        else
            command_word <= command_word
        end if;
    end process;
    

    cmp_code1 : encoder PORT MAP(
        pattern_i => command_word(7 downto 4),
        code_o => code_o(15 downto 8)
    );

    cmp_code2 : encoder PORT MAP(
        pattern_i => command_word(3 downto 0),
        code_o => code_o(7 downto 0)
    );


end behavioral;