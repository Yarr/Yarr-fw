--------------------------------------------------------------------------------
--                                                                            --
-- CERN BE-CO-HT         GN4124 core for PCIe FMC carrier                     --
--                       http://www.ohwr.org/projects/gn4124-core             --
--------------------------------------------------------------------------------
--
-- unit name: DMA controller (dma_controller.vhd)
--
-- authors: Simon Deprez (simon.deprez@cern.ch)
--          Matthieu Cattin (matthieu.cattin@cern.ch)
--
-- date: 31-08-2010
--
-- version: 0.2
--
-- description: Manages the DMA transfers.
--
--
-- dependencies:
--
--------------------------------------------------------------------------------
-- GNU LESSER GENERAL PUBLIC LICENSE
--------------------------------------------------------------------------------
-- This source file is free software; you can redistribute it and/or modify it
-- under the terms of the GNU Lesser General Public License as published by the
-- Free Software Foundation; either version 2.1 of the License, or (at your
-- option) any later version. This source is distributed in the hope that it
-- will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
-- of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
-- See the GNU Lesser General Public License for more details. You should have
-- received a copy of the GNU Lesser General Public License along with this
-- source; if not, download it from http://www.gnu.org/licenses/lgpl-2.1.html
--------------------------------------------------------------------------------
-- last changes: 30-09-2010 (mcattin) Add status, error and abort
--------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use work.wshexp_core_pkg.all;


entity dma_controller is
  Generic(
      DEBUG_C : std_logic
      );
  port
    (
      ---------------------------------------------------------
      -- GN4124 core clock and reset
      clk_i   : in std_logic;
      rst_n_i : in std_logic;

      ---------------------------------------------------------
      -- Interrupt request
      dma_ctrl_irq_o : out std_logic_vector(1 downto 0);

      ---------------------------------------------------------
      -- To the L2P DMA master and P2L DMA master
      dma_ctrl_carrier_addr_o : out std_logic_vector(31 downto 0);
      dma_ctrl_host_addr_h_o  : out std_logic_vector(31 downto 0);
      dma_ctrl_host_addr_l_o  : out std_logic_vector(31 downto 0);
      dma_ctrl_len_o          : out std_logic_vector(31 downto 0);
      dma_ctrl_start_l2p_o    : out std_logic;  -- To the L2P DMA master
      dma_ctrl_start_p2l_o    : out std_logic;  -- To the P2L DMA master
      dma_ctrl_start_next_o   : out std_logic;  -- To the P2L DMA master
      dma_ctrl_byte_swap_o    : out std_logic_vector(1 downto 0);
      dma_ctrl_abort_o        : out std_logic;
      dma_ctrl_done_i         : in  std_logic;
      dma_ctrl_error_i        : in  std_logic;

      ---------------------------------------------------------
      -- From P2L DMA master
      next_item_carrier_addr_i : in std_logic_vector(31 downto 0);
      next_item_host_addr_h_i  : in std_logic_vector(31 downto 0);
      next_item_host_addr_l_i  : in std_logic_vector(31 downto 0);
      next_item_len_i          : in std_logic_vector(31 downto 0);
      next_item_next_l_i       : in std_logic_vector(31 downto 0);
      next_item_next_h_i       : in std_logic_vector(31 downto 0);
      next_item_attrib_i       : in std_logic_vector(31 downto 0);
      next_item_valid_i        : in std_logic;
      sg_item_received_i       : in std_logic;

      ---------------------------------------------------------
      -- Wishbone slave interface
      wb_clk_i : in  std_logic;                      -- Bus clock
      wb_adr_i : in  std_logic_vector(3 downto 0);   -- Adress
      wb_dat_o : out std_logic_vector(31 downto 0);  -- Data in
      wb_dat_i : in  std_logic_vector(31 downto 0);  -- Data out
      wb_sel_i : in  std_logic_vector(3 downto 0);   -- Byte select
      wb_cyc_i : in  std_logic;                      -- Read or write cycle
      wb_stb_i : in  std_logic;                      -- Read or write strobe
      wb_we_i  : in  std_logic;                      -- Write
      wb_ack_o : out std_logic;                       -- Acknowledge
      
      ---------------------------------------------------------
      -- debug outputs
      dma_ctrl_current_state_do : out std_logic_vector (2 downto 0);
      dma_ctrl_do    : out std_logic_vector(31 downto 0);
      dma_stat_do    : out std_logic_vector(31 downto 0);
      dma_attrib_do  : out std_logic_vector(31 downto 0)
      );
