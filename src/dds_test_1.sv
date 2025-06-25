module dds_test_1
#(parameter M=32, // DDS accumulator wordlength
  parameter L=15, // DDS phase truncation wordlength
  parameter W=14) // DDS ROM wordlength
(
input [M-1:0] id_p_ac,				// U[M,0]			
input ic_rst_ac, 
input ic_en_ac,
input ic_val_data,	
input clk,
output signed [W-1:0] od_cos_wave,	// S[W,W-1]
output signed [W-1:0] od_sin_wave,  // S[W,W-1]
output logic zero_crossing,  // señal que indica cruce por cero del seno
output oc_val_data
);

/* DECLARACIONES ------------------------- */

// Registros validación de datos
logic b0_oc_val_data_r; //U[1,0]
logic b1_oc_val_data_r; //U[1,0]
logic b2_oc_val_data_r; //U[1,0]
logic b3_oc_val_data_r; //U[1,0]

// acumulador
logic [M-1:0] b0_ac_r = 0; //U[M,0]

// preprocesado
logic [1:0] b1_log_r; //U[2,0]
logic [1:0] b1_log_cos_r; //U[2,0]
logic signed [L-1:0] b1_prep_s; //U[L,0] 
logic signed[L-3:0] b1_prepm2_r; //U[L-2,0] 
logic signed[L-3:0] b1_prepout_r; //U[L-2,0] 
logic signed[L-1:0] b1_prep_s_cos;
logic signed[L-3:0] b1_prepm2_cos_r;
logic signed[L-3:0] b1_prepout_cos_r;

// ROM
logic signed [W-1:0] b2_rom_r; //U[W,0]
logic signed [W-1:0] b2_sin_r; //U[W,0]
logic [1:0] b2_log_r; //U[2,0]
logic [1:0] b2_log_cos_r; //U[2,0]
// postprocesado
logic [1:0] b3_log_r; //U[2,0]
logic [1:0] b3_log_cos_r; //U[2,0]
logic signed [W-1:0] b3_posp_r; //S[W,0]
logic signed [W-1:0] b3_posp_r_prev; // Valor anterior de la señal seno
logic cero;


// cos wave
logic signed [W-1:0] b0_cos_r; //U[M,0]
logic signed [W-1:0] b1_cos_r; //U[M,0]
logic signed [W-1:0] b2_cos_r; //U[M,0]
logic signed [W-1:0] b3_cos_r; //U[M,0]


/* DESCRIPCION ------------------------- */		

// B0
always_ff@(posedge clk)begin
	if (ic_rst_ac) begin
		b0_ac_r <= 0;
  end
	else if (ic_en_ac) begin
		b0_ac_r <= b0_ac_r + id_p_ac;
	end
  b0_oc_val_data_r <= ic_val_data;
end	

// Asignaciones de la salida del acumulador
//SIN
assign b1_prep_s = b0_ac_r[M-1:M-L];
assign b1_prepm2_r = b1_prep_s[L-3:0];
assign b1_log_r = b1_prep_s[L-1:L-2];
//COS
assign b1_prep_s_cos =  b0_ac_r[M-1:M-L] - (1 << (L - 2));     
assign b1_log_cos_r = b1_prep_s_cos[L-1:L-2];
assign b1_prepm2_cos_r = b1_prep_s_cos[L-3:0]; /////aña

// B1
always_ff @(posedge clk) begin
    // Actualización de los registros
    b1_oc_val_data_r <= b0_oc_val_data_r;

    // PRE PROC
//SIN
    if(b1_log_r == 2'b00 || b1_log_r == 2'b10)begin
          b1_prepout_r <= b1_prepm2_r;end
    else if(b1_log_r == 2'b01 || b1_log_r == 2'b11)begin
          b1_prepout_r <= ~b1_prepm2_r;  end
//COS
    if(b1_log_cos_r == 2'b00 || b1_log_cos_r == 2'b10)begin
          b1_prepout_cos_r <= b1_prepm2_cos_r;end
    else if(b1_log_cos_r == 2'b01 || b1_log_cos_r == 2'b11)begin
          b1_prepout_cos_r <= ~b1_prepm2_cos_r; end
end

// B2
// Instanciación de la ROM
//SIN
dds_test_rom #(
  .ADDR_WIDTH(L-2),
  .DATA_WIDTH(W)
  ) ROM (
  .ic_addr(b1_prepout_r),
  .clk(clk),
  .od_rom(b2_rom_r)
);
//COS
dds_test_rom #(
  .ADDR_WIDTH(L-2),
  .DATA_WIDTH(W)
  ) ROM_COS (
  .ic_addr(b1_prepout_cos_r),
  .clk(clk),
  .od_rom(b1_cos_r)
);
// Actualización de los registros
always_ff @( posedge clk ) begin
  b2_oc_val_data_r <= b1_oc_val_data_r;
  b2_log_r <= b1_log_r;
  b2_log_cos_r <= b1_log_cos_r;
  b2_sin_r <= b2_rom_r;
  b2_cos_r <= b1_cos_r;
end

// B3
always_ff @(posedge clk) begin
    //Actualización de los registros
    b3_oc_val_data_r <= b2_oc_val_data_r;
    b3_log_r <= b2_log_r;
    b3_log_cos_r <= b2_log_cos_r;

    //POST PROC
//SIN
    if(b3_log_r == 2'b00 || b3_log_r == 2'b01)begin
      b3_posp_r <= b2_rom_r;end
    else if(b3_log_r == 2'b10 || b3_log_r == 2'b11)begin
      b3_posp_r <= -b2_rom_r;end

//COS
    if(b3_log_cos_r == 2'b00 || b3_log_cos_r == 2'b01)begin
      b3_cos_r <= b2_cos_r;end
    else if(b3_log_cos_r == 2'b10 || b3_log_cos_r == 2'b11)begin
      b3_cos_r <= -b2_cos_r;end

// Paso por cero: comparar signo actual con signo anterior
// Si los signos son diferentes y ambos valores no son cero
if ((b3_posp_r[W-1] != b3_posp_r_prev[W-1]) &&
    (b3_posp_r != 0) && (b3_posp_r_prev != 0)) begin
    cero <= 1'b1;
end else begin
    cero <= 1'b0;
end

// Actualizar valor anterior
b3_posp_r_prev <= b3_posp_r;      
end

/* ASIGNACION SALIDAS ------------------------- */
assign od_cos_wave = b3_cos_r;
assign od_sin_wave = b3_posp_r;
assign oc_val_data = b3_oc_val_data_r;
assign zero_crossing = cero;

endmodule 


/* MEMORIA ROM PARA dds_test */ 
module dds_test_rom
#(parameter ADDR_WIDTH=13, // Address wordlength
  parameter DATA_WIDTH=14) // ROM output wordlength
(
	input [ADDR_WIDTH-1:0] ic_addr,			// U[ADDR_WIDTH,0]
	input clk, 
	output signed [DATA_WIDTH-1:0] od_rom		// S[DATA_WIDTH,DATA_WIDTH-1]
);

/* DECLARACIONES ------------------------- */
reg signed [DATA_WIDTH-1:0] rom [0:2**ADDR_WIDTH-1];

logic [DATA_WIDTH-1:0] b0_rom_r;

/* DESCRIPCION ------------------------- */		

// ROM data
initial
			$readmemb("../src/rom_dds_L15_W14.txt", rom);

				
				
// Read synchronous ROM
always_ff@ (posedge clk) 
			b0_rom_r <= rom[ic_addr];


/* ASIGNACION SALIDAS ------------------------- */
assign od_rom = b0_rom_r;

endmodule
