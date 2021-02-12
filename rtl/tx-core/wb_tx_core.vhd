-- ####################################
-- # Project: Yarr
-- # Author: Timon Heim
-- # E-Mail: timon.heim at cern.ch
-- # Comments: Serial Port
-- # Outputs are synchronous to clk_i
-- ####################################
-- # Adress Map:
-- # Adr[4:0]:
-- #   0x00 - FiFo (WO) (Write to enabled channels)
-- #   0x01 - CMD Enable (RW)
-- #   0x02 - CMD Empty (RO)
-- #   0x03 - Trigger Enable (RW)
-- #   0x04 - Trigger Done (RO)
-- #   0x05 - Trigger Conf (RW) : 
-- #          0 = External
-- #          1 = Internal Time
-- #          2 = Internal Count
-- #   0x06 - Trigger Frequency (RW)
-- #   0x07 - Trigger Time_L (RW)
-- #   0x08 - Trigger Time_H (RW)
-- #   0x09 - Trigger Count (RW)
-- #   0x0A - Trigger Word Length (RW)
-- #   0x0B - Trigger Word [31:0] (RW)
-- #   0x0C - Trigger Pointer (RW)
-- #   0x0F - Toggle trigger abort
-- #   0x10 - TX polarity (RW)
-- #   0x11 - 
-- #   0x14 - Trigger Extender Interval (RW)

library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.board_pkg.all;

entity wb_tx_core is
	generic (
		g_NUM_TX : integer range 1 to 32 := 1
	);
	port (
		-- Sys connect
		wb_clk_i	: in  std_logic;
		rst_n_i		: in  std_logic;
		
		-- Wishbone slave interface
		wb_adr_i	: in  std_logic_vector(31 downto 0);
		wb_dat_i	: in  std_logic_vector(31 downto 0);
		wb_dat_o	: out std_logic_vector(31 downto 0);
		wb_cyc_i	: in  std_logic;
		wb_stb_i	: in  std_logic;
		wb_we_i		: in  std_logic;
		wb_ack_o	: out std_logic;
		wb_stall_o	: out std_logic;
		
		-- TX
		tx_clk_i	: in  std_logic;
		tx_data_o	: out std_logic_vector(g_NUM_TX-1 downto 0);
		trig_pulse_o : out std_logic;
		
		-- Sync
		ext_trig_i : in std_logic
		
	);
end wb_tx_core;

