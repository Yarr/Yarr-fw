-- ####################################
-- # Project: Yarr
-- # Author: Timon Heim
-- # E-Mail: timon.heim at cern.ch
-- # Comments: RX channel
-- # Aurora style rx code
-- ####################################

library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library unisim ;
use unisim.vcomponents.all ;

library work;
use work.aurora_rx_pkg.all;

entity simple_aurora_rx_channel is
    generic (
        g_NUM_LANES : integer range 1 to 4 := 1
    );
    port (
        -- Sys connect
        rst_n_i : in std_logic;
        clk_rx_i : in std_logic; -- Fabric clock (serdes/8)
        
        -- Input
        rx_data       : in rx_data_array(g_NUM_LANES-1 downto 0);
        rx_header     : in rx_header_array(g_NUM_LANES-1 downto 0);
        rx_data_valid : in std_logic_vector(g_NUM_LANES-1 downto 0);

        -- Output
        rx_data_o : out std_logic_vector(63 downto 0);
        rx_valid_o : out std_logic;
        rx_stat_o : out std_logic_vector(7 downto 0)
    );
end simple_aurora_rx_channel;

architecture behavioral of simple_aurora_rx_channel is

	function log2_ceil(val : integer) return natural is
		 variable result : natural;
	begin
		 for i in 0 to g_NUM_LANES-1 loop
			 if (val <= (2 ** i)) then
				 result := i;
				 exit;
			 end if;
		 end loop;
		 return result;
	end function;	

    -- component aurora_rx_lane
    --     port (
    --     -- Sys connect
    --     rst_n_i : in std_logic;
    --     clk_rx_i : in std_logic;
    --     clk_serdes_i : in std_logic;

    --     -- Input
    --     rx_data_i_p : in std_logic;
    --     rx_data_i_n : in std_logic;
    --     rx_polarity_i : in std_logic;

    --     -- Output
    --     rx_data_o : out std_logic_vector(63 downto 0);
    --     rx_header_o : out std_logic_vector(1 downto 0);
    --     rx_valid_o : out std_logic;
    --     rx_stat_o : out std_logic_vector(7 downto 0)
    -- );
    -- end component aurora_rx_lane;
    
    component rr_arbiter
        generic (
            g_CHANNELS : integer := g_NUM_LANES
        );
        port (
            -- sys connect
            clk_i : in std_logic;
            rst_i : in std_logic;
            -- requests
            req_i : in std_logic_vector(g_NUM_LANES-1 downto 0);
            -- grants
            gnt_o : out std_logic_vector(g_NUM_LANES-1 downto 0)
        );
    end component rr_arbiter;
    
    component channel_bonding is
        generic (
        g_NUM_LANES : integer range 1 to 4 := 1
        );
        port (
            clk             : in std_logic;
            -- Input
            enable_i        : in std_logic;
            rx_data_i       : in rx_data_array(g_NUM_LANES-1 downto 0);
            rx_header_i     : in rx_header_array(g_NUM_LANES-1 downto 0);
            rx_valid_i      : in std_logic_vector(g_NUM_LANES-1 downto 0);
            active_lanes_i  : in std_logic_vector(g_NUM_LANES-1 downto 0);
            rx_read_i       : in std_logic_vector(g_NUM_LANES-1 downto 0);

            -- Output
            rx_data_o       : out rx_data_array(g_NUM_LANES-1 downto 0);  
            rx_empty_o      : out std_logic_vector(g_NUM_LANES-1 downto 0)   
        );
    end component;
    
    constant c_ALL_ZEROS : std_logic_vector(g_NUM_LANES-1 downto 0) := (others => '0');
       
    signal rx_data_s : std_logic_vector(63 downto 0);
    signal rx_valid_s : std_logic;

    --Aurora Lane signals
    signal rx_data : rx_data_array(g_NUM_LANES-1 downto 0);
    signal rx_header : rx_header_array(g_NUM_LANES-1 downto 0);
    signal rx_status : rx_status_array(g_NUM_LANES-1 downto 0);    
    -- signal rx_polarity : std_logic_vector(g_NUM_LANES-1 downto 0);
    signal rx_data_valid : std_logic_vector(g_NUM_LANES-1 downto 0);

    --Channel Bonding signals
    signal rx_cb_din        : rx_data_array(g_NUM_LANES-1 downto 0);
    signal rx_cb_header     : rx_header_array(g_NUM_LANES-1 downto 0);
    signal rx_cb_status     : rx_status_array(g_NUM_LANES-1 downto 0);
    signal rx_cb_dvalid     : std_logic_vector(g_NUM_LANES-1 downto 0);
    signal rx_cb_dout       : rx_data_array(g_NUM_LANES-1 downto 0);
    signal rx_cb_empty      : std_logic_vector(g_NUM_LANES-1 downto 0);
    signal rx_rden          : std_logic_vector(g_NUM_LANES-1 downto 0);
    signal rx_rden_t        : std_logic_vector(g_NUM_LANES-1 downto 0);
     
    signal channel : integer range 0 to g_NUM_LANES-1;
    
    COMPONENT ila_rx_dma_wb
    PORT (
        clk : IN STD_LOGIC;
        probe0 : IN STD_LOGIC_VECTOR(63 DOWNTO 0); 
        probe1 : IN STD_LOGIC_VECTOR(63 DOWNTO 0); 
        probe2 : IN STD_LOGIC_VECTOR(3 DOWNTO 0); 
        probe3 : IN STD_LOGIC_VECTOR(3 DOWNTO 0); 
        probe4 : IN STD_LOGIC_VECTOR(3 DOWNTO 0); 
        probe5 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
		probe6 : IN STD_LOGIC_VECTOR(1 DOWNTO 0); 
        probe7 : IN STD_LOGIC_VECTOR(1 DOWNTO 0)
    );
    END COMPONENT  ;
            
