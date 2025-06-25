`timescale 1ps/1ps
import dds_test_tsb_pkg::*; // PACKAGE WITH PARAMETERS TO CONFIGURE THE TB

module dds_button_controlled_tsb();

parameter PER=10; // CLOCK PERIOD

logic clk;
logic rst_n;
logic aumentar;
logic disminuir;
logic tipo_ajuste;
logic [2:0] leds_fino;
logic [2:0] leds_grueso;
logic [31:0] incremento;
logic signed [13:0] DAC_Sin, DAC_Cos, sin_wave_M, cos_wave_M;

logic signed [31:0] rom_incremento_grueso [16];

// Contadores y control
integer in_sample_cnt; // Contador de muestras de entrada
integer error_cnt; // Contador de errores
integer sample_cnt; // Contador de muestras comprobadas a la salida
logic end_sim; // Indicación de simulación on/off
logic load_data;  // Inicio de lectura de datos
logic val_out;

// Gestion I/O texto
integer conf_in_file;
integer scan_data_conf;
integer data_out_file;
integer scan_data_out;
logic signed [13:0] dout_waves;

// Reloj
always #(PER/2) clk = !clk&end_sim;
 
// UUT
dds_button_controlled #(.INC_WIDTH(32), .OUTPUT_WIDTH(14)) dds_btns (
	.i_clk(clk), // 125MHz
	.i_rst_n(rst_n),
    .i_enable(1'b1),
	.i_aumentar(aumentar),
	.i_disminuir(disminuir),
	.i_tipo_ajuste(tipo_ajuste),
    .i_rom_incremento_grueso(rom_incremento_grueso),
	 
	.o_leds_fino(leds_fino),
	.o_leds_grueso(leds_grueso),

    .o_incremento(incremento),
    .o_DAC_Sin(DAC_Sin),
    .o_DAC_Cos(DAC_Cos)
);

initial	begin
    rom_incremento_grueso[0]  = 32'h00008638;
    rom_incremento_grueso[1]  = 32'h0000C898;
    rom_incremento_grueso[2]  = 32'h00012B1C;
    rom_incremento_grueso[3]  = 32'h0001C108;
    rom_incremento_grueso[4]  = 32'h0002A0CA;
    rom_incremento_grueso[5]  = 32'h0003EE29;
    rom_incremento_grueso[6]  = 32'h0005E2FC;
    rom_incremento_grueso[7]  = 32'h0008CBD8;
    rom_incremento_grueso[8]  = 32'h000D2F78;
    rom_incremento_grueso[9]  = 32'h0013B4F0;
    rom_incremento_grueso[10] = 32'h001D86A1;
    rom_incremento_grueso[11] = 32'h002C2C77;
    rom_incremento_grueso[12] = 32'h00422D19;
    rom_incremento_grueso[13] = 32'h0062B7BE;
    rom_incremento_grueso[14] = 32'h00950A8B;
    rom_incremento_grueso[15] = 32'h020A1F1A;

    $display("########################################### ");
    $display("START TEST # ","%d", test_case);
    $display("########################################### ");
    end_sim = 1'b1;
    in_sample_cnt = 0;
    sample_cnt = 0;
    error_cnt = 0;
    clk = 1'b1;
    rst_n = 1'b0;
    load_data = 1'b0;
    #(10*PER);
    load_data = 1'b1;
end


// Proceso de lectura de datos de entrada
always@(posedge clk)
    if (load_data) begin
        rst_n = 1'b1;		
        tipo_ajuste = 1'b0;
        aumentar = 1'b1;
        disminuir = 1'b0;
        #(1000*PER);
        aumentar = 1'b1;
        disminuir = 1'b1;
        #(1000*PER);
        aumentar = 1'b1;
        disminuir = 1'b0;
        #(1000*PER);
        aumentar = 1'b1;
        disminuir = 1'b1;
        #(1000*PER);
        aumentar = 1'b1;
        disminuir = 1'b0;
        #(1000*PER);
        aumentar = 1'b1;
        disminuir = 1'b1;
        #(1000*PER);
        aumentar = 1'b1;
        disminuir = 1'b0;
        #(1000*PER);
        aumentar = 1'b1;
        disminuir = 1'b1;
        #(1000*PER);
        aumentar = 1'b0;
        disminuir = 1'b1;
        #(1000*PER);
        aumentar = 1'b1;
        disminuir = 1'b1;
        #(1000*PER);
        aumentar = 1'b0;
        disminuir = 1'b1;
        #(250*PER);
        tipo_ajuste = 1'b1;
        #(1000*PER);
        aumentar = 1'b1;
        disminuir = 1'b1;
        #(1000*PER);
        aumentar = 1'b0;
        disminuir = 1'b1;

        end_sim = #(10000*PER) 1'b0; // Hay que dejar un numero de peridodos 
                                    // mayor que la latencia del UUT
        $display(" Number of input samples ","%d", in_sample_cnt);
        
        //end
				
    end
		
// Proceso de lectura de salida 
always@(posedge clk)
    if (val_out) begin
        sample_cnt = sample_cnt +1;	
        sin_wave_M <= #(PER/10) DAC_Sin; //Salida del modulo UUT
        cos_wave_M <= #(PER/10) DAC_Cos; //Salida del modulo UUT											
    end


// Fin de simulación
always@(end_sim)
	if (!end_sim) begin
        $display("########################################### ");
        $display("TEST # %d", test_case);
        $display("########################################### ");	
        $display("Number of input samples # %d", in_sample_cnt);
        $display("########################################### ");							
        $display("########################################### ");
        $display("Number of checked samples ","%d", sample_cnt);	
        $display("Number of errors ","%d", error_cnt);
        $display("########################################### ");
		#(PER*2) $stop;
    end

endmodule 