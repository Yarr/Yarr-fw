----------------------------------------------------------------------------------
-- Company        : ATLAS Japan Silicon Group 
-- Engineer       : Yasunori Sawada
-- 
-- Create Date    : 
-- Design Name    : YARR-based FW for KC705 Evaluation
-- Module Name    : kc705_top - Behavioral
-- Project Name   : ATLAS-J ITk DAQ (fork of YARR)
-- Target Devices : Kintex-7 KC705 Evaluation Platform
-- Tool Versions  : Xilinx Vivado 2017.1
-- Description    : 
-- 
-- Dependencies   : 
-- 
-- Revision       :
-- Revision 0.01 - File Created
-- Additional Comments:
--
----------------------------------------------------------------------------------

-- The IEEE 1164 standard defines a package design unit that contains declarations
-- that support a uniform representation of a logic value in a VHDL hardware description.
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
library UNISIM;
use UNISIM.VComponents.all;

library work;
use work.app_pkg.all;

entity bram_kc705 is
    Port (
        -- System Clock
        ---------------------------------------------------------
        CLK200_P : in  STD_LOGIC;  -- 200 MHz
        CLK200_N : in  STD_LOGIC;

        -- General Purpose Interface
        LEDS        : out   STD_LOGIC_VECTOR (8-1 downto 0);
        DIP_SW      : in    STD_LOGIC_VECTOR (3-1 downto 0);
        --PUSH_SW_C   : in    STD_LOGIC;
        --PUSH_SW_E   : in    STD_LOGIC;
        --PUSH_SW_N   : in    STD_LOGIC;
        --PUSH_SW_S   : in    STD_LOGIC;
        --PUSH_SW_W   : in    STD_LOGIC;
        SMA_P       : inout STD_LOGIC;
        SMA_N       : inout STD_LOGIC;

        rst_i       : in    STD_LOGIC;
        sys_rst_n_i : in    STD_LOGIC;

        -- I2C on FPGA
        ---------------------------------------------------------
        --I2C_SCL     : inout STD_LOGIC;
        --I2C_SDA     : inout STD_LOGIC;

        -- PCI Express Endpoint Connection
        ---------------------------------------------------------
        PCIE_REFCLK_P : in  STD_LOGIC;
        PCIE_REFCLK_N : in  STD_LOGIC;
        PCIE_RXN      : in  STD_LOGIC_VECTOR (4-1 downto 0);
        PCIE_RXP      : in  STD_LOGIC_VECTOR (4-1 downto 0);
        PCIE_TXN      : out STD_LOGIC_VECTOR (4-1 downto 0);
        PCIE_TXP      : out STD_LOGIC_VECTOR (4-1 downto 0);

        -- DDR3
        -- Memory Part : MT8JTF12864HZ-1G6G1 (Micron Technology)
        -- Memory Details : 1GB, x8, row:14, col:10, bank:3,
        --                  unbufferd, data bits per strobe:8
        --                  with data mask, single rank, 1.5V
        ---------------------------------------------------------
        --DDR3_addr    : out   STD_LOGIC_VECTOR (13 downto 0);  -- Address[0:13]
        --DDR3_ba      : out   STD_LOGIC_VECTOR (2 downto 0);   -- Bank Address
        --DDR3_cas_n   : out   STD_LOGIC;                       -- Column Address Strobe#
        --DDR3_ck_n    : out   STD_LOGIC_VECTOR (0 downto 0);   -- Clock#
        --DDR3_ck_p    : out   STD_LOGIC_VECTOR (0 downto 0);   -- Clock
        --DDR3_cke     : out   STD_LOGIC_VECTOR (0 downto 0);   -- Clock Enable
        --DDR3_cs_n    : out   STD_LOGIC_VECTOR (0 downto 0);   -- Chip Select#
        --DDR3_dm      : out   STD_LOGIC_VECTOR (7 downto 0);   -- Data Mask
        --DDR3_dq      : inout STD_LOGIC_VECTOR (63 downto 0);  -- Data
        --DDR3_dqs_n   : inout STD_LOGIC_VECTOR (7 downto 0);   -- Data Strobe#
        --DDR3_dqs_p   : inout STD_LOGIC_VECTOR (7 downto 0);   -- Data Strobe
        --DDR3_odt     : out   STD_LOGIC_VECTOR (0 downto 0);   -- On Die Termination
        --DDR3_ras_n   : out   STD_LOGIC;                       -- Row Address Strobe
        --DDR3_reset_n : out   STD_LOGIC;                       -- Reset#
        --DDR3_we_n    : out   STD_LOGIC;                       -- Write Enable#

        -- FMC-LPC
        ---------------------------------------------------------
        -- Trigger input
        ext_trig_o   : out   STD_LOGIC;
        -- LVDS buffer
        pwdn_l       : out   STD_LOGIC_VECTOR (2 downto 0);
        -- GPIO
        io           : inout STD_LOGIC_VECTOR(2 downto 0);
        -- FE-I4
        fe_clk_p     : out   STD_LOGIC_VECTOR (c_TX_CHANNELS-1 downto 0);
        fe_clk_n     : out   STD_LOGIC_VECTOR (c_TX_CHANNELS-1 downto 0);
        fe_cmd_p     : out   STD_LOGIC_VECTOR (c_TX_CHANNELS-1 downto 0);
        fe_cmd_n     : out   STD_LOGIC_VECTOR (c_TX_CHANNELS-1 downto 0);
        fe_data_p    : in    STD_LOGIC_VECTOR (c_RX_CHANNELS-1 downto 0);
        fe_data_n    : in    STD_LOGIC_VECTOR (c_RX_CHANNELS-1 downto 0);
        -- I2C
        sda_io       : inout STD_LOGIC;
        scl_io       : inout STD_LOGIC--;

        -- FMC-HPC
        ---------------------------------------------------------                

    );
    