end dma_controller;


architecture behaviour of dma_controller is


  ------------------------------------------------------------------------------
  -- Wishbone slave component declaration
  ------------------------------------------------------------------------------
  component dma_controller_wb_slave is
    port (
      rst_n_i            : in  std_logic;
      wb_clk_i           : in  std_logic;
      wb_addr_i          : in  std_logic_vector(3 downto 0);
      wb_data_i          : in  std_logic_vector(31 downto 0);
      wb_data_o          : out std_logic_vector(31 downto 0);
      wb_cyc_i           : in  std_logic;
      wb_sel_i           : in  std_logic_vector(3 downto 0);
      wb_stb_i           : in  std_logic;
      wb_we_i            : in  std_logic;
      wb_ack_o           : out std_logic;
      clk_i              : in  std_logic;
-- Port for std_logic_vector field: 'DMA engine control' in reg: 'DMACTRLR'
      dma_ctrl_o         : out std_logic_vector(31 downto 0);
      dma_ctrl_i         : in  std_logic_vector(31 downto 0);
      dma_ctrl_load_o    : out std_logic;
-- Port for std_logic_vector field: 'DMA engine status' in reg: 'DMASTATR'
      dma_stat_o         : out std_logic_vector(31 downto 0);
      dma_stat_i         : in  std_logic_vector(31 downto 0);
      dma_stat_load_o    : out std_logic;
-- Port for std_logic_vector field: 'DMA start address in the carrier' in reg: 'DMACSTARTR'
      dma_cstart_o       : out std_logic_vector(31 downto 0);
      dma_cstart_i       : in  std_logic_vector(31 downto 0);
      dma_cstart_load_o  : out std_logic;
-- Port for std_logic_vector field: 'DMA start address (low) in the host' in reg: 'DMAHSTARTLR'
      dma_hstartl_o      : out std_logic_vector(31 downto 0);
      dma_hstartl_i      : in  std_logic_vector(31 downto 0);
      dma_hstartl_load_o : out std_logic;
-- Port for std_logic_vector field: 'DMA start address (high) in the host' in reg: 'DMAHSTARTHR'
      dma_hstarth_o      : out std_logic_vector(31 downto 0);
      dma_hstarth_i      : in  std_logic_vector(31 downto 0);
      dma_hstarth_load_o : out std_logic;
-- Port for std_logic_vector field: 'DMA read length in bytes' in reg: 'DMALENR'
      dma_len_o          : out std_logic_vector(31 downto 0);
      dma_len_i          : in  std_logic_vector(31 downto 0);
      dma_len_load_o     : out std_logic;
-- Port for std_logic_vector field: 'Pointer (low) to next item in list' in reg: 'DMANEXTLR'
      dma_nextl_o        : out std_logic_vector(31 downto 0);
      dma_nextl_i        : in  std_logic_vector(31 downto 0);
      dma_nextl_load_o   : out std_logic;
-- Port for std_logic_vector field: 'Pointer (high) to next item in list' in reg: 'DMANEXTHR'
      dma_nexth_o        : out std_logic_vector(31 downto 0);
      dma_nexth_i        : in  std_logic_vector(31 downto 0);
      dma_nexth_load_o   : out std_logic;
-- Port for std_logic_vector field: 'DMA chain control' in reg: 'DMAATTRIBR'
      dma_attrib_o       : out std_logic_vector(31 downto 0);
      dma_attrib_i       : in  std_logic_vector(31 downto 0);
      dma_attrib_load_o  : out std_logic
      );
  end component dma_controller_wb_slave;

  ------------------------------------------------------------------------------
  -- linked list fifo component declaration
  ------------------------------------------------------------------------------

  component fifo_32x32 is
    Port ( 
      clk : in STD_LOGIC;
      srst : in STD_LOGIC;
      din : in STD_LOGIC_VECTOR ( 31 downto 0 );
      wr_en : in STD_LOGIC;
      rd_en : in STD_LOGIC;
      dout : out STD_LOGIC_VECTOR ( 31 downto 0 );
      full : out STD_LOGIC;
      empty : out STD_LOGIC;
      almost_empty : OUT STD_LOGIC
    );
  
  end component fifo_32x32;
  
  COMPONENT fifo_32x512_common_clk
    PORT (
      clk : IN STD_LOGIC;
      srst : IN STD_LOGIC;
      din : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      wr_en : IN STD_LOGIC;
      rd_en : IN STD_LOGIC;
      dout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      full : OUT STD_LOGIC;
      empty : OUT STD_LOGIC;
      almost_empty : OUT STD_LOGIC
    );
  END COMPONENT;
  ------------------------------------------------------------------------------
  -- Constants declaration
  ------------------------------------------------------------------------------
  constant c_IDLE  : std_logic_vector(2 downto 0) := "000";
  constant c_DONE  : std_logic_vector(2 downto 0) := "001";
  constant c_BUSY  : std_logic_vector(2 downto 0) := "010";
  constant c_ERROR : std_logic_vector(2 downto 0) := "011";
  constant c_ABORT : std_logic_vector(2 downto 0) := "100";

  ------------------------------------------------------------------------------
  -- Signals declaration
  ------------------------------------------------------------------------------

  -- DMA controller registers
  signal dma_ctrl    : std_logic_vector(31 downto 0);
  signal dma_stat    : std_logic_vector(31 downto 0);
  signal dma_cstart  : std_logic_vector(31 downto 0);
  signal dma_hstartl : std_logic_vector(31 downto 0);
  signal dma_hstarth : std_logic_vector(31 downto 0);
  signal dma_len     : std_logic_vector(31 downto 0);
  signal dma_nextl   : std_logic_vector(31 downto 0);
  signal dma_nexth   : std_logic_vector(31 downto 0);
  signal dma_attrib  : std_logic_vector(31 downto 0);
    
  signal dma_ctrl_load    : std_logic;
  signal dma_stat_load    : std_logic;
  signal dma_cstart_load  : std_logic;
  signal dma_hstartl_load : std_logic;
  signal dma_hstarth_load : std_logic;
  signal dma_len_load     : std_logic;
  signal dma_nextl_load   : std_logic;
  signal dma_nexth_load   : std_logic;
  signal dma_attrib_load  : std_logic;

  signal dma_ctrl_reg    : std_logic_vector(31 downto 0);
  signal dma_stat_reg    : std_logic_vector(31 downto 0);
  signal dma_cstart_reg  : std_logic_vector(31 downto 0);
  signal dma_hstartl_reg : std_logic_vector(31 downto 0);
  signal dma_hstarth_reg : std_logic_vector(31 downto 0);
  signal dma_len_reg     : std_logic_vector(31 downto 0);
  signal dma_nextl_reg   : std_logic_vector(31 downto 0);
  signal dma_nexth_reg   : std_logic_vector(31 downto 0);
  signal dma_attrib_reg  : std_logic_vector(31 downto 0);

  -- linked list FIFO signals
  signal dma_fifo_llist_in : std_logic_vector(223 downto 0);
  signal dma_fifo_llist_out : std_logic_vector(223 downto 0);
  signal dma_fifo_llist_wren : std_logic;
  signal dma_fifo_llist_rden : std_logic;
  signal dma_fifo_llist_full : std_logic_vector(6 downto 0);
  signal dma_fifo_llist_empty : std_logic_vector(6 downto 0);
  signal dma_fifo_llist_almost_empty : std_logic_vector(6 downto 0);
  
  signal dma_llist_wren_reg : std_logic;
  
  signal dma_cstart_out_s  : std_logic_vector(31 downto 0);
  signal dma_hstartl_out_s : std_logic_vector(31 downto 0);
  signal dma_hstarth_out_s : std_logic_vector(31 downto 0);
  signal dma_len_out_s     : std_logic_vector(31 downto 0);
  signal dma_nextl_out_s   : std_logic_vector(31 downto 0);
  signal dma_nexth_out_s   : std_logic_vector(31 downto 0);
  signal dma_attrib_out_s  : std_logic_vector(31 downto 0);
  
  signal dma_start_delay_s : std_logic_vector(1 downto 0);

  -- DMA controller FSM
  type dma_ctrl_state_type is (DMA_IDLE, DMA_START_TRANSFER, DMA_TRANSFER,
                               DMA_START_CHAIN, DMA_CHAIN, DMA_FIFO_RD,
                               DMA_ERROR, DMA_ABORT);
  signal dma_ctrl_current_state : dma_ctrl_state_type;

  -- status signals
  signal dma_status    : std_logic_vector(2 downto 0);
  signal dma_error_irq : std_logic;
  signal dma_done_irq  : std_logic;
  
  signal fifo_rst : std_logic;
  
  -- Debug signals
  signal dma_state_probe : std_logic_vector(2 downto 0);
  signal item_count      : std_logic_vector(31 downto 0);
  signal llist_FIFO_size : std_logic_vector(31 downto 0);
  signal llist_FIFO_depth: std_logic_vector(15 downto 0);
  