architecture behavioral of wb_tx_core is
    component tx_channel is
        port (
            -- Sys connect
            wb_clk_i	: in  std_logic;
            rst_n_i		: in  std_logic;
            
            -- Data In
            wb_dat_i	: in std_logic_vector(31 downto 0);
            wb_wr_en_i	: in std_logic;
            
            -- TX
            tx_clk_i		: in  std_logic;
            tx_data_o		: out std_logic;
            tx_enable_i		: in std_logic;
            
            -- Trig Code
            trig_code_i       : in std_logic_vector (31 downto 0);
            trig_code_ready_i : in std_logic;
            
            -- Word Looper
            loop_pulse_i    : in std_logic;
            loop_mode_i     : in std_logic; -- (WB clk domain)
            loop_word_i     : in std_logic_vector(1023 downto 0); -- (WB clk domain)
            loop_word_bytes_i : in std_logic_vector(7 downto 0); -- (WB clk domain)
                
            -- Pulse
            pulse_word_i       : in std_logic_vector(31 downto 0);
            pulse_interval_i   : in std_logic_vector(15 downto 0);
            
            -- Sync
            sync_word_i       : in std_logic_vector(31 downto 0);
            sync_interval_i   : in std_logic_vector(7 downto 0);
            
            -- Idle
            idle_word_i       : in std_logic_vector(31 downto 0);
            
            -- Status
            tx_underrun_o	: out std_logic;
            tx_overrun_o	: out std_logic;
            tx_almost_full_o : out std_logic;
            tx_empty_o	: out std_logic
        );
    end component;
	
	component trigger_unit
		port (
			clk_i 	: in  std_logic;
			rst_n_i	: in  std_logic;
			
			-- Serial Trigger Out
			--trig_o : out std_logic;
			trig_pulse_o : out std_logic;
			
			-- Trigger In
			ext_trig_i	: in std_logic;
			
			-- Config
			--trig_word_i : in std_logic_vector(127 downto 0); -- Trigger command
			--trig_word_length_i : in std_logic_vector(31 downto 0); -- Trigger command length
			trig_freq_i : in std_logic_vector(31 downto 0); -- Number of clock cycles between triggers
			trig_time_i : in std_logic_vector(63 downto 0); -- Clock cycles
			trig_count_i : in std_logic_vector(31 downto 0); -- Fixed number of triggers
			trig_conf_i	: in std_logic_vector(3 downto 0); -- Internal, external, pseudo random, 
			trig_en_i : in std_logic;
			trig_abort_i : in std_logic;
			trig_done_o : out std_logic
		);
	end component;

	component handshake
	generic (
        g_WIDTH : integer := 1
    );
	port (
		clk_s    : in std_logic;     --source clock
        clk_d    : in std_logic;     --destination clock
        rst_n    : in std_logic;     --active low reset
        --Signal ports
        di       : in std_logic_vector;
        do       : out std_logic_vector
	);
	end component;
	
	component trigger_extender is 
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
    end component;
	
    component trig_code_gen is 
        port (
            clk_i       :  in std_logic;
            rst_n_i     :  in std_logic;
    
            enable_i    :  in std_logic;
            pulse_i     :  in std_logic;
    
            code_o      :  out std_logic_vector(31 downto 0);  -- two 16-bit code words
            code_ready_o : out std_logic
        );
    end component;
	
	-- Signals
	signal tx_data_cmd : std_logic_vector(g_NUM_TX-1 downto 0);
	signal tx_data_trig : std_logic;
	signal tx_trig_pulse : std_logic;
	
	-- Registers
	signal tx_enable : std_logic_vector(31 downto 0) := (others => '0');
	signal tx_enable_h : std_logic_vector(31 downto 0) := (others => '0');
	
	signal tx_underrun : std_logic_vector(31 downto 0) := (others => '0');
	signal tx_overrun : std_logic_vector(31 downto 0) := (others => '0');
	signal tx_almost_full : std_logic_vector(31 downto 0) := (others => '0');
	signal tx_empty	: std_logic_vector(31 downto 0) := (others => '0');
	
	-- Trigger command
	signal trig_freq : std_logic_vector(31 downto 0); -- Number of clock cycles between triggers
	signal trig_time : std_logic_vector(63 downto 0); -- Clock cycles
	signal trig_time_l : std_logic_vector(31 downto 0);
	signal trig_time_l_d : std_logic_vector(31 downto 0);
	signal trig_time_h : std_logic_vector(31 downto 0);
	signal trig_time_h_d : std_logic_vector(31 downto 0);
	signal trig_count : std_logic_vector(31 downto 0); -- Fixed number of triggers
	signal trig_conf : std_logic_vector(3 downto 0); -- Internal, external, pseudo random, 
	signal trig_en : std_logic;
	signal trig_done : std_logic;
	signal trig_word_length : std_logic_vector(31 downto 0);
	signal trig_word : std_logic_vector(1023 downto 0);
    type trig_word_array is array (g_NUM_TX-1 downto 0) of std_logic_vector(1023 downto 0);
	signal trig_word_t : trig_word_array;
	signal trig_word_pointer : unsigned(4 downto 0);  
    signal tx_polarity : std_logic_vector((g_NUM_TX-1) downto 0);
    signal tx_polarity_t : std_logic_vector((g_NUM_TX-1) downto 0);
    signal trig_ext_interval : std_logic_vector(31 downto 0);
    
    -- Trig input freq counter
    signal ext_trig_t1 : std_logic;
    signal ext_trig_t2 : std_logic;
    signal ext_trig_t3 : std_logic;
    signal trig_in_freq_cnt : unsigned(31 downto 0);
    signal trig_in_freq : std_logic_vector(31 downto 0);
    signal trig_in_freq_d : std_logic_vector(31 downto 0);
    signal per_second : std_logic;
    signal per_second_cnt : unsigned(31 downto 0);
    constant ticks_per_second : integer := 160000000; -- 160 MHz clock rate TODO make it set via board_pkg
    
    type word_array is array (g_NUM_TX-1 downto 0) of std_logic_vector(31 downto 0);

	signal trig_abort : std_logic;

	
	signal wb_wr_en	: std_logic_vector(31 downto 0) := (others => '0');
	signal wb_dat_t : std_logic_vector(31 downto 0);
	
	signal channel : integer range 0 to 31;

	--Handshake intermittent signals
	signal tx_enable_hs 		: std_logic_vector(31 downto 0) := (others => '0');
	signal trig_en_hs 			: std_logic;
	signal trig_conf_hs 		: std_logic_vector(3 downto 0);
	signal trig_time_hs 		: std_logic_vector(63 downto 0);
	signal trig_count_hs 		: std_logic_vector(31 downto 0);
	signal trig_word_hs 		: std_logic_vector(1023 downto 0);
	signal trig_abort_hs 		: std_logic;
	signal trig_freq_hs 		: std_logic_vector(31 downto 0);
	signal trig_word_lgth_hs 	: std_logic_vector(31 downto 0);
	signal tx_polarity_hs 		: std_logic_vector((g_NUM_TX-1) downto 0);
	signal tx_empty_hs			: std_logic_vector(31 downto 0) := (others => '0');
	signal trig_done_hs			: std_logic;
	signal trig_in_freq_hs		: std_logic_vector(31 downto 0);
	signal pulse_word_hs 		: std_logic_vector(31 downto 0);
	signal pulse_interval_hs	: std_logic_vector(15 downto 0);
	signal sync_word_hs 		: std_logic_vector(31 downto 0);
	signal sync_interval_hs 	: std_logic_vector(7 downto 0);
	signal idle_word_hs 		: std_logic_vector(31 downto 0);
	signal trig_ext_interval_hs : std_logic_vector(31 downto 0);

    signal pulse_word : std_logic_vector(31 downto 0);
    signal pulse_interval : std_logic_vector(15 downto 0);
    signal pulse_words : word_array;

    signal sync_word : std_logic_vector(31 downto 0);
    signal sync_interval : std_logic_vector(7 downto 0);
    signal sync_words : word_array;

    signal idle_word : std_logic_vector(31 downto 0);
    signal idle_words : word_array;
    
    signal ext_trig_pulse : std_logic;
    
    signal trig_code : std_logic_vector(31 downto 0);
    signal trig_code_ready : std_logic;