end bram_kc705;

architecture RTL of bram_kc705 is

    -- Descriptions

    constant AXI_BUS_WIDTH : INTEGER := 64;

    ----------------------------------
    -- Components
    ----------------------------------

    -- 7 Series Integrated Block for PCI Express
    --------------------------------------------
    component pcie_7x_0
        port (
            pci_exp_txp             : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
            pci_exp_txn             : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
            pci_exp_rxp             : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
            pci_exp_rxn             : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
            user_clk_out            : OUT STD_LOGIC;
            user_reset_out          : OUT STD_LOGIC;
            user_lnk_up             : OUT STD_LOGIC;
            user_app_rdy            : OUT STD_LOGIC;
            tx_buf_av               : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
            tx_cfg_req              : OUT STD_LOGIC;
            tx_err_drop             : OUT STD_LOGIC;
            s_axis_tx_tready        : OUT STD_LOGIC;
            s_axis_tx_tdata         : IN  STD_LOGIC_VECTOR(63 DOWNTO 0);
            s_axis_tx_tkeep         : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
            s_axis_tx_tlast         : IN  STD_LOGIC;
            s_axis_tx_tvalid        : IN  STD_LOGIC;
            s_axis_tx_tuser         : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
            m_axis_rx_tdata         : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
            m_axis_rx_tkeep         : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            m_axis_rx_tlast         : OUT STD_LOGIC;
            m_axis_rx_tvalid        : OUT STD_LOGIC;
            m_axis_rx_tready        : IN  STD_LOGIC;
            m_axis_rx_tuser         : OUT STD_LOGIC_VECTOR(21 DOWNTO 0);
            cfg_status              : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            cfg_command             : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            cfg_dstatus             : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            cfg_dcommand            : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            cfg_lstatus             : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            cfg_lcommand            : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            cfg_dcommand2           : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            cfg_pcie_link_state     : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            cfg_pmcsr_pme_en        : OUT STD_LOGIC;
            cfg_pmcsr_powerstate    : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
            cfg_pmcsr_pme_status    : OUT STD_LOGIC;
            cfg_received_func_lvl_rst : OUT STD_LOGIC;
            cfg_interrupt           : IN  STD_LOGIC;
            cfg_interrupt_rdy       : OUT STD_LOGIC;
            cfg_interrupt_assert    : IN  STD_LOGIC;
            cfg_interrupt_di        : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
            cfg_interrupt_do        : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            cfg_interrupt_mmenable  : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            cfg_interrupt_msienable : OUT STD_LOGIC;
            cfg_interrupt_msixenable : OUT STD_LOGIC;
            cfg_interrupt_msixfm    : OUT STD_LOGIC;
            cfg_interrupt_stat      : IN  STD_LOGIC;
            cfg_pciecap_interrupt_msgnum : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
            cfg_to_turnoff          : OUT STD_LOGIC;
            cfg_bus_number          : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            cfg_device_number       : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
            cfg_function_number     : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            cfg_msg_received        : OUT STD_LOGIC;
            cfg_msg_data            : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            cfg_bridge_serr_en      : OUT STD_LOGIC;
            cfg_slot_control_electromech_il_ctl_pulse : OUT STD_LOGIC;
            cfg_root_control_syserr_corr_err_en       : OUT STD_LOGIC;
            cfg_root_control_syserr_non_fatal_err_en  : OUT STD_LOGIC;
            cfg_root_control_syserr_fatal_err_en      : OUT STD_LOGIC;
            cfg_root_control_pme_int_en               : OUT STD_LOGIC;
            cfg_aer_rooterr_corr_err_reporting_en     : OUT STD_LOGIC;
            cfg_aer_rooterr_non_fatal_err_reporting_en : OUT STD_LOGIC;
            cfg_aer_rooterr_fatal_err_reporting_en    : OUT STD_LOGIC;
            cfg_aer_rooterr_corr_err_received         : OUT STD_LOGIC;
            cfg_aer_rooterr_non_fatal_err_received    : OUT STD_LOGIC;
            cfg_aer_rooterr_fatal_err_received : OUT STD_LOGIC;
            cfg_msg_received_err_cor           : OUT STD_LOGIC;
            cfg_msg_received_err_non_fatal     : OUT STD_LOGIC;
            cfg_msg_received_err_fatal         : OUT STD_LOGIC;
            cfg_msg_received_pm_as_nak         : OUT STD_LOGIC;
            cfg_msg_received_pm_pme            : OUT STD_LOGIC;
            cfg_msg_received_pme_to_ack        : OUT STD_LOGIC;
            cfg_msg_received_assert_int_a      : OUT STD_LOGIC;
            cfg_msg_received_assert_int_b      : OUT STD_LOGIC;
            cfg_msg_received_assert_int_c      : OUT STD_LOGIC;
            cfg_msg_received_assert_int_d      : OUT STD_LOGIC;
            cfg_msg_received_deassert_int_a    : OUT STD_LOGIC;
            cfg_msg_received_deassert_int_b    : OUT STD_LOGIC;
            cfg_msg_received_deassert_int_c    : OUT STD_LOGIC;
            cfg_msg_received_deassert_int_d    : OUT STD_LOGIC;
            cfg_msg_received_setslotpowerlimit : OUT STD_LOGIC;
            cfg_vc_tcvc_map                    : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
            sys_clk           : IN  STD_LOGIC;
            sys_rst_n         : IN  STD_LOGIC--;
            --ext_ch_gt_drpclk  : OUT STD_LOGIC;
            --ext_ch_gt_drpaddr : IN  STD_LOGIC_VECTOR(35 DOWNTO 0);
            --ext_ch_gt_drpen   : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
            --ext_ch_gt_drpdi   : IN  STD_LOGIC_VECTOR(63 DOWNTO 0);
            --ext_ch_gt_drpwe   : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
            --ext_ch_gt_drpdo   : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
            --ext_ch_gt_drprdy  : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
            --pcie_drp_en       : IN  STD_LOGIC;
            --pcie_drp_clk      : IN  STD_LOGIC;
            --pcie_drp_we       : IN  STD_LOGIC;
            --pcie_drp_addr     : IN  STD_LOGIC_VECTOR(8 DOWNTO 0);
            --pcie_drp_di       : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
            --pcie_drp_do       : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            --pcie_drp_rdy      : OUT STD_LOGIC
        );
    end component;

    -- User logic
    --------------------------------------------
    component app is
        generic (
            DEBUG_C : std_logic_vector(3 downto 0) := "0111";
            address_mask_c : STD_LOGIC_VECTOR(32-1 downto 0) := X"000FFFFF";
            DMA_MEMORY_SELECTED : string := "BRAM"
        );

        port (
            clk_i       : in STD_LOGIC;
            sys_clk_n_i : in STD_LOGIC;
            sys_clk_p_i : in STD_LOGIC;
            rst_i       : in STD_LOGIC;

            user_lnk_up_i  : in STD_LOGIC;
            user_app_rdy_i : in STD_LOGIC;

            -- AXI-Stream bus
            m_axis_tx_tready_i : in  STD_LOGIC;
            m_axis_tx_tdata_o  : out STD_LOGIC_VECTOR(AXI_BUS_WIDTH-1 DOWNTO 0);
            m_axis_tx_tkeep_o  : out STD_LOGIC_VECTOR(AXI_BUS_WIDTH/8-1 DOWNTO 0);
            m_axis_tx_tlast_o  : out STD_LOGIC;
            m_axis_tx_tvalid_o : out STD_LOGIC;
            m_axis_tx_tuser_o  : out STD_LOGIC_VECTOR(3 DOWNTO 0);
            s_axis_rx_tdata_i  : in  STD_LOGIC_VECTOR(AXI_BUS_WIDTH-1 DOWNTO 0);
            s_axis_rx_tkeep_i  : in  STD_LOGIC_VECTOR(AXI_BUS_WIDTH/8-1 DOWNTO 0);
            s_axis_rx_tlast_i  : in  STD_LOGIC;
            s_axis_rx_tvalid_i : in  STD_LOGIC;
            s_axis_rx_tready_o : out STD_LOGIC;
            s_axis_rx_tuser_i  : in  STD_LOGIC_VECTOR(21 DOWNTO 0);

            -- PCIe interrupt config
            cfg_interrupt_o            : out STD_LOGIC;
            cfg_interrupt_rdy_i        : in  STD_LOGIC;
            cfg_interrupt_assert_o     : out STD_LOGIC;
            cfg_interrupt_di_o         : out STD_LOGIC_VECTOR(7 DOWNTO 0);
            cfg_interrupt_do_i         : in  STD_LOGIC_VECTOR(7 DOWNTO 0);
            cfg_interrupt_mmenable_i   : in  STD_LOGIC_VECTOR(2 DOWNTO 0);
            cfg_interrupt_msienable_i  : in  STD_LOGIC;
            cfg_interrupt_msixenable_i : in  STD_LOGIC;
            cfg_interrupt_msixfm_i     : in  STD_LOGIC;
            cfg_interrupt_stat_o       : out STD_LOGIC;
            cfg_pciecap_interrupt_msgnum_o : out STD_LOGIC_VECTOR(4 DOWNTO 0);

            -- PCIe ID
            cfg_bus_number_i      : in STD_LOGIC_VECTOR(7 DOWNTO 0);
            cfg_device_number_i   : in STD_LOGIC_VECTOR(4 DOWNTO 0);
            cfg_function_number_i : in STD_LOGIC_VECTOR(2 DOWNTO 0);
 
            -- PCIe debug
            tx_err_drop_i : in STD_LOGIC;
            cfg_dstatus_i : in STD_LOGIC_VECTOR(15 DOWNTO 0);

            --DDR3
            ddr3_dq_io       : inout std_logic_vector(63 downto 0);
            ddr3_dqs_p_io    : inout std_logic_vector(7 downto 0);
            ddr3_dqs_n_io    : inout std_logic_vector(7 downto 0);

            --init_calib_complete_o : out std_logic;

            ddr3_addr_o     : out   std_logic_vector(14 downto 0);
            ddr3_ba_o       : out   std_logic_vector(2 downto 0);
            ddr3_ras_n_o    : out   std_logic;
            ddr3_cas_n_o    : out   std_logic;
            ddr3_we_n_o     : out   std_logic;
            ddr3_reset_n_o  : out   std_logic;
            ddr3_ck_p_o     : out   std_logic_vector(0 downto 0);
            ddr3_ck_n_o     : out   std_logic_vector(0 downto 0);
            ddr3_cke_o      : out   std_logic_vector(0 downto 0);
            ddr3_cs_n_o     : out   std_logic_vector(0 downto 0);
            ddr3_dm_o       : out   std_logic_vector(7 downto 0);
            ddr3_odt_o      : out   std_logic_vector(0 downto 0);

            ---------------------------------------------------------
            -- FMC
            ---------------------------------------------------------
            -- Trigger input
            ext_trig_o        : out std_logic;
            -- LVDS buffer
            pwdn_l            : out std_logic_vector(2 downto 0);
            -- GPIO
            --io              : inout std_logic_vector(2 downto 0);
            -- FE-I4
            fe_clk_p         : out std_logic_vector(c_TX_CHANNELS-1 downto 0);
            fe_clk_n         : out std_logic_vector(c_TX_CHANNELS-1 downto 0);
            fe_cmd_p         : out std_logic_vector(c_TX_CHANNELS-1 downto 0);
            fe_cmd_n         : out std_logic_vector(c_TX_CHANNELS-1 downto 0);
            fe_data_p        : in  std_logic_vector(c_RX_CHANNELS-1 downto 0);
            fe_data_n        : in  std_logic_vector(c_RX_CHANNELS-1 downto 0);

            -- I2c
            sda_io           : inout std_logic;
            scl_io           : inout std_logic;

            --I/O
            usr_sw_i    : in STD_LOGIC_VECTOR (2 downto 0);
            usr_led_o   : out STD_LOGIC_VECTOR (3 downto 0);
            front_led_o : out STD_LOGIC_VECTOR (3 downto 0)
        );
    end component;

    ----------------------------------
    -- Signals declaration
    ----------------------------------

    --Clocks
    signal sys_clk : STD_LOGIC;
    --signal clk200 : STD_LOGIC;
    signal aclk    : STD_LOGIC;

    signal arstn_s : STD_LOGIC;
    signal rst_s   : STD_LOGIC;

    --Wishbone bus

    signal usr_led_s : std_logic_vector(3 downto 0);
    --signal count_s : STD_LOGIC_VECTOR (28 downto 0);


    -- AXI-stream bus to PCIE
    signal s_axis_tx_tready_s : STD_LOGIC;
    signal s_axis_tx_tdata_s  : STD_LOGIC_VECTOR(AXI_BUS_WIDTH-1 DOWNTO 0);
    signal s_axis_tx_tkeep_s  : STD_LOGIC_VECTOR(AXI_BUS_WIDTH/8-1 DOWNTO 0);
    signal s_axis_tx_tlast_s  : STD_LOGIC;
    signal s_axis_tx_tvalid_s : STD_LOGIC;
    signal s_axis_tx_tuser_s  : STD_LOGIC_VECTOR(3 DOWNTO 0);
    signal m_axis_rx_tdata_s  : STD_LOGIC_VECTOR(AXI_BUS_WIDTH-1 DOWNTO 0);
    signal m_axis_rx_tkeep_s  : STD_LOGIC_VECTOR(AXI_BUS_WIDTH/8-1 DOWNTO 0);
    signal m_axis_rx_tlast_s  : STD_LOGIC;
    signal m_axis_rx_tvalid_s : STD_LOGIC;
    signal m_axis_rx_tready_s : STD_LOGIC;
    signal m_axis_rx_tuser_s  : STD_LOGIC_VECTOR(21 DOWNTO 0);

    -- PCIE signals
    signal user_lnk_up_s  : STD_LOGIC;
    signal user_app_rdy_s : STD_LOGIC;
    signal tx_err_drop_s  : STD_LOGIC;
    signal cfg_interrupt_s                : STD_LOGIC;
    signal cfg_interrupt_rdy_s            : STD_LOGIC;
    signal cfg_interrupt_assert_s         : STD_LOGIC;
    signal cfg_interrupt_di_s             : STD_LOGIC_VECTOR(7 DOWNTO 0);
    signal cfg_interrupt_do_s             : STD_LOGIC_VECTOR(7 DOWNTO 0);
    signal cfg_interrupt_mmenable_s       : STD_LOGIC_VECTOR(2 DOWNTO 0);
    signal cfg_interrupt_msienable_s      : STD_LOGIC;
    signal cfg_interrupt_msixenable_s     : STD_LOGIC;
    signal cfg_interrupt_msixfm_s         : STD_LOGIC;
    signal cfg_interrupt_stat_s           : STD_LOGIC;
    signal cfg_pciecap_interrupt_msgnum_s : STD_LOGIC_VECTOR(4 DOWNTO 0);

    -- PCIE ID
    signal cfg_bus_number_s      : STD_LOGIC_VECTOR(7 DOWNTO 0);
    signal cfg_device_number_s   : STD_LOGIC_VECTOR(4 DOWNTO 0);
    signal cfg_function_number_s : STD_LOGIC_VECTOR(2 DOWNTO 0);

    --PCIE debug
    signal cfg_dstatus_s : STD_LOGIC_VECTOR(15 DOWNTO 0);
    
