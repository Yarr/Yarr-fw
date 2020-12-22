----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/09/2020 03:16:06 PM
-- Design Name: 
-- Module Name: trig_code_gen_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity trig_code_gen_tb is
--  Port ( );
end trig_code_gen_tb;

architecture Behavioral of trig_code_gen_tb is

    component trig_code_gen
    port (
        clk_i        : in std_logic;
        rst_n_i      : in std_logic;

        enable_i     : in std_logic;
        pulse_i      : in std_logic;

        code_o       : out std_logic_vector(15 downto 0);  --two 8-bit encodings
        code_ready_o : out std_logic
    );
    end component;
    
    signal clk_i : std_logic := '0';
    constant c_CLK_PERIOD : time := 6.5ns;
    
    signal pulse : std_logic;
    signal rst_n : std_logic;
    signal code : std_logic_vector(15 downto 0);
    signal code_ready : std_logic;
    signal counter : unsigned(5 downto 0) := "000000";
    
begin

    pr_clk : process
    begin
        clk_i <= '1';
        wait for c_CLK_PERIOD/2;
        clk_i <= '0';
        wait for c_CLK_PERIOD/2;
    end process;
    
    pr_counter : process(clk_i)
    begin
        if rising_edge(clk_i) then
            counter <= counter + 1;
        end if;
    end process;
    
--    pr_reset : process 
--    begin
--        rst_n <= '0';
--        wait for 1ns;
--        rst_n <= '1';
--    end process;
    
    rst_n <= '0', '1' after 6.5ns;
    
    dut_code_gen : trig_code_gen PORT MAP (
        clk_i => clk_i, 
        rst_n_i => rst_n, 
        enable_i => '1',
        pulse_i => pulse,
        code_o => code,
        code_ready_o => code_ready
    );
    
    pulse <=        '1' when counter <= 3
              else  '0' when counter <= 8
              else  '1' when counter <= 13
              else  '0' when counter <= 15
              else  '1' when counter <= 17
              else  '0' when counter <= 18;
    

end Behavioral;
