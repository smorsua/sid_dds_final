// Registros que contiene esta interfaz
//   ADDRESS   |       NAME        |   SIZE (bits)
//    0..15       coarse_step_rom        32 each
//     16         enable                    1
//     17         tipo_ajuste               1
//     18         start                     1

module dds_avalon_slave_mm_interface_arm (
    input  logic        clock,
    input  logic        reset,
    input  logic        chipselect,
    input  logic        write,
    input  logic        read,
    input  logic [4:0]  address,
    input  logic [31:0] writedata,
    output logic [31:0] readdata,

    // Salidas hacia el DDS
    output logic [31:0] o_coarse_step_rom [16],
    output logic        o_enable,
    output logic        o_tipo_ajuste,
    output logic        o_start,
    output logic        o_aumentar,
    output logic        o_disminuir
);

    // Registros internos
    logic reg_enable;
    logic reg_tipo_ajuste;
    logic reg_start;
    logic reg_aumentar;
    logic reg_disminuir;

    // RAM para 16 registros de 32 bits
    logic [31:0] rom_incremento_grueso [16];
    logic [3:0]  rom_addr;
    logic [31:0] rom_data_out;

    // Señales de control para la RAM
    logic rom_write_en;
    logic rom_read_en;

    // Decodificación de direcciones para la ROM
    assign rom_write_en = chipselect && write && (address >= 3'd0) && (address <= 3'd15);
    assign rom_addr     = address[3:0]; // Usa los 4 bits de address (ajusta si necesitas más)

    // Escritura en RAM
    always_ff @(posedge clock) begin
        if (rom_write_en)
            rom_incremento_grueso[rom_addr] <= writedata;
    end

    always_ff @(posedge clock or posedge reset) begin
        if (reset) begin
            reg_enable      <= 1'b0;
            reg_tipo_ajuste <= 1'b0;
            reg_start <= 1'b0;
        end else if (chipselect && write) begin            
            case (address)  
                5'd16: reg_enable      <= writedata[0];
                5'd17: reg_tipo_ajuste <= writedata[0];                
                5'd18: reg_start       <= writedata[0];                
                5'd19: reg_aumentar    <= writedata[0];                
                5'd20: reg_disminuir   <= writedata[0];                
            endcase
        end else begin
            if(reg_start == 1'b1) begin
                reg_start <= 1'b0;
            end

            if(reg_aumentar == 1'b1) begin
                reg_aumentar <= 1'b0;
            end

            if(reg_disminuir == 1'b1) begin
                reg_aumentar <= 1'b0;
            end
        end
    end

    always_comb begin
        if (chipselect && read) begin
            if(address >= 5'd0 && address <= 5'd15) begin
                readdata = rom_incremento_grueso[rom_addr];
            end else if(address == 5'd16) begin
                readdata = {31'd0, reg_enable};
            end else if(address == 5'd17) begin
                readdata = {31'd0, reg_tipo_ajuste};
            end else if (address == 5'd18) begin
                readdata = {31'd0, reg_start};
            end else if (address == 5'd19) begin
                readdata = {31'd0, reg_aumentar};
            end else if (address == 5'd20) begin
                readdata = {31'd0, reg_disminuir};
            end else begin
                readdata = 32'd0;
            end            
        end else begin
            readdata = 32'd0;
        end
    end

    // Salidas a DDS
    assign o_enable           = reg_enable;
    assign o_tipo_ajuste      = reg_tipo_ajuste;
    assign o_start            = reg_start;
    assign o_aumentar         = reg_aumentar;
    assign o_disminuir        = reg_disminuir;
    assign o_coarse_step_rom  = rom_incremento_grueso;

endmodule