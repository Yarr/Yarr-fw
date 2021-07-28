-- ####################################
-- # Project: Yarr
-- # Author: Timon Heim
-- # E-Mail: timon.heim at cern.ch
-- # Comments: Round robin arbiter, no priority
-- ####################################

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity rr_arbiter is
	generic (
        g_CHANNELS : integer := 16
    );
	port (
		-- sys connect
		clk_i : in std_logic;
		rst_i : in std_logic;
		
		-- requests
		req_i : in std_logic_vector(g_CHANNELS-1 downto 0);
		-- grant
		gnt_o : out std_logic_vector(g_CHANNELS-1 downto 0)
	);
		
end rr_arbiter;

architecture behavioral of rr_arbiter is
	signal req_t : std_logic_vector(g_CHANNELS-1 downto 0);
	signal masked_req : std_logic_vector(g_CHANNELS-1 downto 0);
	signal winner : std_logic_vector(g_CHANNELS-1 downto 0);
    signal isol_lsb : std_logic_vector(g_CHANNELS-1 downto 0);
	signal new_winner : std_logic_vector(g_CHANNELS-1 downto 0);
	signal old_winner : std_logic_vector(g_CHANNELS-1 downto 0);
	
begin
	-- Tie offs
    winner <= new_winner when (unsigned(masked_req) /= 0) else isol_lsb;
    
    isol_lsb <= req_i and(std_logic_vector(unsigned(not req_i)+1));
    masked_req <= req_i and not (std_logic_vector(unsigned(old_winner)-1) or old_winner);
	new_winner <= masked_req and (std_logic_vector(unsigned(not masked_req)+1));
	

	sampling_proc : process(clk_i, rst_i)
	begin
		if (rst_i = '1') then
			old_winner <= (others => '0');
			gnt_o <= (others => '0');
			req_t <= (others => '0');
		elsif rising_edge(clk_i) then
            req_t <= req_i;
            if (unsigned(req_i) /= 0) then
			    gnt_o <= winner;
                old_winner <= winner;
            else
                gnt_o <= (others => '0');
                old_winner <= (others => '0');
            end if;
		end if;
	end process sampling_proc;

end behavioral;

