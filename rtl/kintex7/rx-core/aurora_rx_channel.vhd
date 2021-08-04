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

package aurora_rx_pkg is
    constant c_AURORA_IDLE : std_logic_vector(7 downto 0) := x"78";
    constant c_AURORA_SEP : std_logic_vector(7 downto 0) := x"1E";
    constant c_DATA_HEADER : std_logic_vector(1 downto 0) := "01";
    constant c_CMD_HEADER : std_logic_vector(1 downto 0) := "10";

    type rx_data_array is array (natural range <>) of std_logic_vector(63 downto 0);
    type rx_header_array is array (natural range <>) of std_logic_vector(1 downto 0);
    type rx_status_array is array (natural range <>) of std_logic_vector(7 downto 0);
end package;

library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.aurora_rx_pkg.all;

library unisim ;
use unisim.vcomponents.all ;

entity aurora_rx_channel is
    generic (
        g_NUM_LANES : integer range 1 to 4 := 1
    );
    port (
        -- Sys connect
        rst_n_i : in std_logic;
        clk_rx_i : in std_logic; -- Fabric clock (serdes/8)
        clk_serdes_i : in std_logic; -- IO clock
        
        -- Input
        enable_i : in std_logic;
        rx_data_i_p : in std_logic_vector(g_NUM_LANES-1 downto 0);
        rx_data_i_n : in std_logic_vector(g_NUM_LANES-1 downto 0);
        rx_polarity_i : in std_logic_vector(g_NUM_LANES-1 downto 0);
        trig_tag_i : in std_logic_vector(63 downto 0);
        rx_active_lanes_i : in std_logic_vector(g_NUM_LANES-1 downto 0);

        -- Output
        rx_data_o : out std_logic_vector(63 downto 0);
        rx_valid_o : out std_logic;
        rx_stat_o : out std_logic_vector(7 downto 0)
    );
end aurora_rx_channel;