begin
  
  -- Creates an active high reset for fifos regardless of c_RST_ACTIVE value
  gen_fifo_rst_n : if c_RST_ACTIVE = '0' generate
    with dma_ctrl_reg(5) select fifo_rst <=
    not(rst_n_i) when '0',
    '1' when '1';
  end generate;

  gen_fifo_rst : if c_RST_ACTIVE = '1' generate
    with dma_ctrl_reg(5) select fifo_rst <=
    rst_n_i when '0',
    '1' when '1';
  end generate;
  
  
  dma_ctrl_do <= dma_ctrl;
  dma_stat_do <= dma_stat;
  dma_attrib_do <= dma_attrib;
  
  -- Selection of the linked list FIFO input between the register or the p2l signals
  with dma_ctrl_reg(4) select dma_fifo_llist_in <=
  dma_cstart_reg & dma_hstartl_reg & dma_hstarth_reg & dma_len_reg & dma_nextl_reg & dma_nexth_reg & dma_attrib_reg when '1',
  next_item_carrier_addr_i & next_item_host_addr_l_i & next_item_host_addr_h_i & next_item_len_i & next_item_next_l_i 
  & next_item_next_h_i & next_item_attrib_i when '0';

  with dma_llist_wren_reg select dma_fifo_llist_wren <=
  '1' when '1',
  sg_item_received_i when '0';
  
  dma_cstart_out_s <= dma_fifo_llist_out(223 downto 192);
  dma_hstartl_out_s <= dma_fifo_llist_out(191 downto 160);
  dma_hstarth_out_s <= dma_fifo_llist_out(159 downto 128);
  dma_len_out_s <= dma_fifo_llist_out(127 downto 96);
  dma_nextl_out_s <= dma_fifo_llist_out(95 downto 64);
  dma_nexth_out_s <= dma_fifo_llist_out(63 downto 32);
  dma_attrib_out_s <= dma_fifo_llist_out(31 downto 0);

  with dma_ctrl_current_state select dma_state_probe <=
    "000" when DMA_IDLE, 
    "001" when DMA_START_TRANSFER, 
    "010" when DMA_TRANSFER,
    "011" when DMA_START_CHAIN,
    "100" when DMA_CHAIN,
    "101" when DMA_FIFO_RD,
    "110" when DMA_ERROR,
    "111" when DMA_ABORT;
    
  dma_ctrl_current_state_do <= dma_state_probe;
  ------------------------------------------------------------------------------
  -- Wishbone slave instanciation
  ------------------------------------------------------------------------------
  dma_controller_wb_slave_0 : dma_controller_wb_slave port map (
    rst_n_i            => rst_n_i,
    wb_clk_i           => wb_clk_i,
    wb_addr_i          => wb_adr_i,
    wb_data_i          => wb_dat_i,
    wb_data_o          => wb_dat_o,
    wb_cyc_i           => wb_cyc_i,
    wb_sel_i           => wb_sel_i,
    wb_stb_i           => wb_stb_i,
    wb_we_i            => wb_we_i,
    wb_ack_o           => wb_ack_o,
    clk_i              => clk_i,
    dma_ctrl_o         => dma_ctrl,
    dma_ctrl_i         => dma_ctrl_reg,
    dma_ctrl_load_o    => dma_ctrl_load,
    dma_stat_o         => open,
    dma_stat_i         => dma_stat_reg,
    dma_stat_load_o    => open,
    dma_cstart_o       => dma_cstart,
    dma_cstart_i       => dma_cstart_reg,
    dma_cstart_load_o  => dma_cstart_load,
    dma_hstartl_o      => dma_hstartl,
    dma_hstartl_i      => dma_hstartl_reg,
    dma_hstartl_load_o => dma_hstartl_load,
    dma_hstarth_o      => dma_hstarth,
    dma_hstarth_i      => dma_hstarth_reg,
    dma_hstarth_load_o => dma_hstarth_load,
    dma_len_o          => dma_len,
    dma_len_i          => dma_len_reg,
    dma_len_load_o     => dma_len_load,
    dma_nextl_o        => dma_nextl,
    dma_nextl_i        => dma_nextl_reg,
    dma_nextl_load_o   => dma_nextl_load,
    dma_nexth_o        => dma_nexth,
    dma_nexth_i        => dma_nexth_reg,
    dma_nexth_load_o   => dma_nexth_load,
    dma_attrib_o       => dma_attrib,
    dma_attrib_i       => dma_attrib_reg,
    dma_attrib_load_o  => dma_attrib_load
    );