begin

	channel <= TO_INTEGER(unsigned(wb_adr_i(8 downto 4)));
	wb_stall_o <= '1' when (tx_almost_full /= x"00000000") else '0';
	
	wb_proc: process (wb_clk_i, rst_n_i)
	begin
		if (rst_n_i = '0') then
			wb_dat_o <= (others => '0');
			wb_ack_o <= '0';
			wb_wr_en <= (others => '0');
			tx_enable <= (others => '0');
			wb_dat_t <= (others => '0');
			trig_en <= '0';
			trig_abort  <= '0';
            tx_enable <= (others => '0');
            trig_conf <= (others => '0');
            trig_time_h <= (others => '0');
            trig_time_h_d <= (others => '0');
            trig_time_h <= (others => '0');
            trig_time_l_d <= (others => '0');
            trig_count <= (others => '0');
            trig_word <= (others => '0');
            trig_word_pointer <= (others => '0');
            trig_in_freq_d <= (others => '0');
            trig_ext_interval <= (others => '0');
            pulse_word <= c_TX_AZ_WORD;
            pulse_interval <= std_logic_vector(c_TX_AZ_INTERVAL);
            sync_word <= c_TX_SYNC_WORD;
            sync_interval <= std_logic_vector(c_TX_SYNC_INTERVAL);
            idle_word <= c_TX_IDLE_WORD;
		elsif rising_edge(wb_clk_i) then
			wb_wr_en <= (others => '0');
			wb_ack_o <= '0';
            trig_time_h_d <= trig_time_h;
            trig_time_l_d <= trig_time_l;
			trig_time <= trig_time_h_d & trig_time_l_d; -- delay for more flexible routing
			trig_abort  <= '0';
			trig_in_freq_d <= trig_in_freq_hs; -- delay for more flexible routing
			if (wb_cyc_i = '1' and wb_stb_i = '1') then
				if (wb_we_i = '1') then
					case (wb_adr_i(7 downto 0)) is
						when x"00" => -- Write to fifo
							wb_wr_en <= tx_enable;
							wb_ack_o <= '1';
							wb_dat_t <= wb_dat_i;
						when x"01" => -- Set enable mask
							tx_enable <= wb_dat_i;
							wb_ack_o <= '1';
						when x"03" => -- Set trigger enable
							trig_en <= wb_dat_i(0);
							wb_ack_o <= '1';
						when x"05" => -- Set trigger conf
							trig_conf <= wb_dat_i(3 downto 0);
							wb_ack_o <= '1';
						when x"06" => -- Set trigger frequency
							trig_freq <= wb_dat_i;
							wb_ack_o <= '1';
						when x"07" => -- Set trigger time low
							trig_time_l(31 downto 0) <= wb_dat_i;
							wb_ack_o <= '1';
						when x"08" => -- Set trigger time high
							trig_time_h(31 downto 0) <= wb_dat_i;
							wb_ack_o <= '1';
						when x"09" => -- Set trigger count
							trig_count <= wb_dat_i;
							wb_ack_o <= '1';
						when x"0A" => -- Set trigger word length (bits)
							trig_word_length <= wb_dat_i;
							wb_ack_o <= '1';
						when x"0B" => -- Set trigger word as specified in pointer
							trig_word(((to_integer(trig_word_pointer)+1)*32)-1 downto (to_integer(trig_word_pointer))*32) <= wb_dat_i;
							wb_ack_o <= '1';
						when x"0C" => -- Set trigger word pointer
							trig_word_pointer <= unsigned(wb_dat_i(4 downto 0));
							wb_ack_o <= '1';
						when x"0D" => -- Pulse word
							pulse_word <= wb_dat_i(31 downto 0);
							wb_ack_o <= '1';
						when x"0E" => -- Pulse word interval
							pulse_interval <= wb_dat_i(15 downto 0);
							wb_ack_o <= '1';
						when x"0F" => -- Toggle trigger abort
							trig_abort <= wb_dat_i(0);
							wb_ack_o <= '1';
						when x"10" => -- TX polarity
							tx_polarity <= wb_dat_i((g_NUM_TX-1) downto 0);
							wb_ack_o <= '1';
						when x"11" => -- Pulse word
							sync_word <= wb_dat_i(31 downto 0);
							wb_ack_o <= '1';
						when x"12" => -- Pulse word interval
							sync_interval <= wb_dat_i(7 downto 0);
							wb_ack_o <= '1';
						when x"13" => -- Pulse word
						    idle_word <= wb_dat_i(31 downto 0);
							wb_ack_o <= '1';
					    when x"14" => -- Trigger Extender Interval
					        trig_ext_interval <= wb_dat_i;
					        wb_ack_o <= '1';
						when others =>
							wb_ack_o <= '1';
					end case;
				else
					case (wb_adr_i(7 downto 0)) is
						when x"00" => -- Read enable mask
							wb_dat_o <= tx_enable;
							wb_ack_o <= '1';
						when x"02" => -- Read empty stat
							wb_dat_o <= tx_empty_hs;
							wb_ack_o <= '1';
						when x"03" => -- Read trigger enable
							wb_dat_o(0) <= trig_en;
							wb_dat_o(31 downto 1) <= (others => '0');
							wb_ack_o <= '1';
						when x"04" => -- Read trigger done
							wb_dat_o(0) <= trig_done_hs;
							wb_dat_o(31 downto 1) <= (others => '0');
							wb_ack_o <= '1';
						when x"05" => -- Read trigger conf
							wb_dat_o(3 downto 0) <= trig_conf;
							wb_dat_o(31 downto 4) <= (others => '0');
							wb_ack_o <= '1';
						when x"06" => -- Read trigger freq
							wb_dat_o <= trig_freq;
							wb_ack_o <= '1';
						when x"07" => -- Read trigger time low
							wb_dat_o <= trig_time(31 downto 0);
							wb_ack_o <= '1';
						when x"08" => -- Read trigger time high
							wb_dat_o <= trig_time(63 downto 32);
							wb_ack_o <= '1';
						when x"09" => -- Read trigger count
							wb_dat_o <= trig_count;
							wb_ack_o <= '1';
						when x"0A" => -- Set trigger word length (bits)
							wb_dat_o <= trig_word_length;
							wb_ack_o <= '1';
						when x"0B" =>
							wb_dat_o <= trig_word(((to_integer(trig_word_pointer)+1)*32)-1 downto (to_integer(trig_word_pointer))*32);
							wb_ack_o <= '1';
						when x"0C" =>
                            wb_dat_o <= (others => '0');
							wb_dat_o(4 downto 0) <= std_logic_vector(trig_word_pointer);
							wb_ack_o <= '1';
						when x"0D" => -- autozero word
							wb_dat_o(31 downto 0) <= pulse_word;
							wb_ack_o <= '1';
						when x"0E" => -- autozero interval
                            wb_dat_o <= (others => '0');
							wb_dat_o(15 downto 0) <= pulse_interval;
							wb_ack_o <= '1';
						when x"0F" => -- Trigger in frequency
							wb_dat_o <= trig_in_freq_d;
							wb_ack_o <= '1';
						when x"10" => -- TX polarity
							wb_dat_o <= (others => '0');
							wb_dat_o((g_NUM_TX-1) downto 0) <= tx_polarity;
							wb_ack_o <= '1';
						when x"11" => -- sync word
							wb_dat_o(31 downto 0) <= sync_word;
							wb_ack_o <= '1';
						when x"12" => -- sync interval
                            wb_dat_o <= (others => '0');
							wb_dat_o(7 downto 0) <= sync_interval;
							wb_ack_o <= '1';
						when x"13" => -- idle word
							wb_dat_o(31 downto 0) <= idle_word;
							wb_ack_o <= '1';
					    when x"14" => -- Trigger Extender Interval
					        wb_dat_o <= trig_ext_interval;
					        wb_ack_o <= '1';
						when others =>
							wb_dat_o <= x"DEADBEEF";
							wb_ack_o <= '1';
					end case;
				end if;
			end if;
		end if;
	end process wb_proc;

	--Handshake instantiations for status registers
	--Source clk is wb, destination clock is tx:
	hs1: handshake generic map(g_WIDTH => 32) 		port map(clk_s=>wb_clk_i, clk_d=>tx_clk_i, rst_n=>rst_n_i, di=>tx_enable, do=>tx_enable_hs);
	hs2: handshake generic map(g_WIDTH => 1) 		port map(clk_s=>wb_clk_i, clk_d=>tx_clk_i, rst_n=>rst_n_i, di(0)=>trig_en, do(0)=>trig_en_hs);
	hs3: handshake generic map(g_WIDTH => 4) 		port map(clk_s=>wb_clk_i, clk_d=>tx_clk_i, rst_n=>rst_n_i, di=>trig_conf, do=>trig_conf_hs);
	hs4: handshake generic map(g_WIDTH => 64) 		port map(clk_s=>wb_clk_i, clk_d=>tx_clk_i, rst_n=>rst_n_i, di=>trig_time, do=>trig_time_hs);
	hs5: handshake generic map(g_WIDTH => 32) 		port map(clk_s=>wb_clk_i, clk_d=>tx_clk_i, rst_n=>rst_n_i, di=>trig_count, do=>trig_count_hs);
	hs6: handshake generic map(g_WIDTH => 1024) 	port map(clk_s=>wb_clk_i, clk_d=>tx_clk_i, rst_n=>rst_n_i, di=>trig_word, do=>trig_word_hs);
	hs7: handshake generic map(g_WIDTH => 1) 		port map(clk_s=>wb_clk_i, clk_d=>tx_clk_i, rst_n=>rst_n_i, di(0)=>trig_abort, do(0)=>trig_abort_hs);
	hs8: handshake generic map(g_WIDTH => 32) 		port map(clk_s=>wb_clk_i, clk_d=>tx_clk_i, rst_n=>rst_n_i, di=>trig_freq, do=>trig_freq_hs);
	hs9: handshake generic map(g_WIDTH => 32) 		port map(clk_s=>wb_clk_i, clk_d=>tx_clk_i, rst_n=>rst_n_i, di=>trig_word_length, do=>trig_word_lgth_hs);
	hs10: handshake generic map(g_WIDTH => g_NUM_TX)	port map(clk_s=>wb_clk_i, clk_d=>tx_clk_i, rst_n=>rst_n_i, di=>tx_polarity, do=>tx_polarity_hs);
	hs11: handshake generic map(g_WIDTH => 32)		port map(clk_s=>wb_clk_i, clk_d=>tx_clk_i, rst_n=>rst_n_i, di=>pulse_word, do=>pulse_word_hs);
	hs12: handshake generic map(g_WIDTH => 16)		port map(clk_s=>wb_clk_i, clk_d=>tx_clk_i, rst_n=>rst_n_i, di=>pulse_interval, do=>pulse_interval_hs);
	hs13: handshake generic map(g_WIDTH => 32)		port map(clk_s=>wb_clk_i, clk_d=>tx_clk_i, rst_n=>rst_n_i, di=>sync_word, do=>sync_word_hs);
	hs14: handshake generic map(g_WIDTH => 8)		port map(clk_s=>wb_clk_i, clk_d=>tx_clk_i, rst_n=>rst_n_i, di=>sync_interval, do=>sync_interval_hs);
	hs15: handshake generic map(g_WIDTH => 32)		port map(clk_s=>wb_clk_i, clk_d=>tx_clk_i, rst_n=>rst_n_i, di=>idle_word, do=>idle_word_hs);
	--Source clk is tx, destination clock is wb:
	hs16: handshake generic map(g_WIDTH => 32) 		port map(clk_s=>tx_clk_i, clk_d=>wb_clk_i, rst_n=>rst_n_i, di=>tx_empty, do=>tx_empty_hs);
	hs17: handshake generic map(g_WIDTH => 1) 		port map(clk_s=>tx_clk_i, clk_d=>wb_clk_i, rst_n=>rst_n_i, di(0)=>trig_done, do(0)=>trig_done_hs);
	hs18: handshake generic map(g_WIDTH => 32) 		port map(clk_s=>tx_clk_i, clk_d=>wb_clk_i, rst_n=>rst_n_i, di=>trig_in_freq, do=>trig_in_freq_hs);
	hs19: handshake generic map(g_WIDTH => 32) 		port map(clk_s=>tx_clk_i, clk_d=>wb_clk_i, rst_n=>rst_n_i, di=>trig_ext_interval, do=>trig_ext_interval_hs);


	tx_channels: for I in 0 to g_NUM_TX-1 generate
	begin
		cmp_tx_channel: tx_channel PORT MAP (
			-- Sys connect
			wb_clk_i => wb_clk_i,
			rst_n_i => rst_n_i,
			-- Data In
			wb_dat_i => wb_dat_t,
			wb_wr_en_i => wb_wr_en(I),
			-- TX
			tx_clk_i => tx_clk_i,
			tx_data_o => tx_data_cmd(I),
			tx_enable_i => tx_enable_hs(I),
			-- Trigger code
			trig_code_i => trig_code,
			trig_code_ready_i => trig_code_ready,
			-- Looper
			loop_pulse_i => tx_trig_pulse,
			loop_mode_i => trig_en_hs,
			loop_word_i => trig_word_t(I),
			loop_word_bytes_i => trig_word_lgth_hs(7 downto 0),
            -- Pulse
            pulse_word_i => pulse_words(I),
            pulse_interval_i => pulse_interval_hs,
            -- Sync word
            sync_word_i => sync_words(I),
            sync_interval_i => sync_interval_hs,
            -- Idle word
            idle_word_i => idle_words(I),
			-- Status
			tx_underrun_o => tx_underrun(I),
			tx_overrun_o => tx_overrun(I),
			tx_almost_full_o => tx_almost_full(I),
			tx_empty_o => tx_empty(I)		
		);
		
		tx_mux : process(tx_clk_i, rst_n_i)
		begin
			if (rst_n_i = '0') then
				tx_data_o(I) <= '0';
                trig_word_t(I) <= (others => '0');
                tx_polarity_t(I) <= '0';

                pulse_words(I) <= c_TX_AZ_WORD;
                sync_words(I) <= c_TX_SYNC_WORD;
                idle_words(I) <= c_TX_IDLE_WORD;
			elsif rising_edge(tx_clk_i) then
				--if (tx_enable_hs(I) = '1' and trig_en_hs = '1') then
				--	tx_data_o(I) <= tx_data_trig;
				--else
                    trig_word_t(I) <= trig_word_hs;
					tx_data_o(I) <= tx_data_cmd(I) xor tx_polarity_t(I);
                    tx_polarity_t(I) <= tx_polarity_hs(I);
                    sync_words(I) <= sync_word_hs;
                    pulse_words(I) <= pulse_word_hs;
                    idle_words(I) <= idle_word_hs;

				--end if;
			end if;
		end process;
	end generate tx_channels;
	
	cmp_trig_unit : trigger_unit PORT MAP (
		clk_i => tx_clk_i,
		rst_n_i => rst_n_i,
		-- Serial Trigger Out
		--trig_o => tx_data_trig,
		trig_pulse_o=> tx_trig_pulse,
		-- Trigger In
		ext_trig_i => ext_trig_i,
		-- Config
		--trig_word_i => trig_word_hs,
		--trig_word_length_i => trig_word_lgth_hs,
		trig_freq_i => trig_freq_hs,
		trig_time_i => trig_time_hs,
		trig_count_i => trig_count_hs,
		trig_conf_i => trig_conf_hs,
		trig_en_i => trig_en_hs,
		trig_abort_i => trig_abort_hs,
		trig_done_o => trig_done
	);
	
	trig_pulse_o <= ext_trig_pulse;
	cmp_trigger_extender : trigger_extender PORT MAP (
	   clk_i => tx_clk_i,
	   rst_n_i => rst_n_i,
	   pulse_i => tx_trig_pulse,
	   ext_interval_i => trig_ext_interval_hs,
	   ext_pulse_o => ext_trig_pulse
	);
	
	cmp_trig_code_gen : trig_code_gen PORT MAP (
	    clk_i => tx_clk_i,
	    rst_n_i => rst_n_i,
	    enable_i => trig_en_hs,
	    pulse_i => ext_trig_pulse,
	    code_o => trig_code,
	    code_ready_o => trig_code_ready
	);
    
    -- Create 1 tick per second for counter
    per_sec_proc : process(tx_clk_i, rst_n_i)
    begin
        if (rst_n_i = '0') then
            per_second <= '0';
            per_second_cnt <= (others => '0');
        elsif rising_edge(tx_clk_i) then
            if (per_second_cnt = ticks_per_second) then
                per_second <= '1';
                per_second_cnt <= (others => '0');
            else
                per_second <= '0';
                per_second_cnt <= per_second_cnt + 1;
            end if;
        end if;
    end process per_sec_proc;
    
    -- Count incoming trig frequency
    trig_in_freq_proc : process(tx_clk_i, rst_n_i)
    begin
        if (rst_n_i = '0') then
            trig_in_freq_cnt <= (others => '0');
            ext_trig_t1 <= '0';
            ext_trig_t2 <= '0';
            ext_trig_t3 <= '0';
        elsif rising_edge(tx_clk_i) then
            ext_trig_t1 <= ext_trig_i;
            ext_trig_t2 <= ext_trig_t1;        
            ext_trig_t3 <= ext_trig_t2;        
            if (trig_done = '1') then -- reset when trigger module is done
                trig_in_freq_cnt <= (others => '0');
            else
                if (ext_trig_t2 = '1' and ext_trig_t3 = '0') then -- positive edge
                    trig_in_freq_cnt <= trig_in_freq_cnt + 1;
                end if;
                trig_in_freq <= std_logic_vector(trig_in_freq_cnt);
            end if;
        end if;
    end process trig_in_freq_proc;

end behavioral;