architecture behavioral of aurora_rx_channel is

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

	constant c_ALL_ZEROS : std_logic_vector(g_NUM_LANES-1 downto 0) := (others => '0');
	constant c_ALL_ONES : std_logic_vector(g_NUM_LANES-1 downto 0) := (others => '1');

    component aurora_rx_lane
        port (
        -- Sys connect
        rst_n_i : in std_logic;
        clk_rx_i : in std_logic;
        clk_serdes_i : in std_logic;

        -- Input
        rx_data_i_p : in std_logic;
        rx_data_i_n : in std_logic;
        rx_polarity_i : in std_logic;

        -- Output
        rx_data_o : out std_logic_vector(63 downto 0);
        rx_header_o : out std_logic_vector(1 downto 0);
        rx_valid_o : out std_logic;
        rx_stat_o : out std_logic_vector(7 downto 0)
    );
    end component aurora_rx_lane;
    
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
    
    COMPONENT rx_lane_fifo
        PORT (
            rst : IN STD_LOGIC;
            wr_clk : IN STD_LOGIC;
            rd_clk : IN STD_LOGIC;
            din : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
            wr_en : IN STD_LOGIC;
            rd_en : IN STD_LOGIC;
            dout : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
            full : OUT STD_LOGIC;
            empty : OUT STD_LOGIC
        );
    END COMPONENT;

    component aurora_ch_bond
        generic (
            g_NUM_LANES : integer := g_NUM_LANES
        );
        port (
            -- Sys connect
            rst_n_i : in std_logic;
            clk_rx_i : in std_logic;

            -- Config
            active_lanes_i : in std_logic_vector(g_NUM_LANES-1 downto 0);

            -- Input
            rx_data_i : in rx_data_array(g_NUM_LANES-1 downto 0);
            rx_header_i : in rx_header_array(g_NUM_LANES-1 downto 0);
            rx_valid_i : in std_logic_vector(g_NUM_LANES-1 downto 0);

            -- Output
            rx_data_o : out rx_data_array(g_NUM_LANES-1 downto 0);
            rx_header_o : out rx_header_array(g_NUM_LANES-1 downto 0);
            rx_valid_o : out std_logic_vector(g_NUM_LANES-1 downto 0);
            rx_bond_o : out std_logic
        );
    end component aurora_ch_bond;
    
    signal rx_data_s : std_logic_vector(63 downto 0);
    signal rx_valid_s : std_logic;

    signal rx_data : rx_data_array(g_NUM_LANES-1 downto 0);
    signal rx_data_unbonded : rx_data_array(g_NUM_LANES-1 downto 0);
    signal rx_header : rx_header_array(g_NUM_LANES-1 downto 0);
    signal rx_header_unbonded : rx_header_array(g_NUM_LANES-1 downto 0);
    signal rx_status : rx_status_array(g_NUM_LANES-1 downto 0);
    signal rx_polarity : std_logic_vector(g_NUM_LANES-1 downto 0);
    signal rx_data_valid : std_logic_vector(g_NUM_LANES-1 downto 0);
    signal rx_data_valid_unbonded : std_logic_vector(g_NUM_LANES-1 downto 0);
    signal rx_bond_flag : std_logic;
    signal rx_lanes_ready : std_logic;
    signal rx_stat : std_logic_vector(7 downto 0);
    
    signal rx_fifo_dout :rx_data_array(g_NUM_LANES-1 downto 0);
    signal rx_fifo_buf :rx_data_array(g_NUM_LANES-1 downto 0);
    signal rx_fifo_din : rx_data_array(g_NUM_LANES-1 downto 0);
    signal rx_fifo_full : std_logic_vector(g_NUM_LANES-1 downto 0);
    signal rx_fifo_empty : std_logic_vector(g_NUM_LANES-1 downto 0);
    signal rx_fifo_buf_empty : std_logic_vector(g_NUM_LANES-1 downto 0);
    signal rx_fifo_empty_ungated : std_logic_vector(g_NUM_LANES-1 downto 0);
    signal rx_fifo_ignore_n : std_logic_vector(g_NUM_LANES-1 downto 0);
    signal rx_fifo_autoreg : std_logic_vector(g_NUM_LANES-1 downto 0);
    signal rx_fifo_empty_gate : std_logic;
    signal rx_fifo_buf_rden : std_logic_vector(g_NUM_LANES-1 downto 0);
    signal rx_fifo_rden : std_logic_vector(g_NUM_LANES-1 downto 0);
    signal rx_fifo_rden_t : std_logic_vector(g_NUM_LANES-1 downto 0);
    signal rx_fifo_wren : std_logic_vector(g_NUM_LANES-1 downto 0);
    
    signal channel : integer range 0 to g_NUM_LANES-1;
    
    COMPONENT ila_aurora
    PORT (
        clk : IN STD_LOGIC;
        probe0 : IN STD_LOGIC_VECTOR(3 DOWNTO 0); 
        probe1 : IN STD_LOGIC_VECTOR(3 DOWNTO 0); 
        probe2 : IN STD_LOGIC_VECTOR(3 DOWNTO 0); 
        probe3 : IN STD_LOGIC_VECTOR(63 DOWNTO 0); 
        probe4 : IN STD_LOGIC_VECTOR(63 DOWNTO 0); 
        probe5 : IN STD_LOGIC_VECTOR(63 DOWNTO 0); 
        probe6 : IN STD_LOGIC_VECTOR(63 DOWNTO 0); 
        probe7 : IN STD_LOGIC_VECTOR(63 DOWNTO 0)
    );
    END COMPONENT  ;
            