--  -- Change the size of the FIFO depending on the DEBUG variable to have enough space for the ilas
--  gen_32x32_FIFO: if DEBUG_C = '1' generate
--    llist_FIFO_size <= X"00000380"; -- FIFO depth * item size in 32bit word (32*28)
--    fifo_llist_gen: for i in 0 to 6 generate
--      fifo_llist_instatiation : fifo_32x32
--        port map ( 
--          clk => clk_i,
--          srst => fifo_rst,
--          din => dma_fifo_llist_in((i+1)*32-1 downto i*32),
--          wr_en => dma_fifo_llist_wren,
--          rd_en => dma_fifo_llist_rden,
--          dout => dma_fifo_llist_out((i+1)*32-1 downto i*32),
--          full => dma_fifo_llist_full(i),
--          empty => dma_fifo_llist_empty(i),
--          almost_empty => dma_fifo_llist_almost_empty(i)
--        );
--    end generate fifo_llist_gen;
--  end generate gen_32x32_FIFO;
  
--  gen_32x512_FIFO: if DEBUG_C = '0' generate
    llist_FIFO_size <= X"00003800"; -- FIFO depth * item size in 32bit word (512*28)
    llist_FIFO_depth <= X"0200";
    fifo_llist_gen: for i in 0 to 6 generate
      fifo_llist_instatiation : fifo_32x512_common_clk
        port map ( 
          clk => clk_i,
          srst => fifo_rst,
          din => dma_fifo_llist_in((i+1)*32-1 downto i*32),
          wr_en => dma_fifo_llist_wren,
          rd_en => dma_fifo_llist_rden,
          dout => dma_fifo_llist_out((i+1)*32-1 downto i*32),
          full => dma_fifo_llist_full(i),
          empty => dma_fifo_llist_empty(i),
          almost_empty => dma_fifo_llist_almost_empty(i)
        );
    end generate fifo_llist_gen;
