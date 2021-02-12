-------------------------------------------------------------------------------
-- Copyright (c) 2021 UW ACME Lab
-- Author      : Gjones
-------------------------------------------------------------------------------
-- Simple testbench for tb_wb_tx_core
-------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
use     ieee.std_logic_misc.all;
use     ieee.numeric_std.all;
use     std.textio.all;

entity tb_wb_tx_core is
end    tb_wb_tx_core;

architecture struct of tb_wb_tx_core is

-- Crystal clock freq expressed in MHz
constant CLK_FREQ_100MHZ    : real      := 100.0;
-- Clock period
constant CLK_PER_100MHZ     : time      := integer(1.0E+6/(CLK_FREQ_100MHZ)) * 1 ps;

-- Number of TX Channels
constant G_NUM_TX           : integer   := 2;
-- TX clock parameters
constant CLK_FREQ_TX        : real      := 160.0;
constant CLK_PER_TX         : time      := integer(1.0E+6/(CLK_FREQ_TX)) * 1 ps;

-- Length of the counter used to synchronize trigger pulses
constant PULSE_CNTR_LEN     : integer   := 5;
-- Interval between trigger pulses
constant TRIGGER_INTERVAL   : integer   := 3;
-- Initial value of the counter used to synchronize trigger pulses
constant INIT_CNTR_VAL      : integer   := 11;

signal clk                  : std_logic := '0';

signal sim_done             : boolean   := false;
signal reset                : std_logic := '1';

-- Counter used to synchronize trigger pulses
signal pulse_cntr           : unsigned (PULSE_CNTR_LEN-1 downto 0) := to_unsigned(INIT_CNTR_VAL, PULSE_CNTR_LEN);

-------------------------------------------------------------
-- Port signals on DUT
-------------------------------------------------------------
signal rst_n_i              : std_logic;

-- Wishbone slave interface
signal wb_adr_i             : std_logic_vector(31 downto 0);
signal wb_dat_i             : std_logic_vector(31 downto 0);
signal wb_dat_o             : std_logic_vector(31 downto 0);
signal wb_cyc_i             : std_logic;
signal wb_stb_i             : std_logic;
signal wb_we_i              : std_logic;
signal wb_ack_o             : std_logic;
signal wb_stall_o           : std_logic;

-- TX
signal tx_clk_i             : std_logic;
signal tx_data_o            : std_logic_vector(G_NUM_TX-1 downto 0);
signal trig_pulse_o         : std_logic;

-- Sync
signal ext_trig_i           : std_logic;


-------------------------------------------------------------
-- CPU write procedure
-------------------------------------------------------------
procedure wb_write(
    signal clk          : in  std_logic;
    constant a          : in  integer;
    constant d          : in  std_logic_vector(31 downto 0);
    signal wb_cyc_i     : out std_logic;
    signal wb_stb_i     : out std_logic;
    signal wb_we_i      : out std_logic;
    signal wb_adr_i     : out std_logic_vector(31 downto 0);
    signal wb_dat_i     : out std_logic_vector(31 downto 0)
) is
begin
    wait until clk'event and clk='0';
    wb_cyc_i    <= '1';
    wb_stb_i    <= '1';
    wb_we_i     <= '1';
    wb_adr_i    <= std_logic_vector(to_unsigned(a, 32));
    wb_dat_i    <= std_logic_vector(d);
    wait until clk'event and clk='0';
    wb_cyc_i    <= '0';
    wb_stb_i    <= '0';
    wb_we_i     <= '0';
    wb_adr_i    <= (others=>'0');
    wb_dat_i    <= (others=>'0');
    wait until clk'event and clk='0';
end;


