-- ####################################
-- # Project: Yarr
-- # Author: Lauren Choquer
-- # E-Mail: choquerlauren@gmail.com
-- # Comments: Handshake protocol for crossing
-- #           wishbone clock domain
-- ####################################

library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.board_pkg.all;

entity handshake is
    port (
        clk_src     : in std_logic;     --source clock
        clk_dst     : in std_logic;     --destination clock
        rst_n_i     : in std_logic;     --active low reset

        --Signal ports
        sig_i       : in std_logic;
        sig_o       : out std_logic
    );
end handshake;

architecture rtl of handshake is
    --signals for handshake protocol
    signal req_prev 	: std_logic;
    signal req_new	    : std_logic;
    signal req 		    : std_logic;
    signal req_pipe	    : std_logic;
    signal ack_prev 	: std_logic;
    signal ack 	        : std_logic;
    signal busy 		: std_logic;
begin

    --Handshake logic
	--Note: wb_clk_i is source clk, tx_clk_i is dest. clk
	pr_set_req : process(clk_src, rst_n_i) 
	begin
	   if (rst_n_i = '0') then
		    req 	<= '0';
	   elsif(busy = '0' and sig_i = '1') then
	      	req 	<= '1';
	   elsif(ack_prev = '1') then
	      	req 	<= '0';
	   end if;
	end process pr_set_req;

	--Process to update old and new request values using 
	--destination clock domain
	pr_request : process(clk_dst, rst_n_i)
	begin
	   if (rst_n_i = '0') then
		req_prev 	<= '0';
		req_new 	<= '0';
		req_pipe	<= '0';
	   elsif rising_edge(clk_dst) then
		req_prev	<= req_new;
		req_new 	<= req_pipe;
		req_pipe 	<= req;
	   end if;
	end process pr_request;

	--Process to pass new request to ack. using
	--source clock domain 
	pr_ack : process(clk_src, rst_n_i)
	begin
	   if (rst_n_i = '0') then
	      	ack_prev 	<= '0';
		    ack	        <= '0';
	   elsif rising_edge(clk_src) then
	      	ack_prev	<= ack;
	      	ack 	    <= req_new; 
	   end if;
	end process pr_ack;

	--Process to assign intermediate enable signal, sig_o,
	--which gets passed to enable_i in cmp_sport port map  
	pr_enable : process(clk_dst, rst_n_i)
	begin
	   if (rst_n_i = '0') then
	      	sig_o <= '0';
	   elsif rising_edge(clk_dst) then
	      	sig_o <= ((not req_prev) and (req_new));
	   end if;
	end process pr_enable;

    busy <= req or ack_prev;
    
end rtl;