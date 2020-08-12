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
    generic (
        g_WIDTH : integer := 1
    );    
    port (
        clk_s     : in std_logic;     --source clock
        clk_d     : in std_logic;     --destination clock
        rst_n     : in std_logic;     --active low reset

        --Signal ports
        di       : in std_logic_vector(g_WIDTH-1 downto 0);    --data in
        do       : out std_logic_vector(g_WIDTH-1 downto 0)    --data out
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
    signal valid 		: std_logic;
    signal transfer_data : std_logic_vector(g_WIDTH-1 downto 0);
begin

    --Process to assign valid bit, and copy input data to transfer region
    pr_set_valid : process(clk_s, rst_n)
    begin
        if (rst_n = '0') then
            transfer_data <= (others => '0');
            valid <= '0';
        elsif rising_edge(clk_s) then
            if (busy = '0' and valid = '0') then
                transfer_data <= di;
                valid <= '1';
            elsif (ack_prev = '1') then
                valid <= '0';
            end if;
        end if;
    end process pr_set_valid;

    --Process to assign the request signal high and begin the handshake
	pr_set_req : process(clk_s, rst_n) 
	begin
	    if (rst_n = '0') then
            req 	<= '0';
        elsif rising_edge(clk_s) then
            if(busy = '0' and valid = '1') then
                    req 	<= '1';
            elsif(ack_prev = '1') then
                    req 	<= '0';
            end if;
        end if;
	end process pr_set_req;

	--Process to update old and new request values using 
	--destination clock domain
	pr_request : process(clk_d, rst_n)
	begin
	   if (rst_n = '0') then
		    req_prev 	<= '0';
		    req_new 	<= '0';
		    req_pipe	<= '0';
	   elsif rising_edge(clk_d) then
		    req_prev	<= req_new;
		    req_new 	<= req_pipe;
		    req_pipe 	<= req;
	   end if;
	end process pr_request;

	--Process to pass new request to ack. using
	--source clock domain 
	pr_ack : process(clk_s, rst_n)
	begin
	   if (rst_n = '0') then
	      	ack_prev 	<= '0';
		    ack	        <= '0';
	   elsif rising_edge(clk_s) then
	      	ack_prev	<= ack;
            ack 	    <= req_prev; --using prev req to prevent ack from 
                                     --going high before transfer is complete
	   end if;
	end process pr_ack;

	--Process to assign intermediate enable signal, do,
	--which gets passed to enable_i in cmp_sport port map  
	pr_enable : process(clk_d, rst_n)
	begin
	   if (rst_n = '0') then
	      	do <= (others =>'0');
       elsif rising_edge(clk_d) then
            if(req_prev = '0' and req_new = '1') then
                do <= transfer_data;
            end if;
	   end if;
	end process pr_enable;

    --Do not initiate a new transfer until the current one is completed
    busy <= req or ack_prev;
    
end rtl;
