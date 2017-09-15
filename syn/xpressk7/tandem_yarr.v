//-----------------------------------------------------------------------------
//
// (c) Copyright 2010-2011 Xilinx, Inc. All rights reserved.
//
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
//
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
//
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
//
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
//
//-----------------------------------------------------------------------------
// Project    : Series-7 Integrated Block for PCI Express
// File       : xilinx_pcie_2_1_ep_7x.v
// Version    : 3.3
//--
//-- Description:  PCI Express Endpoint example FPGA design
//--
//------------------------------------------------------------------------------

`timescale 1ns / 1ps
(* DowngradeIPIdentifiedWarnings = "yes" *)
module yarr # (
  parameter PL_FAST_TRAIN       = "FALSE", // Simulation Speedup
  parameter EXT_PIPE_SIM        = "FALSE",  // This Parameter has effect on selecting Enable External PIPE Interface in GUI.	
  parameter PCIE_EXT_CLK        = "FALSE",    // Use External Clocking Module
  parameter PCIE_EXT_GT_COMMON  = "FALSE",
  parameter REF_CLK_FREQ        = 0,     // 0 - 100 MHz, 1 - 125 MHz, 2 - 250 MHz
  parameter C_DATA_WIDTH        = 64, // RX/TX interface data width
  parameter KEEP_WIDTH          = C_DATA_WIDTH / 8 // TSTRB width
) (
  output  [3:0]    pci_exp_txp,
  output  [3:0]    pci_exp_txn,
  input   [3:0]    pci_exp_rxp,
  input   [3:0]    pci_exp_rxn,



  input             pcie_clk_p,
  input             pcie_clk_n,
  input             clk200_p,
  input             clk200_n,
  input             sys_rst_n_i,
  input             rst_n_i,
  
  input    [2:0]    usr_sw_i,
  output   [2:0]    usr_led_o
);

// Wire Declarations

  wire                                        user_clk;
  wire                                        user_reset;
  wire                                        user_lnk_up;

  // Tx
  wire                                        s_axis_tx_tready;
  wire [3:0]                                  s_axis_tx_tuser;
  wire [C_DATA_WIDTH-1:0]                     s_axis_tx_tdata;
  wire [KEEP_WIDTH-1:0]                       s_axis_tx_tkeep;
  wire                                        s_axis_tx_tlast;
  wire                                        s_axis_tx_tvalid;

  // Rx
  wire [C_DATA_WIDTH-1:0]                     m_axis_rx_tdata;
  wire [KEEP_WIDTH-1:0]                       m_axis_rx_tkeep;
  wire                                        m_axis_rx_tlast;
  wire                                        m_axis_rx_tvalid;
  wire                                        m_axis_rx_tready;
  wire  [21:0]                                m_axis_rx_tuser;




  wire                                        cfg_interrupt;
  wire                                        cfg_interrupt_rdy;
  wire                                        cfg_interrupt_assert;
  wire   [7:0]                                cfg_interrupt_di;
  wire   [7:0]                                cfg_interrupt_do;
  wire                                        cfg_interrupt_stat;
  wire   [4:0]                                cfg_pciecap_interrupt_msgnum;

  wire                                        cfg_to_turnoff;
  wire   [7:0]                                cfg_bus_number;
  wire   [4:0]                                cfg_device_number;
  wire   [2:0]                                cfg_function_number;

  //wire rst_s;

  wire                                        sys_rst_n_c;
  wire                                        sys_clk;


// Register Declaration

  reg                                         user_reset_q;
  reg                                         user_lnk_up_q;

// Local Parameters
  localparam TCQ               = 1;
  localparam USER_CLK_FREQ     = 3;
  localparam USER_CLK2_DIV2    = "FALSE";
  localparam USERCLK2_FREQ     = (USER_CLK2_DIV2 == "TRUE") ? (USER_CLK_FREQ == 4) ? 3 : (USER_CLK_FREQ == 3) ? 2 : USER_CLK_FREQ: USER_CLK_FREQ;


 //-----------------------------I/O BUFFERS------------------------//

  IBUF   sys_reset_n_ibuf (.O(sys_rst_n_c), .I(sys_rst_n_i));

  IBUFDS_GTE2 refclk_ibuf (.O(sys_clk), .ODIV2(), .I(pcie_clk_p), .CEB(1'b0), .IB(pcie_clk_n));


  always @(posedge user_clk) begin
    user_reset_q  <= user_reset;
    user_lnk_up_q <= user_lnk_up;
  end


    wire rst_s = ~rst_n_i;



pcie_7x_t pcie_0
 (

  //----------------------------------------------------------------------------------------------------------------//
  // PCI Express (pci_exp) Interface                                                                                //
  //----------------------------------------------------------------------------------------------------------------//
  // Tx
  .pci_exp_txn                               ( pci_exp_txn ),
  .pci_exp_txp                               ( pci_exp_txp ),

  // Rx
  .pci_exp_rxn                               ( pci_exp_rxn ),
  .pci_exp_rxp                               ( pci_exp_rxp ),

  //----------------------------------------------------------------------------------------------------------------//
  // AXI-S Interface                                                                                                //
  //----------------------------------------------------------------------------------------------------------------//
  // Common
  .user_clk_out                              ( user_clk ),
  .user_reset_out                            (),//( user_reset ),
  .user_lnk_up                               ( user_lnk_up ),
  .user_app_rdy                              ( ),

  // TX
  .s_axis_tx_tready                          ( s_axis_tx_tready ),
  .s_axis_tx_tdata                           ( s_axis_tx_tdata ),
  .s_axis_tx_tkeep                           ( s_axis_tx_tkeep ),
  .s_axis_tx_tuser                           ( s_axis_tx_tuser ),
  .s_axis_tx_tlast                           ( s_axis_tx_tlast ),
  .s_axis_tx_tvalid                          ( s_axis_tx_tvalid ),

  // Rx
  .m_axis_rx_tdata                           ( m_axis_rx_tdata ),
  .m_axis_rx_tkeep                           ( m_axis_rx_tkeep ),
  .m_axis_rx_tlast                           ( m_axis_rx_tlast ),
  .m_axis_rx_tvalid                          ( m_axis_rx_tvalid ),
  .m_axis_rx_tready                          ( m_axis_rx_tready ),
  .m_axis_rx_tuser                           ( m_axis_rx_tuser ),



  //----------------------------------------------------------------------------------------------------------------//
  // Configuration (CFG) Interface                                                                                  //
  //----------------------------------------------------------------------------------------------------------------//
  .cfg_device_number                         ( cfg_device_number ),
  .cfg_dcommand2                             ( ),
  .cfg_pmcsr_pme_status                      ( ),
  .cfg_status                                ( ),
  .cfg_to_turnoff                            ( cfg_to_turnoff ),
  .cfg_received_func_lvl_rst                 ( ),
  .cfg_dcommand                              ( ),
  .cfg_bus_number                            ( cfg_bus_number ),
  .cfg_function_number                       ( cfg_function_number ),
  .cfg_command                               ( ),
  .cfg_dstatus                               ( cfg_dstatus ),
  .cfg_lstatus                               ( ),
  .cfg_pcie_link_state                       ( ),
  .cfg_lcommand                              ( ),
  .cfg_pmcsr_pme_en                          ( ),
  .cfg_pmcsr_powerstate                      ( ),
  .tx_buf_av                                 ( ),
  .tx_err_drop                               ( ),
  .tx_cfg_req                                ( ),
  //------------------------------------------------//
  // RP Only                                        //
  //------------------------------------------------//
  .cfg_bridge_serr_en                        ( ),
  .cfg_slot_control_electromech_il_ctl_pulse ( ),
  .cfg_root_control_syserr_corr_err_en       ( ),
  .cfg_root_control_syserr_non_fatal_err_en  ( ),
  .cfg_root_control_syserr_fatal_err_en      ( ),
  .cfg_root_control_pme_int_en               ( ),
  .cfg_aer_rooterr_corr_err_reporting_en     ( ),
  .cfg_aer_rooterr_non_fatal_err_reporting_en( ),
  .cfg_aer_rooterr_fatal_err_reporting_en    ( ),
  .cfg_aer_rooterr_corr_err_received         ( ),
  .cfg_aer_rooterr_non_fatal_err_received    ( ),
  .cfg_aer_rooterr_fatal_err_received        ( ),

  //----------------------------------------------------------------------------------------------------------------//
  // VC interface                                                                                                   //
  //----------------------------------------------------------------------------------------------------------------//
  .cfg_vc_tcvc_map                           ( ),



  //------------------------------------------------//
  // EP Only                                        //
  //------------------------------------------------//
  .cfg_interrupt                             ( cfg_interrupt ),
  .cfg_interrupt_rdy                         ( cfg_interrupt_rdy),
  .cfg_interrupt_assert                      ( cfg_interrupt_assert ),
  .cfg_interrupt_di                          ( cfg_interrupt_di ),
  .cfg_interrupt_do                          ( cfg_interrupt_do),
  .cfg_interrupt_mmenable                    ( cfg_interrupt_mmenable),
  .cfg_interrupt_msienable                   ( cfg_interrupt_msienable),
  .cfg_interrupt_msixenable                  ( cfg_interrupt_msixenable),
  .cfg_interrupt_msixfm                      ( cfg_interrupt_msixfm),
  .cfg_interrupt_stat                        ( cfg_interrupt_stat ),
  .cfg_pciecap_interrupt_msgnum              ( cfg_pciecap_interrupt_msgnum ),

  .cfg_msg_received_err_cor                  ( ),
  .cfg_msg_received_err_non_fatal            ( ),
  .cfg_msg_received_err_fatal                ( ),
  .cfg_msg_received_pm_as_nak                ( ),
  .cfg_msg_received_pme_to_ack               ( ),
  .cfg_msg_received_assert_int_a             ( ),
  .cfg_msg_received_assert_int_b             ( ),
  .cfg_msg_received_assert_int_c             ( ),
  .cfg_msg_received_assert_int_d             ( ),
  .cfg_msg_received_deassert_int_a           ( ),
  .cfg_msg_received_deassert_int_b           ( ),
  .cfg_msg_received_deassert_int_c           ( ),
  .cfg_msg_received_deassert_int_d           ( ),

  .cfg_msg_received_pm_pme                   ( ),
  .cfg_msg_received_setslotpowerlimit        ( ),
  .cfg_msg_received                          ( ),
  .cfg_msg_data                              ( ),


  //----------------------------------------------------------------------------------------------------------------//
  // PCIe Fast Config: Startup Interface - Can only be used in Tandem Mode                                          //
  //----------------------------------------------------------------------------------------------------------------//
  .startup_cfgclk                           ( ),              // 1-bit output: Configuration main clock output
  .startup_cfgmclk                          ( ),              // 1-bit output: Configuration internal oscillator clock output
  .startup_eos                              ( ),              // 1-bit output: Active high output signal indicating the End Of Startup.
  .startup_preq                             ( ),              // 1-bit output: PROGRAM request to fabric output
  .startup_clk                              ( 1'b0 ),         // 1-bit input: User start-up clock input
  .startup_gsr                              ( 1'b0 ),         // 1-bit input: Global Set/Reset input (GSR cannot be used for the port name)
  .startup_gts                              ( 1'b0 ),         // 1-bit input: Global 3-state input (GTS cannot be used for the port name)
  .startup_keyclearb                        ( 1'b1 ),         // 1-bit input: Clear AES Decrypter Key input from Battery-Backed RAM (BBRAM)
  .startup_pack                             ( 1'b0 ),         // 1-bit input: PROGRAM acknowledge input
  .startup_usrcclko                         ( 1'b0 ),         // 1-bit input: User CCLK input
  .startup_usrcclkts                        ( 1'b1 ),         // 1-bit input: User CCLK 3-state enable input
  .startup_usrdoneo                         ( 1'b0 ),         // 1-bit input: User DONE pin output control
  .startup_usrdonets                        ( 1'b1 ),         // 1-bit input: User DONE 3-state enable output

  //----------------------------------------------------------------------------------------------------------------//
  // PCIe Fast Config: ICAP Interface - Can only be used in Tandem PCIe Mode                                        //
  //----------------------------------------------------------------------------------------------------------------//
  .icap_clk                                   ( 1'b0 ),    // input clock: 100MHz or slower
  .icap_csib                                  ( 1'b1 ),  
  .icap_rdwrb                                 ( 1'b1 ),  
  .icap_i                                     ( 32'hFFFFFFFF ),  
  .icap_o                                     ( ),      




  //----------------------------------------------------------------------------------------------------------------//
  // System  (SYS) Interface                                                                                        //
  //----------------------------------------------------------------------------------------------------------------//
  .sys_clk                                    ( sys_clk ),
  .sys_rst_n                                  ( sys_rst_n_c )

);


app  #(
  .DEBUG_C ( 4'b0001 ),
  .address_mask_c ( 32'h00FFFFFF ), // 128 Mbyte, 2^24-1
  .DMA_MEMORY_SELECTED ( "BRAM" ),
  .wb_dev_g  ( 1'b0 )
) app_0 (

  //----------------------------------------------------------------------------------------------------------------//
  // AXI-S Interface                                                                                                //
  //----------------------------------------------------------------------------------------------------------------//

  // Common
  .clk_i                      ( user_clk ),
  .sys_clk_n_i                     (1'b0),
  .sys_clk_p_i                     (1'b0),
  .rst_i                     (rst_s),//( user_reset_q ),
  .user_lnk_up_i                    ( user_lnk_up_q ),
  .user_app_rdy_i                   (1'b0),

  // Tx
  .m_axis_tx_tready_i               ( s_axis_tx_tready ),
  .m_axis_tx_tdata_o                ( s_axis_tx_tdata ),
  .m_axis_tx_tkeep_o                ( s_axis_tx_tkeep ),
  .m_axis_tx_tuser_o                ( s_axis_tx_tuser ),
  .m_axis_tx_tlast_o                ( s_axis_tx_tlast ),
  .m_axis_tx_tvalid_o               ( s_axis_tx_tvalid ),

  // Rx
  .s_axis_rx_tdata_i                ( m_axis_rx_tdata ),
  .s_axis_rx_tkeep_i                ( m_axis_rx_tkeep ),
  .s_axis_rx_tlast_i                ( m_axis_rx_tlast ),
  .s_axis_rx_tvalid_i               ( m_axis_rx_tvalid ),
  .s_axis_rx_tready_o               ( m_axis_rx_tready ),
  .s_axis_rx_tuser_i                ( m_axis_rx_tuser ),




  //.cfg_to_turnoff                 ( cfg_to_turnoff ),
  .cfg_bus_number_i                 ( cfg_bus_number ),
  .cfg_device_number_i              ( cfg_device_number ),
  .cfg_function_number_i            ( cfg_function_number ),



  .cfg_interrupt_o                  ( cfg_interrupt ),
  .cfg_interrupt_rdy_i              (cfg_interrupt_rdy),
  .cfg_interrupt_assert_o           ( cfg_interrupt_assert ),
  .cfg_interrupt_di_o               ( cfg_interrupt_di ),
  .cfg_interrupt_do_i               ( cfg_interrupt_do ),
  .cfg_interrupt_mmenable_i         ( cfg_interrupt_mmenable ),
  .cfg_interrupt_msienable_i        ( cfg_interrupt_msienable ),
  .cfg_interrupt_msixenable_i       ( cfg_interrupt_msixenable ),
  .cfg_interrupt_msixfm_i           ( cfg_interrupt_msixfm ),
  .cfg_interrupt_stat_o             ( cfg_interrupt_stat ),
  .cfg_pciecap_interrupt_msgnum_o   ( cfg_pciecap_interrupt_msgnum ),
  
  .usr_led_o (usr_led_o),
  .usr_sw_i (usr_sw_i),
  .front_led_o (front_led_o)

);

endmodule