--  end generate gen_32x512_FIFO;
  
  ------------------------------------------------------------------------------
  -- DMA controller registers
  ------------------------------------------------------------------------------
  p_regs : process (clk_i, rst_n_i)
  begin
    if (rst_n_i = c_RST_ACTIVE) then
      dma_ctrl_reg    <= (others => '0');
      dma_stat_reg    <= (others => '0');
      dma_cstart_reg  <= (others => '0');
      dma_hstartl_reg <= (others => '0');
      dma_hstarth_reg <= (others => '0');
      dma_len_reg     <= (others => '0');
      dma_nextl_reg   <= (others => '0');
      dma_nexth_reg   <= (others => '0');
      dma_attrib_reg  <= (others => '0');
      
      dma_llist_wren_reg <= '0';
      
    elsif rising_edge(clk_i) then
      -- Control register
      if (dma_ctrl_load = '1') then
        dma_ctrl_reg <= dma_ctrl;
      end if;
      -- Status register
      dma_stat_reg(2 downto 0)  <= dma_status;
      dma_stat_reg(31 downto 3) <= (others => '0');
      -- Target start address
      if (dma_cstart_load = '1') then
        dma_cstart_reg <= dma_cstart;
      end if;
      -- Host start address lowest 32-bit
      if (dma_hstartl_load = '1') then
        dma_hstartl_reg <= dma_hstartl;
      end if;
      -- Host start address highest 32-bit
      if (dma_hstarth_load = '1') then
        dma_hstarth_reg <= dma_hstarth;
      end if;
      -- DMA transfer length in byte
      if (dma_len_load = '1') then
        dma_len_reg <= dma_len;
      end if;
      -- next item address lowest 32-bit
      if (dma_nextl_load = '1') then
        dma_nextl_reg <= dma_nextl;
      end if;
      -- next item address highest 32-bit
      if (dma_nexth_load = '1') then
        dma_nexth_reg <= dma_nexth;
      end if;
      -- Chained DMA control
      if (dma_attrib_load = '1') then
        dma_attrib_reg <= dma_attrib;
      end if;
      -- ctrl register indicate a write in the linked list FIFO is needed
      if (dma_ctrl_reg(4) = '1') then
        dma_llist_wren_reg <= '1';
      end if;
      
      -- Write enable 1 tick pulse
      if (dma_llist_wren_reg = '1') then
        dma_llist_wren_reg <= '0';
        dma_ctrl_reg(4) <= '0';
      end if;
      
      -- Start DMA, 1 tick pulse
      if (dma_ctrl_reg(0) = '1') then
        dma_ctrl_reg(0) <= '0';
      end if;
      
      -- Fifo reset 1 tick pulse
      if (dma_ctrl_reg(5) = '1') then
        dma_ctrl_reg(5) <= '0';
      end if;
    end if;
  end process p_regs;

  dma_ctrl_byte_swap_o <= dma_ctrl_reg(3 downto 2);

  ------------------------------------------------------------------------------
  -- IRQ output assignement
  ------------------------------------------------------------------------------
  dma_ctrl_irq_o <= dma_error_irq & dma_done_irq;