begin

    -- LVDS input to internal single
    --  CLK_IBUFDS : IBUFDS
    --  generic map(
    --    IOSTANDARD => "DEFAULT"
    --  )
    --  port map(
    --    I  => clk200_p,
    --    IB => clk200_n,
    --    O  => clk200
    --  );

    --    design_1_0: component design_1
    --     port map (
    --      CLK_IN_D_clk_n(0) => PCIE_REFCLK_N,
    --      CLK_IN_D_clk_p(0) => PCIE_REFCLK_P,
    --      IBUF_OUT(0) => sys_clk
    --    );

    refclk_ibuf : IBUFDS_GTE2
        port map(
            O       => sys_clk,
            ODIV2   => open,
            I       => PCIE_REFCLK_P,
            IB      => PCIE_REFCLK_N,
            CEB     => '0'
        );
        
    rst_s   <= rst_i;
    arstn_s <= sys_rst_n_i or rst_i;

    pcie_0 : pcie_7x_0
        PORT MAP (
            pci_exp_txp  => PCIE_TXP,
            pci_exp_txn  => PCIE_TXN,
            pci_exp_rxp  => PCIE_RXP,
            pci_exp_rxn  => PCIE_RXN,
            user_clk_out => aclk,
            user_reset_out => open, -- TODO
            user_lnk_up    => user_lnk_up_s,
            user_app_rdy   => user_app_rdy_s,
            tx_err_drop    => tx_err_drop_s,
            s_axis_tx_tready => s_axis_tx_tready_s,
            s_axis_tx_tdata  => s_axis_tx_tdata_s,
            s_axis_tx_tkeep  => s_axis_tx_tkeep_s,
            s_axis_tx_tlast  => s_axis_tx_tlast_s,
            s_axis_tx_tvalid => s_axis_tx_tvalid_s,
            s_axis_tx_tuser  => s_axis_tx_tuser_s,
            m_axis_rx_tdata  => m_axis_rx_tdata_s,
            m_axis_rx_tkeep  => m_axis_rx_tkeep_s,
            m_axis_rx_tlast  => m_axis_rx_tlast_s,
            m_axis_rx_tvalid => m_axis_rx_tvalid_s,
            m_axis_rx_tready => m_axis_rx_tready_s,
            m_axis_rx_tuser  => m_axis_rx_tuser_s,
            cfg_interrupt            => cfg_interrupt_s,
            cfg_interrupt_rdy        => cfg_interrupt_rdy_s,
            cfg_interrupt_assert     => cfg_interrupt_assert_s,
            cfg_interrupt_di         => cfg_interrupt_di_s,
            cfg_interrupt_do         => cfg_interrupt_do_s,
            cfg_interrupt_mmenable   => cfg_interrupt_mmenable_s,
            cfg_interrupt_msienable  => cfg_interrupt_msienable_s,
            cfg_interrupt_msixenable => cfg_interrupt_msixenable_s,
            cfg_interrupt_msixfm     => cfg_interrupt_msixfm_s,
            cfg_interrupt_stat       => cfg_interrupt_stat_s,
            cfg_pciecap_interrupt_msgnum => cfg_pciecap_interrupt_msgnum_s,
            cfg_dstatus               => cfg_dstatus_s,
            cfg_bus_number      => cfg_bus_number_s,
            cfg_device_number   => cfg_device_number_s,
            cfg_function_number => cfg_function_number_s,
            
            sys_clk   => sys_clk,
            sys_rst_n => sys_rst_n_i
        );
        
        app_0 : app
        Generic map(
            DEBUG_C             => "0111",
            address_mask_c      => X"000FFFFF",
            DMA_MEMORY_SELECTED => "BRAM"
        )
        port map(
            clk_i               => aclk,
            sys_clk_n_i         => CLK200_N,
            sys_clk_p_i         => CLK200_P,
            rst_i               => rst_s,
            user_lnk_up_i       => user_lnk_up_s,
            user_app_rdy_i      => user_app_rdy_s,
            
            -- AXI-Stream bus
            m_axis_tx_tready_i  => s_axis_tx_tready_s,
            m_axis_tx_tdata_o   => s_axis_tx_tdata_s,
            m_axis_tx_tkeep_o   => s_axis_tx_tkeep_s,
            m_axis_tx_tlast_o   => s_axis_tx_tlast_s,
            m_axis_tx_tvalid_o  => s_axis_tx_tvalid_s,
            m_axis_tx_tuser_o   => s_axis_tx_tuser_s,
            s_axis_rx_tdata_i   => m_axis_rx_tdata_s,
            s_axis_rx_tkeep_i   => m_axis_rx_tkeep_s,
            s_axis_rx_tlast_i   => m_axis_rx_tlast_s,
            s_axis_rx_tvalid_i  => m_axis_rx_tvalid_s,
            s_axis_rx_tready_o  => m_axis_rx_tready_s,
            s_axis_rx_tuser_i   => m_axis_rx_tuser_s,
            
            -- PCIe interrupt config
            cfg_interrupt_o                => cfg_interrupt_s,
            cfg_interrupt_rdy_i            => cfg_interrupt_rdy_s,
            cfg_interrupt_assert_o         => cfg_interrupt_assert_s,
            cfg_interrupt_di_o             => cfg_interrupt_di_s,
            cfg_interrupt_do_i             => cfg_interrupt_do_s,
            cfg_interrupt_mmenable_i       => cfg_interrupt_mmenable_s,
            cfg_interrupt_msienable_i      => cfg_interrupt_msienable_s,
            cfg_interrupt_msixenable_i     => cfg_interrupt_msixenable_s,
            cfg_interrupt_msixfm_i         => cfg_interrupt_msixfm_s,
            cfg_interrupt_stat_o           => cfg_interrupt_stat_s,
            cfg_pciecap_interrupt_msgnum_o => cfg_pciecap_interrupt_msgnum_s,
            
            -- PCIe ID
            cfg_bus_number_i      => cfg_bus_number_s,
            cfg_device_number_i   =>  cfg_device_number_s,
            cfg_function_number_i => cfg_function_number_s,
            
            -- PCIe debug
            tx_err_drop_i    => tx_err_drop_s,
            cfg_dstatus_i    => cfg_dstatus_s,
            
            --DDR3
            --ddr3_dq_io       => DDR3_dq,
            --ddr3_dqs_p_io    => DDR3_dqs_p,
            --ddr3_dqs_n_io    => DDR3_dqs_n,
            
            --init_calib_complete_o => init_calib_complete,

            --ddr3_addr_o     => DDR3_addr,
            --ddr3_ba_o       => DDR3_ba,
            --ddr3_ras_n_o    => DDR3_ras_n,
            --ddr3_cas_n_o    => DDR3_cas_n,
            --ddr3_we_n_o     => DDR3_we_n,
            --ddr3_reset_n_o  => DDR3_reset_n,
            --ddr3_ck_p_o     => DDR3_ck_p,
            --ddr3_ck_n_o     => DDR3_ck_n,
            --ddr3_cke_o      => DDR3_cke,
            --ddr3_cs_n_o     => DDR3_cs_n,
            --ddr3_dm_o       => DDR3_dm,
            --ddr3_odt_o      => DDR3_odt,

            ---------------------------------------------------------
            -- FMC
            ---------------------------------------------------------
            -- Trigger input
            ext_trig_o        => ext_trig_o,
            -- LVDS buffer
            pwdn_l            => pwdn_l,
            -- GPIO
            --io                => io,
            -- FE-I4
            fe_clk_p          => fe_clk_p,
            fe_clk_n          => fe_clk_n,
            fe_cmd_p          => fe_cmd_p,
            fe_cmd_n          => fe_cmd_n,
            fe_data_p         => fe_data_p,
            fe_data_n         => fe_data_n,
            -- I2c
            --sda_io            => I2C_SDA,
            --scl_io            => I2C_SCL,

            --I/O
            --usr_sw_i   => usr_sw_i,
            usr_sw_i    => DIP_SW,
            usr_led_o   => usr_led_s,
            front_led_o => open--front_led_o
        );   
    
    LEDS(0) <= usr_led_s(0);
    LEDS(1) <= usr_led_s(1);
    LEDS(2) <= usr_led_s(2);
    LEDS(3) <= usr_led_s(3);
    LEDS(4) <= '0';
    LEDS(5) <= '0';
    LEDS(6) <= user_lnk_up_s;
    LEDS(7) <= user_app_rdy_s;

end architecture RTL;