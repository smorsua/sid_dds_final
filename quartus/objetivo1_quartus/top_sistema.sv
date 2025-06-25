//============================================================================
// Copyright (c) 2013 by Terasic Technologies Inc.
// ============================================================================
//
// Permission:
//
//   Terasic grants permission to use and modify this code for use
//   in synthesis for all Terasic Development Boards and Altera Development 
//   Kits made by Terasic.  Other use of this code, including the selling 
//   ,duplication, or modification of any portion is strictly prohibited.
//
// Disclaimer:
//
//   This VHDL/Verilog or C/C++ source code is intended as a design reference
//   which illustrates how these types of functions can be implemented.
//   It is the user's responsibility to verify their design for
//   consistency and functionality through the use of formal
//   verification methods.  Terasic provides no warranty regarding the use 
//   or functionality of this code.
//
// ============================================================================
//           
//  Terasic Technologies Inc
//  9F., No.176, Sec.2, Gongdao 5th Rd, East Dist, Hsinchu City, 30070. Taiwan
//  
//  
//                     web: http://www.terasic.com/  
//                     email: support@terasic.com
//
// ============================================================================
//Date:  Thu Jul 11 11:26:45 2013
// ============================================================================

//`define ENABLE_HPS
//`define ENABLE_USB

module top_sistema(

      ///////// ADC /////////
      inout              ADC_CS_N,
      output             ADC_DIN,
      input              ADC_DOUT,
      output             ADC_SCLK,

      ///////// AUD /////////
      input              AUD_ADCDAT,
      inout              AUD_ADCLRCK,
      inout              AUD_BCLK,
      output             AUD_DACDAT,
      inout              AUD_DACLRCK,
      output             AUD_XCK,

      ///////// CLOCK2 /////////
      input              CLOCK2_50,

      ///////// CLOCK3 /////////
      input              CLOCK3_50,

      ///////// CLOCK4 /////////
      input              CLOCK4_50,

      ///////// CLOCK /////////
      input              CLOCK_50,

      ///////// DRAM /////////
      output      [12:0] DRAM_ADDR,
      output      [1:0]  DRAM_BA,
      output             DRAM_CAS_N,
      output             DRAM_CKE,
      output             DRAM_CLK,
      output             DRAM_CS_N,
      inout       [15:0] DRAM_DQ,
      output             DRAM_LDQM,
      output             DRAM_RAS_N,
      output             DRAM_UDQM,
      output             DRAM_WE_N,

      ///////// FAN /////////
      output             FAN_CTRL,

      ///////// FPGA /////////
      output             FPGA_I2C_SCLK,
      inout              FPGA_I2C_SDAT,

      ///////// GPIO /////////
     // inout     [35:0]   GPIO_0,
		
		///////// HEX0 /////////
      output      [6:0]  HEX0,

      ///////// HEX1 /////////
      output      [6:0]  HEX1,

      ///////// HEX2 /////////
      output      [6:0]  HEX2,

      ///////// HEX3 /////////
      output      [6:0]  HEX3,

      ///////// HEX4 /////////
      output      [6:0]  HEX4,

      ///////// HEX5 /////////
      output      [6:0]  HEX5,

`ifdef ENABLE_HPS
      ///////// HPS /////////
      input              HPS_CONV_USB_N,
      output      [14:0] HPS_DDR3_ADDR,
      output      [2:0]  HPS_DDR3_BA,
      output             HPS_DDR3_CAS_N,
      output             HPS_DDR3_CKE,
      output             HPS_DDR3_CK_N,
      output             HPS_DDR3_CK_P,
      output             HPS_DDR3_CS_N,
      output      [3:0]  HPS_DDR3_DM,
      inout       [31:0] HPS_DDR3_DQ,
      inout       [3:0]  HPS_DDR3_DQS_N,
      inout       [3:0]  HPS_DDR3_DQS_P,
      output             HPS_DDR3_ODT,
      output             HPS_DDR3_RAS_N,
      output             HPS_DDR3_RESET_N,
      input              HPS_DDR3_RZQ,
      output             HPS_DDR3_WE_N,
      output             HPS_ENET_GTX_CLK,
      inout              HPS_ENET_INT_N,
      output             HPS_ENET_MDC,
      inout              HPS_ENET_MDIO,
      input              HPS_ENET_RX_CLK,
      input       [3:0]  HPS_ENET_RX_DATA,
      input              HPS_ENET_RX_DV,
      output      [3:0]  HPS_ENET_TX_DATA,
      output             HPS_ENET_TX_EN,
      inout       [3:0]  HPS_FLASH_DATA,
      output             HPS_FLASH_DCLK,
      output             HPS_FLASH_NCSO,
      inout              HPS_GSENSOR_INT,
      inout              HPS_I2C1_SCLK,
      inout              HPS_I2C1_SDAT,
      inout              HPS_I2C2_SCLK,
      inout              HPS_I2C2_SDAT,
      inout              HPS_I2C_CONTROL,
      inout              HPS_KEY,
      inout              HPS_LED,
      inout              HPS_LTC_GPIO,
      output             HPS_SD_CLK,
      inout              HPS_SD_CMD,
      inout       [3:0]  HPS_SD_DATA,
      output             HPS_SPIM_CLK,
      input              HPS_SPIM_MISO,
      output             HPS_SPIM_MOSI,
      inout              HPS_SPIM_SS,
      input              HPS_UART_RX,
      output             HPS_UART_TX,
      input              HPS_USB_CLKOUT,
      inout       [7:0]  HPS_USB_DATA,
      input              HPS_USB_DIR,
      input              HPS_USB_NXT,
      output             HPS_USB_STP,
`endif /*ENABLE_HPS*/

      ///////// IRDA /////////
      input              IRDA_RXD,
      output             IRDA_TXD,

      ///////// KEY /////////
      input       [3:0]  KEY,

      ///////// LEDR /////////
      output      [9:0]  LEDR,

      ///////// PS2 /////////
      inout              PS2_CLK,
      inout              PS2_CLK2,
      inout              PS2_DAT,
      inout              PS2_DAT2,

      ///////// SW /////////
      input       [9:0]  SW,

      ///////// TD /////////
      input              TD_CLK27,
      input      [7:0]   TD_DATA,
      input              TD_HS,
      output             TD_RESET_N,
      input              TD_VS,

`ifdef ENABLE_USB
      ///////// USB /////////
      input              USB_B2_CLK,
      inout       [7:0]  USB_B2_DATA,
      output             USB_EMPTY,
      output             USB_FULL,
      input              USB_OE_N,
      input              USB_RD_N,
      input              USB_RESET_N,
      inout              USB_SCL,
      inout              USB_SDA,
      input              USB_WR_N,
`endif /*ENABLE_USB*/

      ///////// VGA /////////
      output      [7:0]  VGA_B,
      output             VGA_BLANK_N,
      output             VGA_CLK,
      output      [7:0]  VGA_G,
      output             VGA_HS,
      output      [7:0]  VGA_R,
      output             VGA_SYNC_N,
      output             VGA_VS,

	//////////// GPIO_0_1, GPIO_0_1 connect to ADA - High Speed ADC/DAC //////////
	output		          		ADC_CLK_A,
	output		          		ADC_CLK_B,
	input 		    [13:0]		ADC_DA,
	input 		    [13:0]		ADC_DB,
	output		          		ADC_OEB_A,
	output		          		ADC_OEB_B,
	input 		          		ADC_OTR_A,
	input 		          		ADC_OTR_B,
	output		          		DAC_CLK_A,
	output		          		DAC_CLK_B,
	output	reg	  signed  [13:0]		DAC_DA,
	output	reg   signed  [13:0]		DAC_DB,
	output		          		DAC_MODE,
	output		          		DAC_WRT_A,
	output		          		DAC_WRT_B,
	input 		          		OSC_SMA_ADC4,
	output		          		POWER_ON,
	input 		          		SMA_DAC4

);


