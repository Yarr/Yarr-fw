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
    clk_i       : in  std_logic;
    rst_n_i     : in  std_logic;

  --enable_i    : in  std_logic;     -- For future use. Not yet specified.
    pulse_i     : in  std_logic;

    code_o      : out std_logic_vector(15 downto 0)  -- Two 8-bit encodings
);
end trig_code_gen;

----------------------------------------------------------------------------
-- Architecture for synthesis
----------------------------------------------------------------------------
architecture behavioral of trig_code_gen is         -- TODO : Should really be called 'rtl' since this is not behavioral code

-- Trigger encoding. Converts 4-bit pattern into an 8-bit code
component trig_encoder
port (
    pattern_i   : in  std_logic_vector(3 downto 0);
    code_o      : out std_logic_vector(7 downto 0)  
);
end component;


signal trig_cntr     : unsigned(1 downto 0);
signal command_cntr  : unsigned(2 downto 0);

signal trig_sreg    : std_logic_vector(3 downto 0);
signal trig_word    : std_logic_vector(3 downto 0);
signal trig_bit     : std_logic;

signal command_sreg : std_logic_vector(7 downto 0);
signal command_word : std_logic_vector(7 downto 0);

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
    pr_command_cntr : process (command_cntr)
    begin
    
        if (command_cntr = "000") then
            command_word <= command_sreg;
        else
            command_word <= command_word;
        end if;

    end process;
    

    ----------------------------------------------------------------------------
    --  Encode upper 4 bits of command_word
    -- ** Warning : code_o is a block output from this asychronous block **
    ----------------------------------------------------------------------------
    cmp_trig_encoder_hi : trig_encoder 
    port map (
        pattern_i   => command_word(7 downto 4),
        code_o      => code_o(15 downto 8)
    );

    ----------------------------------------------------------------------------
    --  Encode lower 4 bits of command_word
    -- ** Warning : code_o is a block output from this asychronous block **
    ----------------------------------------------------------------------------
    cmp_trig_encoder_lo : trig_encoder 
    port map (
        pattern_i   => command_word(3 downto 0),
        code_o      => code_o(7 downto 0)
    );


end behavioral;
