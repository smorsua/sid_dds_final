// ============================================================================
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

module control_path_tb ;
	

reg CLK_125;
reg CLK_65;
reg		 [13:0]		r_ADC_DA/*synthesis noprune*/;
reg		 [13:0]		r_ADC_DB/*synthesis noprune*/;
reg		 [13:0]		r_DAC_DA/*synthesis noprune*/;



wire    [13:0]	sin_out;



always @ (posedge CLK_125) r_DAC_DA <= {sin_out[13],sin_out[13:1]};



	localparam DESFASE1=20, DESFASE2=30;

	
	logic [(DESFASE1 -1):0][13:0] auxA;
	logic [(DESFASE2 -1):0][13:0] auxB;
	logic  [13:0] LOOP_A_DESFASADO;
	logic  [13:0] LOOP_B_DESFASADO;	
	
	always_ff @(posedge CLK_125 or negedge KEY[0])
	if (!KEY[0])
			  auxA<={(DESFASE1){cero_magnitud}};
	else
			auxA<={r_DAC_DA,auxA[DESFASE1-1:1]};

	assign LOOP_A_DESFASADO=auxA[0];
	always_ff @(posedge CLK_125 or negedge KEY[0])
	if (!KEY[0])
			  auxB<={(DESFASE2){cero_magnitud}};
	else
			auxB<={r_DAC_DA,auxB[DESFASE2-1:1]};

	assign LOOP_B_DESFASADO=auxB[0];

	always @ (posedge CLK_65) r_ADC_DA <= LOOP_A_DESFASADO ;
	always @ (posedge CLK_65) r_ADC_DB <= LOOP_B_DESFASADO>>>2 ;


initial begin CLK_125 = 1'b0;

forever #(1e6/250)  CLK_125 = !CLK_125;

end
initial begin CLK_65 = 1'b0;

forever #(1e6/130)  CLK_65 = !CLK_65;

end




Control_path
#(.DATA_WIDTH(32), .ADDR_WIDTH(8), .MAGNITUD_WIDTH(14), .ancho_detector(10), .FICHERO_INICIAL("freq_log.dat"))
(.clk125(CLK_125),
.clk65(CLK_65),
.test(1'b0),
.areset_n(KEY[0]),
.start(~KEY[3]),
.ADC_A(r_ADC_DA),
.ADC_B(r_ADC_DA),
.fin(),
.fin2(),
.DAC_A(sin_out),
.MODULO(modulo),
.PHASE(fase)
);


endmodule