begin

    rx_data_o <= rx_data_s;
    rx_valid_o <= rx_valid_s;
	
	-- Arbiter
	cmp_rr_arbiter : rr_arbiter port map (
		clk_i => clk_rx_i,
		rst_i => not rst_n_i,
		req_i => not rx_cb_empty,
		gnt_o => rx_rden_t
	);
	
	reg_proc : process(clk_rx_i, rst_n_i)
    begin
        if (rst_n_i = '0') then
            rx_rden <= (others => '0');
            rx_data_s <= (others => '0');
            rx_valid_s <= '0';
            channel <= 0;            
            --rx_polarity <= (others => '0');
        elsif rising_edge(clk_rx_i) then
            rx_rden <= rx_rden_t;
            --rx_polarity <= rx_polarity_i;
            channel <= log2_ceil(to_integer(unsigned(rx_rden_t)));
            if (unsigned(rx_rden) = 0 or ((rx_rden and rx_cb_empty) = rx_rden)) then
                rx_valid_s <= '0';
                rx_data_s <= x"DEADBEEFDEADBEEF";
            else
                rx_valid_s <= '1';
                rx_data_s <= rx_cb_dout(channel);
            end if;
        end if;
    end process reg_proc;
    
    lane_loop: for I in 0 to g_NUM_LANES-1 generate
        lane_cmp : aurora_rx_lane port map (
            rst_n_i => rst_n_i,
            clk_rx_i => clk_rx_i,
            clk_serdes_i => clk_serdes_i,
            rx_data_i_p => rx_data_i_p(I),
            rx_data_i_n => rx_data_i_n(I),
            rx_polarity_i => rx_polarity(I),
            rx_data_o => rx_data(I),
            rx_header_o => rx_header(I),
            rx_valid_o => rx_data_valid(I),
            rx_stat_o => rx_status(I)
        );
        rx_stat_o(I) <= rx_status(I)(1); 

    end generate lane_loop;

    cmp_channel_bond : channel_bonding
        generic map (g_NUM_LANES => g_NUM_LANES)
        port map (
            clk             => clk_rx_i,
            enable_i        => enable_i,
            rx_data_i       => rx_data,
            rx_header_i     => rx_header,
            rx_valid_i      => rx_data_valid,
            active_lanes_i  => "1111",
            rx_read_i       => rx_rden,
            rx_data_o       => rx_cb_dout,
            rx_empty_o      => rx_cb_empty
    );

    cmp_channel_bond : channel_bonding
        generic map (g_NUM_LANES => g_NUM_LANES)
        port map (
            clk             => clk_rx_i,
            rx_data_i       => rx_data,
            rx_header_i     => rx_header,
            rx_valid_i      => rx_data_valid,
            active_lanes_i  => "1111",
            rx_read_i       => rx_rden,
            rx_data_o       => rx_cb_dout,
            rx_empty_o      => rx_cb_empty
    );
    
   aurora_channel_debug : ila_rx_dma_wb
   PORT MAP (
     clk => clk_rx_i,
     probe0 => rx_cb_din(0), 
     probe1 => rx_cb_dout(0), 
     probe2 => rx_cb_empty, 
     probe3 => rx_rden_t,
     probe4 => rx_rden,
     probe5(0) => rx_valid_s,
     probe6 => rx_header(0),
     probe7 => rx_header(1)
   );
    
end behavioral;