------------------------------------------------------------------------------
  -- DMA controller FSM
  ------------------------------------------------------------------------------
  p_fsm : process (clk_i, rst_n_i)
  begin
    if(rst_n_i = c_RST_ACTIVE) then
      dma_ctrl_current_state  <= DMA_IDLE;
      dma_ctrl_carrier_addr_o <= (others => '0');
      dma_ctrl_host_addr_h_o  <= (others => '0');
      dma_ctrl_host_addr_l_o  <= (others => '0');
      dma_ctrl_len_o          <= (others => '0');
      dma_ctrl_start_l2p_o    <= '0';
      dma_ctrl_start_p2l_o    <= '0';
      dma_ctrl_start_next_o   <= '0';
      dma_status              <= c_IDLE;
      dma_error_irq           <= '0';
      dma_done_irq            <= '0';
      dma_ctrl_abort_o        <= '0';
      item_count              <= (others=>'0');
      
      dma_fifo_llist_rden <= '0';
      
    elsif rising_edge(clk_i) then
      case dma_ctrl_current_state is

        when DMA_IDLE =>
          -- Clear done irq to make it 1 tick pulse
          dma_done_irq <= '0';
          item_count <= (others=>'0');

          if(dma_ctrl_reg(0) = '1') then
            -- Starts a new transfer
            dma_ctrl_current_state <= DMA_START_TRANSFER;
          end if;

        when DMA_START_TRANSFER =>
          -- Clear abort signal
          dma_ctrl_abort_o <= '0';
          item_count <= std_logic_vector(unsigned(item_count) + 1);

          if (unsigned(dma_len_out_s(31 downto 2)) = 0) then
            -- Requesting a DMA of 0 word length gives a error
            dma_error_irq          <= '1';
            dma_ctrl_current_state <= DMA_ERROR;
          else
            -- Start the DMA if the length is not 0
            if (dma_attrib_out_s(1) = '0') then
              -- L2P transfer (from target to PCIe)
              dma_ctrl_start_l2p_o <= '1';
            elsif (dma_attrib_out_s(1) = '1') then
              -- P2L transfer (from PCIe to target)
              dma_ctrl_start_p2l_o <= '1';
            end if;
            dma_ctrl_current_state  <= DMA_TRANSFER;
            dma_ctrl_carrier_addr_o <= dma_cstart_out_s;
            dma_ctrl_host_addr_h_o  <= dma_hstarth_out_s;
            dma_ctrl_host_addr_l_o  <= dma_hstartl_out_s;
            dma_ctrl_len_o          <= dma_len_out_s;
            dma_status              <= c_BUSY;
          end if;

        when DMA_TRANSFER =>
          -- Clear start signals, to make them 1 tick pulses
          dma_ctrl_start_l2p_o <= '0';
          dma_ctrl_start_p2l_o <= '0';

          if (dma_ctrl_reg(1) = '1') then
            -- Transfer aborted
            dma_ctrl_current_state <= DMA_ABORT;
          elsif(dma_ctrl_error_i = '1') then
            -- An error occurs !
            dma_error_irq          <= '1';
            dma_ctrl_current_state <= DMA_ERROR;
          elsif(dma_ctrl_done_i = '1') then
            -- End of DMA transfer
            if(dma_attrib_out_s(0) = '1') then
              -- More transfer in chained DMA
              if(dma_fifo_llist_almost_empty /= "0000000") then
                -- FIFO almost empty mean that we are reading the last data currently
                dma_ctrl_current_state <= DMA_START_CHAIN;
              else
                dma_ctrl_current_state <= DMA_FIFO_RD;
                dma_fifo_llist_rden     <= '1';
              end if;
            else
              -- Was the last transfer
              dma_status             <= c_DONE;
              dma_done_irq           <= '1';
              dma_ctrl_current_state <= DMA_IDLE;
              dma_fifo_llist_rden     <= '1';
            end if;
          end if;
        when DMA_FIFO_RD =>
          dma_fifo_llist_rden <= '0';
          dma_ctrl_current_state <= DMA_START_TRANSFER;

        when DMA_START_CHAIN =>
          -- Catch the next item in host memory
          dma_fifo_llist_rden <= '1';
          dma_ctrl_current_state <= DMA_CHAIN;
          dma_ctrl_host_addr_h_o <= dma_nexth_out_s;
          dma_ctrl_host_addr_l_o <= dma_nextl_out_s;
          if(unsigned(dma_attrib_out_s(17 downto 2)) > unsigned(llist_FIFO_depth)) then
            dma_ctrl_len_o <= llist_FIFO_size;
          else
            dma_ctrl_len_o         <= std_logic_vector(unsigned(dma_attrib_out_s(17 downto 2))*28);
          end if;
          dma_ctrl_start_next_o  <= '1';
          

        when DMA_CHAIN =>
          -- Clear start next signal, to make it 1 tick pulse
          dma_ctrl_start_next_o <= '0';
          dma_fifo_llist_rden <= '0';

          if (dma_ctrl_reg(1) = '1') then
            -- Transfer aborted
            dma_ctrl_current_state <= DMA_ABORT;
          elsif(dma_ctrl_error_i = '1') then
            -- An error occurs !
            dma_error_irq          <= '1';
            dma_ctrl_current_state <= DMA_ERROR;
          elsif (dma_start_delay_s = "10") then
            -- after delay go to the start of the transfer
            dma_ctrl_current_state <= DMA_START_TRANSFER;
            dma_start_delay_s <= "00"; 
          elsif (dma_start_delay_s = "01") then
            dma_start_delay_s <= "10"; 
          elsif (next_item_valid_i = '1') then
            -- next item received, add 2 clk cycle of delay to let the output of the fifo change in case it was empty
            dma_start_delay_s <= "01";
          end if;

        when DMA_ERROR =>
          dma_status    <= c_ERROR;
          -- Clear error irq to make it 1 tick pulse
          dma_error_irq <= '0';

          if(dma_ctrl_reg(0) = '1') then
            -- Starts a new transfer
            dma_ctrl_current_state <= DMA_START_TRANSFER;
            item_count <= (others=>'0');
          end if;

        when DMA_ABORT =>
          dma_status       <= c_ABORT;
          dma_ctrl_abort_o <= '1';

          if(dma_ctrl_reg(0) = '1') then
            -- Starts a new transfer
            dma_ctrl_current_state <= DMA_START_TRANSFER;
            item_count <= (others=>'0');
          end if;

        when others =>
          dma_ctrl_current_state  <= DMA_IDLE;
          dma_ctrl_carrier_addr_o <= (others => '0');
          dma_ctrl_host_addr_h_o  <= (others => '0');
          dma_ctrl_host_addr_l_o  <= (others => '0');
          dma_ctrl_len_o          <= (others => '0');
          dma_ctrl_start_l2p_o    <= '0';
          dma_ctrl_start_p2l_o    <= '0';
          dma_ctrl_start_next_o   <= '0';
          dma_status              <= (others => '0');
          dma_error_irq           <= '0';
          dma_done_irq            <= '0';
          dma_ctrl_abort_o        <= '0';

      end case;
    end if;
  end process p_fsm;