-------------------------------------------------------------
-- CPU read procedure
-------------------------------------------------------------
procedure wb_read(
    signal clk          : in  std_logic;
    constant a          : in  integer;
    constant exp_d      : in  std_logic_vector(31 downto 0);
    signal wb_cyc_i     : out std_logic;
    signal wb_stb_i     : out std_logic;
    signal wb_we_i      : out std_logic;
    signal wb_adr_i     : out std_logic_vector(31 downto 0);
    signal wb_dat_i     : out std_logic_vector(31 downto 0);
    signal wb_dat_o     : in  std_logic_vector(31 downto 0);
    signal wb_ack_o     : in  std_logic
) is
variable v_bdone    : boolean := false;
variable str_out    : string(1 to 256);
begin
    wait until clk'event and clk='0';
    wb_cyc_i    <= '1';
    wb_stb_i    <= '1';
    wb_we_i     <= '0';
    wb_adr_i    <= std_logic_vector(to_unsigned(a, 32));
    wb_dat_i    <= (others=>'0');

    while (v_bdone = false) loop
        wait until clk'event and clk='0';
        wb_cyc_i    <= '1';
        wb_stb_i    <= '1';
        if (wb_ack_o = '1') then
            if (wb_dat_o /= exp_d) then
                --fprint(str_out, "Read  exp: 0x%s  actual: 0x%s\n", to_string(to_bitvector(exp_d),"%08X"), to_string(to_bitvector(cpu_rdata),"%08X"));
                --report str_out severity error;
                report "Read error" severity error;
            end if;
            v_bdone := true;
            wb_cyc_i    <= '0';
            wb_stb_i    <= '0';
            wb_adr_i    <= (others=>'0');
        end if;
    end loop;
    wait until clk'event and clk='0';
    wait until clk'event and clk='0';
end;

-------------------------------------------------------------
-- Delay for N clock cycles
-------------------------------------------------------------
procedure clk_delay(
    constant nclks  : in  integer
) is
begin
    for I in 1 to nclks loop
        wait until clk'event and clk='0';
    end loop;
end;

----------------------------------------------------------------
-- Print a string with no time or instance path.
----------------------------------------------------------------
procedure cpu_print_msg(
    constant msg    : in    string
) is
variable line_out   : line;
begin
    write(line_out, msg);
    writeline(output, line_out);
end procedure cpu_print_msg;


-------------------------------------------------------------
-- Generate a trigger pattern
-------------------------------------------------------------
procedure gen_trig_pattern (
    signal clk                : in std_logic;
    signal pulse_cntr         : in unsigned (PULSE_CNTR_LEN-1 downto 0);
    constant TRIGGER_WORD_LEN : in integer;
    constant trig_pattern     : in std_logic_vector;
    signal ext_trig_i         : out std_logic
) is
begin
    wait until clk'event and clk='0';
    while (pulse_cntr /= 0) loop
        wait until clk'event and clk='0';
    end loop;
    
    for I in 0 to TRIGGER_WORD_LEN-1 loop
        ext_trig_i <= trig_pattern(I);
        wait until clk'event and clk='0';
        ext_trig_i <= '0';
        
        for J in 1 to TRIGGER_INTERVAL loop
            wait until clk'event and clk='0';
        end loop; 
    end loop; 
end; 


-------------------------------------------------------------
-- WORD ADDRESSES, NOT MULTIPLIED BY 4
-------------------------------------------------------------
-- Address Map:
-------------------------------------------------------------
--   0x00 - FiFo (WO) (Write to enabled channels)
--   0x01 - CMD Enable (RW)
--   0x02 - CMD Empty (RO)
--   0x03 - Trigger Enable (RW)
--   0x04 - Trigger Done (RO)
--   0x05 - Trigger Conf (RW) : 0 = External   1 = Internal Time    2 = Internal Count
--   0x06 - Trigger Frequency (RW)
--   0x07 - Trigger Time_L (RW)
--   0x08 - Trigger Time_H (RW)
--   0x09 - Trigger Count (RW)
--   0x0A - Trigger Word Length (RW)
--   0x0B - Trigger Word [31:0] (RW)
--   0x0C - Trigger Pointer (RW)
--   0x0F - Toggle trigger abort
--   0x10 - TX polarity (RW)
--   0x11 - 
--   0x14 - Trigger Extender Interval (RW)
-------------------------------------------------------------
constant ADR_TX_FIFO            : integer := 0;    --   0x00 - FiFo (WO) (Write to enabled channels)
constant ADR_CMD_EN             : integer := 1;    --   0x01 - CMD Enable (RW)
constant ADR_CMD_EMPTY          : integer := 2;    --   0x02 - CMD Empty (RO)
constant ADR_TRIG_EN            : integer := 3;    --   0x03 - Trigger Enable (RW)
constant ADR_TRIG_DONE          : integer := 4;    --   0x04 - Trigger Done (RO)
constant ADR_TRIG_CFG           : integer := 5;    --   0x05 - Trigger Config (RW) : 0 = External   1 = Internal Time    2 = Internal Count
constant ADR_TRIG_FREQ          : integer := 6;    --   0x06 - Trigger Frequency (RW)
constant ADR_TRIG_TIME_L        : integer := 7;    --   0x07 - Trigger Time_L (RW)
constant ADR_TRIG_TIME_H        : integer := 8;    --   0x08 - Trigger Time_H (RW)
constant ADR_TRIG_COUNT         : integer := 9;    --   0x09 - Trigger Count (RW)
constant ADR_TRIG_WORD_LEN      : integer := 10;   --   0x0A - Trigger Word Length (RW)
constant ADR_TRIG_WORD          : integer := 11;   --   0x0B - Trigger Word [31:0] (RW)
constant ADR_TRIG_PTR           : integer := 12;   --   0x0C - Trigger Pointer (RW)
constant ADR_TOG_TRIG_ABORT     : integer := 15;   --   0x0F - Toggle trigger abort
constant ADR_TX_POL             : integer := 16;   --   0x10 - TX polarity (RW)
constant ADR_EXT_TRIG_INTERVAL  : integer := 20;   --   0x14 - Trigger Extender Interval (RW)
-------------------------------------------------------------

