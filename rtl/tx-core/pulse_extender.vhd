----------------------------------------------------------------------------
--  Project : Yarr
--  File    : trig_extender.vhd
--  Author  : Lucas Cendes
--  E-Mail  : lucascendes@gmail.com
--  Comments: Extends a trigger for the specified number of cycles
----------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
use     ieee.std_logic_misc.all;
use     ieee.numeric_std.all;

entity pulse_extender is 
    generic (
        g_INTERVAL_WIDTH : integer := 32
    );
    port (
        clk_i          : in  std_logic;
        rst_n_i        : in  std_logic;

        pulse_i        : in std_logic; 
        ext_interval_i : in std_logic_vector (g_INTERVAL_WIDTH-1 downto 0);
        
        ext_pulse_o    : out std_logic
    );
end pulse_extender;

architecture behavioral of pulse_extender is

    signal cycle_counter : unsigned (g_INTERVAL_WIDTH-1 downto 0);

begin

    ----------------------------------------------------------------------------
    -- Counter that keeps track of the number of cycles in which the ouput
    -- should be held high. The value of the counter is set whenever the current
    -- value of the counter is 0 and a trigger pulse is received
    ----------------------------------------------------------------------------
    pr_cycle_counter : process (rst_n_i, clk_i)
    begin
    
        if (rst_n_i = '0') then
            cycle_counter <= (others => '0');
        elsif rising_edge(clk_i) then
            if (cycle_counter = 0) then
                if (pulse_i = '1') then
                    cycle_counter <= unsigned(ext_interval_i);
                end if;
             else
                cycle_counter <= cycle_counter - 1;
             end if;                
        end if;
    
    end process;
    
    ----------------------------------------------------------------------------
    -- Sets the output based on the value of the counter. A counter value will
    -- result in triggers being passed directly to the output without being 
    -- extended
    ----------------------------------------------------------------------------
    pr_ext_pulse_o : process (rst_n_i, clk_i)
    begin
    
        if (rst_n_i = '0') then
            ext_pulse_o <= '0';
        elsif rising_edge(clk_i) then
            if (cycle_counter > 0) then
                ext_pulse_o <= '1';
            else
                ext_pulse_o <= pulse_i;
            end if;
        end if; 
    
    end process;

end behavioral;