begin

    rx_data_o <= rx_data_s;
    rx_valid_o <= rx_valid_s;
	
	-- Arbiter
	--cmp_rr_arbiter : rr_arbiter port map (
	--	clk_i => clk_rx_i,
	--	rst_i => not rst_n_i,
	--	req_i => not rx_fifo_empty,
	--	gnt_o => rx_fifo_rden
	--);

    rd_proc : process(clk_rx_i, rst_n_i)
    begin
        if (rst_n_i = '0') then
            rx_fifo_rden_t <= (others => '0');
        elsif rising_edge(clk_rx_i) then
            if (unsigned(rx_fifo_rden_t) > 0) then
                rx_fifo_rden_t <= std_logic_vector(shift_left(unsigned(rx_fifo_rden_t), 1)) and not rx_fifo_empty_ungated;
            elsif (rx_fifo_empty_ungated /= c_ALL_ONES) then
                rx_fifo_rden_t(0) <= '1';
            end if;
        end if;
    end process rd_proc;

    rx_fifo_rden <= rx_fifo_rden_t;
	
	reg_proc : process(clk_rx_i, rst_n_i)
    begin
        if (rst_n_i = '0') then
            --rx_fifo_rden <= (others => '0');
            rx_data_s <= (others => '0');
            rx_valid_s <= '0';
            channel <= 0;            
            rx_polarity <= (others => '0');
            rx_fifo_empty_gate <= '0';
        elsif rising_edge(clk_rx_i) then
            --rx_fifo_rden <= rx_fifo_rden_t;
            rx_polarity <= rx_polarity_i;
            if (unsigned(rx_fifo_rden) = 0 or ((rx_fifo_rden and rx_fifo_empty_ungated) = rx_fifo_rden)) then
                rx_valid_s <= '0';
                rx_data_s <= x"DEADBEEFDEADBEEF";
            else
                rx_valid_s <= '1';
                rx_data_s <= rx_fifo_dout(log2_ceil(to_integer(unsigned(rx_fifo_rden))));
            end if;
        end if;
    end process reg_proc;

    bond_cmp : aurora_ch_bond port map (
        rst_n_i => rst_n_i,
        clk_rx_i => clk_rx_i,
        active_lanes_i => rx_active_lanes_i(g_NUM_LANES-1 downto 0),
        rx_data_i => rx_data_unbonded,
        rx_header_i => rx_header_unbonded,
        rx_valid_i => rx_data_valid_unbonded,
        rx_data_o => rx_data,
        rx_header_o => rx_header,
        rx_valid_o => rx_data_valid,
        rx_bond_o => rx_bond_flag
    );
	
    bond_proc : process(clk_rx_i, rst_n_i)
    begin
        if (rst_n_i = '0') then
            rx_lanes_ready <= '0';
        elsif rising_edge(clk_rx_i) then
            if (rx_stat(g_NUM_LANES-1+4 downto 4) = rx_active_lanes_i) then
                if (rx_bond_flag = '1') then
                    rx_lanes_ready <= '1';
                end if;
            else
                rx_lanes_ready <= '0';
            end if;
        end if;
    end process bond_proc;

    rx_stat_o <= rx_stat;

    lane_loop: for I in 0 to g_NUM_LANES-1 generate
        lane_cmp : aurora_rx_lane port map (
            rst_n_i => rst_n_i,
            clk_rx_i => clk_rx_i,
            clk_serdes_i => clk_serdes_i,
            rx_data_i_p => rx_data_i_p(I),
            rx_data_i_n => rx_data_i_n(I),
            rx_polarity_i => rx_polarity(I),
            rx_data_o => rx_data_unbonded(I),
            rx_header_o => rx_header_unbonded(I),
            rx_valid_o => rx_data_valid_unbonded(I),
            rx_stat_o => rx_status(I)
        );
        rx_stat(I) <= rx_status(I)(0);
        rx_stat(I+4) <= rx_status(I)(1);

        
        -- TODO need to save register reads!
        -- TODO use 
        
        -- We expect these types of data:
        -- b01 - D[63:0] - 64 bit data
        -- b10 - 0x1E - 0x04 - 0xXXXX - D[31:0] - 32 bit data
        -- b10 - 0x1E - 0x00 - 0x0000 - 0x00000000 - 0 bit data
        -- b10 - 0x78 - Flag[7:0] - 0xXXXX - 0xXXXXXXXX - Idle
        -- b10 - 0xB4 - D[55:0] - Register read (MM)
        
        -- Swapping [63:32] and [31:0] to reverse swapping by casting 64-bit to uint32_t
        rx_fifo_din(I) <= rx_data(I)(31 downto 0) & rx_data(I)(63 downto 32) when (rx_header(I) = "01") else
                          rx_data(I)(31 downto 0) & x"FFFFFFFF" when ((rx_header(I) = "10") and (rx_data(I)(63 downto 56) = c_AURORA_SEP)) else
                          rx_data(I)(31 downto 0) & rx_data(I)(63 downto 32) when ((rx_header(I) = "10") and (rx_data(I)(63 downto 56) = x"55")) else
                          rx_data(I)(31 downto 0) & rx_data(I)(63 downto 32) when ((rx_header(I) = "10") and (rx_data(I)(63 downto 56) = x"99")) else
                          --rx_data(I)(31 downto 0) & rx_data(I)(63 downto 32) when ((rx_header(I) = "10") and (rx_data(I)(63 downto 56) = x"D2")) else
                          x"FFFFFFFFFFFFFFFF";
        rx_fifo_wren(I) <= rx_data_valid(I) when (rx_header(I) = "01") else
                           rx_data_valid(I) when ((rx_header(I) = "10") and (rx_data(I)(63 downto 56) = c_AURORA_SEP) and (rx_data(I)(55 downto 48) = x"04")) else
                           rx_data_valid(I) when ((rx_header(I) = "10") and (rx_data(I)(63 downto 56) = x"55")) else
                           rx_data_valid(I) when ((rx_header(I) = "10") and (rx_data(I)(63 downto 56) = x"99")) else
                           --rx_data_valid(I) when ((rx_header(I) = "10") and (rx_data(I)(63 downto 56) = x"D2")) else
                           '0';
                           
        rx_fifo_empty(I) <= rx_fifo_empty_ungated(I) when (rx_fifo_empty_gate = '1') else '1';
        rx_fifo_ignore_n(I) <= '0' when rx_header(I) = "10" and 
                               (rx_data(I)(63 downto 48) = x"1e00") else '1';
        rx_fifo_autoreg(I) <= '1' when (rx_header(I) = "10" and
                              (rx_data(I)(63 downto 56) = x"D2" or
                              rx_data(I)(63 downto 56) = x"B4")) else '0';

        stage1_fifo: process(clk_rx_i, rst_n_i)
        begin
            if (rst_n_i = '0') then
                rx_fifo_buf(I) <= (others=>'0');
                rx_fifo_buf_empty(I) <= '1';
            elsif rising_edge(clk_rx_i) then
                if ((rx_fifo_wren(I) = '1') and (enable_i = '1')) then
                    rx_fifo_buf_empty(I) <= '0';
                    rx_fifo_buf(I) <= rx_fifo_din(I);
                elsif ((rx_fifo_buf_rden(I) = '1') or (enable_i = '0') or (rx_lanes_ready = '0')) then
                    rx_fifo_buf_empty(I) <= '1';
                end if;
            end if;
        end process stage1_fifo;
        
        stage2_fifo: process(clk_rx_i, rst_n_i)
        begin
            if (rst_n_i = '0') then
                rx_fifo_dout(I) <= (others=>'0');
                rx_fifo_empty_ungated(I) <= '1';
                rx_fifo_buf_rden(I) <= '0';
            elsif rising_edge(clk_rx_i) then
                rx_fifo_buf_rden(I) <= '0';
                if (rx_fifo_buf_empty(I) = '0' and rx_fifo_empty_ungated(I) = '1') then
                    rx_fifo_empty_ungated(I) <= '0';
                    rx_fifo_dout(I) <= rx_fifo_buf(I);
                    rx_fifo_buf_rden(I) <= '1';
                elsif ((rx_fifo_rden(I) = '1') or (enable_i = '0') or (rx_lanes_ready = '0')) then
                    rx_fifo_empty_ungated(I) <= '1';
                end if;
            end if;
        end process stage2_fifo;
    
--        cmp_lane_fifo : rx_lane_fifo PORT MAP (
--            rst => not rst_n_i,
--            wr_clk => clk_rx_i,
--            rd_clk => clk_rx_i,
--            din => rx_fifo_din(I),
--            wr_en => rx_fifo_wren(I) and enable_i,
--            rd_en => rx_fifo_rden(I),
--            dout => rx_fifo_dout(I),
--            full => rx_fifo_full(I),
--            empty => rx_fifo_empty(I)
--        );        
    end generate lane_loop;
    
--    aurora_channel_debug : ila_aurora
--    PORT MAP (
--      clk => clk_rx_i,
--      probe0 => rx_data_valid(3 downto 0), 
--      probe1 => rx_fifo_rden(3 donto 0),
--      probe2 => rx_fifo_empty_ungated(3 downto 0), 
--      probe3 => rx_data_s,
--      probe4 => rx_data(0),
--      probe5 => rx_data(1), 
--      probe6 => rx_data(2),
--      probe7 => rx_data(3)
--    );
    
end behavioral;