dbg_dma_controller: if DEBUG_C = '1' generate
    debug_linkedlist : ila_llist_fifo
    PORT MAP (
      clk => clk_i,
    
      probe0(0) => fifo_rst, 
      probe1(0) => dma_fifo_llist_wren, 
      probe2(0) => dma_fifo_llist_rden, 
      probe3 => dma_fifo_llist_full, 
      probe4 => dma_fifo_llist_empty, 
      
      probe5 => dma_fifo_llist_in,
      
      probe6 => dma_fifo_llist_out(223 downto 192), 
      probe7 => dma_fifo_llist_out(191 downto 160), 
      probe8 => dma_fifo_llist_out(159 downto 128), 
      probe9 => dma_fifo_llist_out(127 downto 96), 
      probe10 => dma_fifo_llist_out(95 downto 64), 
      probe11 => dma_fifo_llist_out(63 downto 32),
      probe12 => dma_fifo_llist_out(31 downto 0),
      probe13(0) => sg_item_received_i,
      probe14 => dma_state_probe,
      probe15 => dma_ctrl_reg,
      probe16 => dma_stat_reg,
      probe17 => dma_attrib_reg,
      probe18 => dma_fifo_llist_almost_empty,
      probe19(0) => dma_ctrl_done_i,
      probe20 => item_count,
      probe21 => dma_start_delay_s
    );
  end generate dbg_dma_controller;
end behaviour;