-------------------------------------------------------------
-- Unit Under Test
-------------------------------------------------------------
component wb_tx_core is
generic (
    G_NUM_TX        : integer range 1 to 32 := 1
);
port (
    wb_clk_i        : in  std_logic;
    rst_n_i         : in  std_logic;
    wb_adr_i        : in  std_logic_vector(31 downto 0);
    wb_dat_i        : in  std_logic_vector(31 downto 0);
    wb_dat_o        : out std_logic_vector(31 downto 0);
    wb_cyc_i        : in  std_logic;
    wb_stb_i        : in  std_logic;
    wb_we_i         : in  std_logic;
    wb_ack_o        : out std_logic;
    wb_stall_o      : out std_logic;
    tx_clk_i        : in  std_logic;
    tx_data_o       : out std_logic_vector(G_NUM_TX-1 downto 0);
    trig_pulse_o    : out std_logic;
    ext_trig_i      : in std_logic
);
end component;

begin
    
    rst_n_i <= not(reset);
    
    -------------------------------------------------------------
    -- Unit Under Test
    -------------------------------------------------------------
    u_wb_tx_core : entity work.wb_tx_core
    generic map(
        G_NUM_TX        => G_NUM_TX           -- integer range 1 to 32 := 1
    )
    port map(
        wb_clk_i        => clk              , -- in  std_logic;
        rst_n_i         => rst_n_i          , -- in  std_logic;

        wb_adr_i        => wb_adr_i         , -- in  std_logic_vector(31 downto 0);
        wb_dat_i        => wb_dat_i         , -- in  std_logic_vector(31 downto 0);
        wb_dat_o        => wb_dat_o         , -- out std_logic_vector(31 downto 0);
        wb_cyc_i        => wb_cyc_i         , -- in  std_logic;
        wb_stb_i        => wb_stb_i         , -- in  std_logic;
        wb_we_i         => wb_we_i          , -- in  std_logic;
        wb_ack_o        => wb_ack_o         , -- out std_logic;
        wb_stall_o      => wb_stall_o       , -- out std_logic;

        tx_clk_i        => tx_clk_i         , -- in  std_logic;
        tx_data_o       => tx_data_o        , -- out std_logic_vector(G_NUM_TX-1 downto 0);
        trig_pulse_o    => trig_pulse_o     , -- out std_logic;
        ext_trig_i      => ext_trig_i         -- in std_logic
    );


    -------------------------------------------------------------
    -- Generate system clock until sim_done is true
    -------------------------------------------------------------
    pr_clk : process
    begin
        clk  <= '0';
        wait for (CLK_PER_100MHZ/2);
        clk  <= '1';
        wait for (CLK_PER_100MHZ-CLK_PER_100MHZ/2);
        if (sim_done=true) then
            wait;
        end if;
    end process;


    -------------------------------------------------------------
    -- Generate TX clock until sim_done is true
    -------------------------------------------------------------
    pr_clk_tx : process
    begin
        tx_clk_i  <= '0';
        wait for (CLK_PER_TX/2);
        tx_clk_i  <= '1';
        wait for (CLK_PER_TX-CLK_PER_TX/2);
        if (sim_done=true) then
            wait;
        end if;
    end process;
    
    -------------------------------------------------------------
    -- Increments the counter used to synchronize trigger pulses
    -- Counter wrap to zero is inferred not explicit.
    -------------------------------------------------------------
    pr_pulse_cntr : process (reset, tx_clk_i)
    begin
        if (reset = '1') then
            pulse_cntr <= to_unsigned(INIT_CNTR_VAL, PULSE_CNTR_LEN);
        elsif (rising_edge (tx_clk_i)) then
            pulse_cntr <= pulse_cntr + 1;
        end if;
    end process;


    -------------------------------------------------------------
    -- Reset and load registers
    -------------------------------------------------------------
    pr_main : process
    variable v_wb_dat     : std_logic_vector(31 downto 0) := X"00000000";
    begin
        -- Reset
        cpu_print_msg("Start simulation");
        wb_we_i         <= '0';
        wb_cyc_i        <= '0';
        wb_stb_i        <= '0';
        wb_adr_i        <= X"00000000";
        ext_trig_i      <= '0';
        reset           <= '1';
        clk_delay(10);
        reset           <= '0';
        clk_delay(10);

        ------------------------------------------------------------------------
        -- Configure registers through wishbone bus 
        ------------------------------------------------------------------------
        cpu_print_msg("Set trigger configuration to external mode");
        wb_write(clk, ADR_TRIG_CFG   , X"00000000", wb_cyc_i, wb_stb_i, wb_we_i, wb_adr_i, wb_dat_i); 
        clk_delay(5);
        
        cpu_print_msg("Set trigger enable to 1");
        wb_write(clk, ADR_TRIG_EN   , X"00000001", wb_cyc_i, wb_stb_i, wb_we_i, wb_adr_i, wb_dat_i); 
        clk_delay(5);
        
        cpu_print_msg("Set tx polarity to 0");
        wb_write(clk, ADR_TX_POL   , X"00000000", wb_cyc_i, wb_stb_i, wb_we_i, wb_adr_i, wb_dat_i); 
        clk_delay(5);
        
        cpu_print_msg("Set CMD enable to 1");
        wb_write(clk, ADR_CMD_EN   , X"00000001", wb_cyc_i, wb_stb_i, wb_we_i, wb_adr_i, wb_dat_i); 
        clk_delay(5);
        
        cpu_print_msg("Set trigger abort to 0");
        wb_write(clk, ADR_TOG_TRIG_ABORT   , X"00000000", wb_cyc_i, wb_stb_i, wb_we_i, wb_adr_i, wb_dat_i); 
        clk_delay(5);
        
        cpu_print_msg("Generate trigger patterns");
        gen_trig_pattern(tx_clk_i, pulse_cntr, 16, "1000" & "0001" & "0000" & "1001", ext_trig_i);
        gen_trig_pattern(tx_clk_i, pulse_cntr, 8, "0010" & "0100", ext_trig_i);
        
        cpu_print_msg("Set trig extender interval to 7");
        wb_write(clk, ADR_EXT_TRIG_INTERVAL   , X"00000007", wb_cyc_i, wb_stb_i, wb_we_i, wb_adr_i, wb_dat_i);
        gen_trig_pattern(tx_clk_i, pulse_cntr, 4, "1000", ext_trig_i);
        
        clk_delay(10);
        
        cpu_print_msg("Set trig extender interval to 11");
        wb_write(clk, ADR_EXT_TRIG_INTERVAL   , X"0000000b", wb_cyc_i, wb_stb_i, wb_we_i, wb_adr_i, wb_dat_i);
        gen_trig_pattern(tx_clk_i, pulse_cntr, 4, "1000", ext_trig_i);
        
        clk_delay(10);
        
        cpu_print_msg("Set trig extender interval to 15");
        wb_write(clk, ADR_EXT_TRIG_INTERVAL   , X"0000000f", wb_cyc_i, wb_stb_i, wb_we_i, wb_adr_i, wb_dat_i);
        gen_trig_pattern(tx_clk_i, pulse_cntr, 4, "1000", ext_trig_i);
        
        
        clk_delay(100);
        

--        cpu_print_msg("Read CMD_EN register");
--        wb_read (clk, ADR_TRIG_CFG   , X"00000002", wb_cyc_i, wb_stb_i, wb_we_i, wb_adr_i, wb_dat_i ,wb_dat_o, wb_ack_o); 
--        wait for 5 us;

--        -- Write data to TX FIFO
--        cpu_print_msg("Write to FIFO");
--        v_wb_dat    := X"00000001";   -- Initial data value
--        for I in 0 to 19 loop
--            wb_write(clk, ADR_TX_FIFO  , X"00000001", wb_cyc_i, wb_stb_i, wb_we_i, wb_adr_i, wb_dat_i); 
--            v_wb_dat    := std_logic_vector(unsigned(v_wb_dat) + 1);  -- Increment data
--        end loop;

        sim_done    <= true; 
        cpu_print_msg("Simulation complete");
        wait;

    end process;

end struct;

