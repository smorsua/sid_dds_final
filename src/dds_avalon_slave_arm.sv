module dds_avalon_slave_arm(
    // Senales Avalon-MM
    input         clock,
    input         reset,
    input         chipselect,
    input         write,
    input         read,
    input  [2:0]  address,
    input  [31:0] writedata,
    output [31:0] readdata,

    // Señales de salida del DDS
    output [13:0] o_DAC_Sin,
    output [13:0] o_DAC_Cos,

    // Estado de las FSMs de ajuste fino y grueso
    output [2:0] o_leds_fino,
    output [2:0] o_leds_grueso
);
    logic [31:0] rom_incremento_grueso [16];
    logic enable;
    logic tipo_ajuste;
    logic start;
    logic aumentar;
    logic disminuir;

    dds_avalon_slave_mm_interface_arm avalon_if (
        .clock(clock),
        .reset(reset),
        .chipselect(chipselect),
        .write(write),
        .read(read),
        .address(address),
        .writedata(writedata),
        .readdata(readdata),

        // Salidas hacia el DDS
        .o_rom_incremento_grueso(rom_incremento_grueso),
        .o_enable(enable),
        .o_tipo_ajuste(tipo_ajuste),
        .o_start(start),
        .o_aumentar(aumentar),
        .o_disminuir(disminuir)
    );
    
    logic [13:0] DAC_Sin, DAC_Cos;
    logic val_out;

    logic [2:0] leds_fino, leds_grueso;

    dds_button_controlled #(.INC_WIDTH(32), .OUTPUT_WIDTH(14)) dds_btns (
        .i_clk(clock), // 125MHz
        .i_rst_n(reset),
        .i_enable(enable),
        .i_tipo_ajuste(tipo_ajuste),
        .i_start(start),
        .i_aumentar(aumentar),
        .i_disminuir(disminuir),
        .i_rom_incremento_grueso(coarse_step_rom),
        
        .o_leds_fino(leds_fino),
        .o_leds_grueso(leds_grueso),
        .o_incremento(incremento),

        .o_DAC_Sin(DAC_Sin),
        .o_DAC_Cos(DAC_Cos)
    );

    assign o_DAC_Sin = DAC_Sin;
    assign o_DAC_Cos = DAC_Cos;

    assign o_leds_fino = leds_fino;
    assign o_leds_grueso = leds_grueso;

endmodule