//=======================================================
//  REG/WIRE declarations
//=======================================================
wire CLK_125;
wire CLK_65;
//=======================================================
//  REG/WIRE declarations
//=======================================================
assign  DAC_WRT_B = ~CLK_125;      //Input write signal for PORT B
assign  DAC_WRT_A = ~CLK_125;      //Input write signal for PORT A

assign  DAC_MODE = 1; 		       //Mode Select. 1 = dual port, 0 = interleaved.

assign  DAC_CLK_B = ~CLK_125; 	    //PLL Clock to DAC_B
assign  DAC_CLK_A = ~CLK_125; 	    //PLL Clock to DAC_A
 
assign  ADC_CLK_B = ~CLK_65;  	    //PLL Clock to ADC_B
assign  ADC_CLK_A = ~CLK_65;  	    //PLL Clock to ADC_A


assign  ADC_OEB_A = 0; 		  	    //ADC_OEA
assign  ADC_OEB_B = 0; 			    //ADC_OEB

/////////////////////////////////////


wire    [13:0]	sin_out;

wire    [13:0]	cos_out;

wire    [31:0]	fase;
wire    [31:0]	modulo, moduloA, moduloB;
wire    [7:0]  direccion, direccion1,direccion2;
wire    [3:0] address_mem;
wire    wren;



