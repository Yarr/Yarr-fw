----------------------------------------------------------------------------
--  Project : Yarr
--  File    : trig_code_gen.vhd
--  Author  : Lauren Choquer
--  E-Mail  : choquerlauren@gmail.com
--  Comments: Converts trigger pulses into RD53A trig encoding
----------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
use     ieee.std_logic_misc.all;
use     ieee.numeric_std.all;

entity trig_code_gen is 
    port (
        clk_i        : in  std_logic;
        rst_n_i      : in  std_logic;

        enable_i     : in  std_logic;
        pulse_i      : in  std_logic;

        code_o       : out std_logic_vector(31 downto 0);  -- two 16-bit code words
        code_ready_o : out std_logic 
    );
end trig_code_gen;

----------------------------------------------------------------------------
-- Architecture for synthesis
----------------------------------------------------------------------------
architecture behavioral of trig_code_gen is

    -- Trigger encoding. Converts 4-bit pattern into an 8-bit code
    component trig_encoder
        port (
            pattern_i   : in  std_logic_vector(3 downto 0);
            code_o      : out std_logic_vector(7 downto 0)  
        );
    end component;
    
    -- Tag encoding. Converts 6-bit base tag into an 8-bit code
    component tag_encoder
        port (
            base_tag_i  : in unsigned(5 downto 0);
            code_o      : out std_logic_vector(7 downto 0)
          );
    end component;


    signal trig_cntr     : unsigned(1 downto 0);
    signal command_cntr  : unsigned(2 downto 0);

    signal trig_sreg    : std_logic_vector(3 downto 0);
    signal trig_word    : std_logic_vector(3 downto 0);
    signal trig_bit     : std_logic;

    signal command_sreg     : std_logic_vector(7 downto 0);
    signal command_word     : std_logic_vector(7 downto 0);
    signal trig_encoding    : std_logic_vector(7 downto 0); 
    
    constant c_MAX_TAG      : integer := 49;
    signal base_tag         : unsigned(5 downto 0);
    signal tag_encoding     : std_logic_vector(7 downto 0);

    signal code_word       : std_logic_vector (15 downto 0);
    signal first_word      : std_logic_vector (15 downto 0);
    signal first_word_done : std_logic;
    
    signal code_s       : std_logic_vector (31 downto 0);
    signal code_ready_s : std_logic;
begin

    ----------------------------------------------------------------------------
    -- Increment counters for bunch crossing (4) and reg filling (8)
    -- Counter wrap to zero is inferred not explicit.
    ----------------------------------------------------------------------------
    pr_incr_cnt : process (rst_n_i, clk_i)
    begin

        if (rst_n_i = '0') then
            trig_cntr <= (others=>'0');
            command_cntr <= (others=>'0');
        elsif rising_edge(clk_i) then
            trig_cntr <= trig_cntr + 1;

            if (trig_cntr = "11") then
                command_cntr <= command_cntr + 1;
            end if;
        end if;

    end process;
    

    ----------------------------------------------------------------------------
    -- Shift register for input pulse. Shifted every clock cycle
    ----------------------------------------------------------------------------
    pr_trig_sreg : process (rst_n_i, clk_i)
    begin
    
        if (rst_n_i = '0') then
            trig_sreg   <= (others=>'0');
        elsif rising_edge(clk_i) then
            trig_sreg   <= trig_sreg(2 downto 0) & pulse_i;
        end if;

    end process;

    
    ----------------------------------------------------------------------------
    -- Change trig_word when trig_cntr is zero 
    -- ** Warning :  non-clocked process **
    ----------------------------------------------------------------------------
    pr_trig_cntr : process (trig_cntr)
    begin

        if (trig_cntr = "00") then
            trig_word <= trig_sreg;
        else
            trig_word <= trig_word;
        end if;

    end process;
        
    trig_bit <= or_reduce(trig_word);  -- Computes an OR of all bits in trig_word


    ----------------------------------------------------------------------------
    -- Shift trig_bit into command_sreg at the end of each bunch crossing
    ----------------------------------------------------------------------------
    pr_command_sreg : process (rst_n_i, clk_i)
    begin
    
        if (rst_n_i = '0') then
            command_sreg    <= (others=>'0');
        elsif rising_edge(clk_i) then
            if (trig_cntr = "11") then
                command_sreg    <= command_sreg(6 downto 0) & trig_bit;
            end if;
        end if;
        
    end process;
    
    ----------------------------------------------------------------------------
    -- change command_word when command_cntr is zero 
    -- ** Warning :  non-clocked process **
    ----------------------------------------------------------------------------
    pr_command_word : process (command_cntr)
    begin
    
        if (command_cntr = "000") then
            command_word <= command_sreg;
        else
            command_word <= command_word;
        end if;

    end process;
    
    ----------------------------------------------------------------------------
    -- Set the tag that will be used in the current command word
    ----------------------------------------------------------------------------
    pr_command_tag : process (rst_n_i, clk_i)
    begin
    
        if (rst_n_i = '0') then
            base_tag <= (others => '0');
        elsif rising_edge(clk_i) then
            if (command_cntr = "000" and trig_cntr = "00" and first_word_done = '0') then
                if (base_tag < c_MAX_TAG) then
                    base_tag <= base_tag + 1;
                else 
                    base_tag <= (others => '0');
                end if;
            end if;
        end if;
    
    end process;
    
    -- Set the current command word
    code_word <= trig_encoding & tag_encoding;
    
    ----------------------------------------------------------------------------
    -- change first_words and assert first_word_done when the first of the next
    -- two code words is ready. first_word_done is deasserted when the second
    -- code word is ready
    -- ** Warning :  non-clocked process **
    ----------------------------------------------------------------------------
    pr_first_word : process (rst_n_i, command_cntr)
    begin
    
        if (rst_n_i = '0') then
            first_word <= trig_encoding & x"00";
            first_word_done <= '0';
        elsif (command_cntr = "001") then
            if (first_word_done = '1') then
                first_word <= first_word;
                first_word_done <= '0';
            else
                first_word <= code_word;
                first_word_done <= '1';
            end if;
        else
            first_word <= first_word;
            first_word_done <= first_word_done;
        end if;
    
    end process;
    
    ----------------------------------------------------------------------------
    -- change code_s and assert code_ready_s when the next two code words are 
    -- ready. code_read_s should remain asserted for 32 clock cycles
    -- ** Warning :  non-clocked process **
    ----------------------------------------------------------------------------
    pr_code_s : process (rst_n_i, command_cntr)
    begin
    
        if (rst_n_i = '0') then
            code_s <= trig_encoding & x"00" & trig_encoding & x"00";
            code_ready_s <= '0';
        elsif (command_cntr = "001") then
            if (first_word_done = '1') then
                code_s <= first_word & code_word;
                code_ready_s <= enable_i;
            else
                code_s <= code_s;
                code_ready_s <= '0';
            end if;
        else
            code_s <= code_s;
            code_ready_s <= code_ready_s;
        end if;
        
    end process;
    
    -- Set the output signals
    code_o <= code_s;
    code_ready_o <= code_ready_s;

    ----------------------------------------------------------------------------
    --  Encode upper 4 bits of command_word
    -- ** Warning : code_o is a block output from this asychronous block **
    ----------------------------------------------------------------------------
    cmp_trig_encoder : trig_encoder 
    port map (
        pattern_i   => command_word(7 downto 4),
        code_o      => trig_encoding
    );
    
    cmp_tag_encoder : tag_encoder
    port map (
        base_tag_i  => base_tag,
        code_o      => tag_encoding
    );


end behavioral;