reg KEY2_reg, KEY2_reg2, KEY1_reg, KEY1_reg2 ;
reg tipo_ajuste_reg, tipo_ajuste_reg2;


assign  POWER_ON  = 1;            //Disable OSC_SMA


reg	signed	 [13:0]		r_DAC_DA,r_DAC_DB/*synthesis noprune*/;


//always @ (posedge CLK_65) r_ADC_DB <= 2*temp2[18:6]-13'd4096;








//sincronizadores

always @(posedge CLK_125 )
	begin
         KEY2_reg<=KEY[2];
         KEY2_reg2<=KEY2_reg;
         KEY1_reg<=KEY[1];
         KEY1_reg2<=KEY1_reg;
         tipo_ajuste_reg<=SW[0];
         tipo_ajuste_reg2<=tipo_ajuste_reg;
			
	
	end








always @ (posedge CLK_125) r_DAC_DA <= {sin_out[13],sin_out[12:0]};
always @ (posedge CLK_125) r_DAC_DB <= {cos_out[13],cos_out[12:0]};






//voy a ver si puedo recuperar un bit
always @ (posedge CLK_125) DAC_DA <= {~sin_out[13],sin_out[12:0]};
always @ (posedge CLK_125) DAC_DB <=  {~cos_out[13],cos_out[12:0]};

//assign DAC_DB=r_DAC_DA;




CLK125mhZ uRELOJ (
		.refclk(CLOCK_50),   //  refclk.clk
		.rst(~KEY[0]),      //   reset.reset
		.outclk_0(CLK_125), // outclk0.clk
		.outclk_1(CLK_65)
		);

	
logic signed [31:0] rom_incremento_grueso [16];

    assign rom_incremento_grueso[0]  = 32'h00008638;
    assign rom_incremento_grueso[1]  = 32'h0000C898;
    assign rom_incremento_grueso[2]  = 32'h00012B1C;
    assign rom_incremento_grueso[3]  = 32'h0001C108;
    assign rom_incremento_grueso[4]  = 32'h0002A0CA;
    assign rom_incremento_grueso[5]  = 32'h0003EE29;
    assign rom_incremento_grueso[6]  = 32'h0005E2FC;
    assign rom_incremento_grueso[7]  = 32'h0008CBD8;
    assign rom_incremento_grueso[8]  = 32'h000D2F78;
    assign rom_incremento_grueso[9]  = 32'h0013B4F0;
    assign rom_incremento_grueso[10] = 32'h001D86A1;
    assign rom_incremento_grueso[11] = 32'h002C2C77;
    assign rom_incremento_grueso[12] = 32'h00422D19;
    assign rom_incremento_grueso[13] = 32'h0062B7BE;
    assign rom_incremento_grueso[14] = 32'h00950A8B;
    assign rom_incremento_grueso[15] = 32'h020A1F1A;


dds_button_controlled #(.INC_WIDTH(32), .OUTPUT_WIDTH(14)) U2 (
	.i_clk(CLK_125), // 125MHz
	.i_rst_n(KEY[0]),
    .i_enable(1'b1),
    .i_start(~KEY[3]),
	.i_aumentar(KEY1_reg2),
	.i_disminuir(KEY2_reg2),
	.i_tipo_ajuste(tipo_ajuste_reg2),
    .i_rom_incremento_grueso(rom_incremento_grueso),
	 
	.o_leds_fino(LEDR[6:4]),
	.o_leds_grueso(LEDR[9:7]),

    .o_incremento(),
    .o_DAC_Sin(sin_out),
    .o_DAC_Cos(cos_out)
);


endmodule
