module dds_button_controlled #(
	parameter INC_WIDTH = 32,
	parameter OUTPUT_WIDTH = 14
) (
	input i_clk, // 125MHz
	input i_rst_n,
    input i_enable,
    input i_start,
	input i_aumentar,
	input i_disminuir,
	input i_tipo_ajuste, // 0: ajuste grueso, 1: ajuste fino

	input signed [INC_WIDTH-1:0] i_rom_incremento_grueso [16], // 16 elementos de 32 bits
	 
	output [2:0] o_leds_fino,
	output [2:0] o_leds_grueso,
	 	 
    output [INC_WIDTH-1:0] o_incremento,
    output signed [OUTPUT_WIDTH-1:0] o_DAC_Sin,
    output signed [OUTPUT_WIDTH-1:0] o_DAC_Cos
);

    localparam FREC_DEFAULT = 32'h00760A84;
    
    logic [3:0] COUNT;
    // logic signed [31:0] od_rom;

    logic zero_crossing;

    logic signed [OUTPUT_WIDTH-1:0] DAC_A_sin;
    logic signed [OUTPUT_WIDTH-1:0] DAC_A_cos;

    logic [INC_WIDTH-1:0] incremento_fino = FREC_DEFAULT; //Valor inicial 125MHz
    logic [INC_WIDTH-1:0] incremento_grueso;


    /**************************************************
    * MAQUINA DE ESTADOS AJUSTE FINO
    **************************************************/

    // Posibles estados FSM ajuste fino
    enum logic [2:0]{
        IDLE            = 3'b000,
        ESPERA_SUBIR    = 3'b001,
        SUBIR           = 3'b010,
        ESPERA_BAJAR    = 3'b011,
        BAJAR           = 3'b100,
        REPOSO          = 3'b101,
        CARGAR          = 3'b110
    } state_fino;
  
    assign o_leds_fino = state_fino;

    // Actualización de estado FSM ajuste fino
    always_ff@(posedge i_clk) begin
        if(!i_rst_n)begin
            state_fino <= IDLE;
        end else begin
            case(state_fino)
                IDLE:begin
                    if (i_tipo_ajuste == 1'b0)
                        state_fino <= CARGAR;
                    else begin
                        if (i_aumentar ^ i_disminuir) begin
                            if (i_aumentar)
                                state_fino <= ESPERA_BAJAR;
                            else
                                state_fino <= ESPERA_SUBIR;
                        end else begin 
                            state_fino <= IDLE;
                        end
                    end
                end

                ESPERA_SUBIR:begin
                    if (zero_crossing) begin
                        state_fino <= SUBIR;
                    end else begin
                        state_fino <= ESPERA_SUBIR;
                    end
                end

                SUBIR:begin
                    state_fino <= REPOSO;
                end

                ESPERA_BAJAR:begin
                    if (zero_crossing) begin
                        state_fino <= BAJAR;
                    end else begin
                        state_fino <= ESPERA_BAJAR;
                    end
                end

                BAJAR:begin
                    state_fino <= REPOSO;
                end

                REPOSO:begin
                    if (i_aumentar == 1'b1 && i_disminuir == 1'b1)
                        state_fino <= IDLE;
                    else
                        state_fino <= REPOSO;   
                end

                CARGAR:begin
                    if (i_tipo_ajuste == 1'b1) begin
                        state_fino <= IDLE;
                    end else begin
                        state_fino <= CARGAR;
                    end
                end
                default: state_fino <= IDLE;
            endcase
        end
    end 

    // Actualizamos incremento_fino en función del estado
    always_ff@(posedge i_clk) begin
        if(!i_rst_n)
            incremento_fino <= FREC_DEFAULT;
        else
            if(state_fino == CARGAR)
                incremento_fino <= incremento_grueso;	
            else if (state_fino == SUBIR)
                incremento_fino <= incremento_fino + 32'h00008638;
            else if (state_fino == BAJAR)
                incremento_fino <= incremento_fino - 32'h00008638; 
    end


    /**************************************************
    * MAQUINA DE ESTADOS AJUSTE GRUESO
    **************************************************/

    // Posibles estados FSM ajuste grueso
    enum logic [2:0] {
        IDLE_G          = 3'b000,
        ESPERA_SUBIR_G  = 3'b001,
        SUBIR_G         = 3'b010,
        ESPERA_BAJAR_G  = 3'b011,
        BAJAR_G         = 3'b100,
        REPOSO_G        = 3'b101
    } state_grueso;
  
    assign o_leds_grueso = state_grueso;

    // Actualización de estado FSM ajuste grueso
    always_ff @(posedge i_clk) begin
        if (!i_rst_n) begin
            state_grueso <= IDLE_G;
        end else begin
            case(state_grueso)
                IDLE_G:begin
                    if (i_aumentar ^ i_disminuir) begin
                        if (i_aumentar) begin
                            if(COUNT == 0) state_grueso <= REPOSO_G;
                            else state_grueso <= ESPERA_BAJAR_G;
                        end else begin
                            if(COUNT == 15) state_grueso <= REPOSO_G;
                            else state_grueso <= ESPERA_SUBIR_G;
                        end
                    end else state_grueso <= IDLE_G;
                end

                ESPERA_SUBIR_G:begin
                    if (zero_crossing) begin
                        state_grueso <= SUBIR_G;
                    end else begin
                        state_grueso <= ESPERA_SUBIR_G;
                    end
                end

                SUBIR_G:begin
                    state_grueso <= REPOSO_G;
                end

                ESPERA_BAJAR_G:begin
                    if (zero_crossing) begin
                        state_grueso <= BAJAR_G;
                    end else begin
                        state_grueso <= ESPERA_BAJAR_G;
                    end
                end

                BAJAR_G:begin
                    state_grueso <= REPOSO_G;
                end
                
                REPOSO_G:begin
                    if (i_aumentar == 1'b1 && i_disminuir == 1'b1)
                        state_grueso <= IDLE_G;
                    else
                        state_grueso <= REPOSO_G;   
                end
                default: state_grueso <= IDLE_G;
            endcase
        end
    end

    // Actualizamos la variable que usamos para indexar la ROM de incremento grueso
    always_ff@(posedge i_clk) begin
        if(!i_rst_n) begin
            // incremento_grueso <= 32'h00008638;
            COUNT <= 10; 
        end else begin
            if(state_grueso == SUBIR_G)
                COUNT <= COUNT + 1'b1;
            else if(state_grueso == BAJAR_G)
                COUNT <= COUNT - 1'b1;
        end
            
        // od_rom <= i_rom_incremento_grueso[COUNT];
        // incremento_grueso <= od_rom;
    end
        
    assign incremento_grueso = i_rom_incremento_grueso[COUNT];

    // Elegimos el incremento en funcion del tipo de ajuste
    assign o_incremento = i_tipo_ajuste ? incremento_fino : incremento_grueso;  

    dds_test_1 #(.M(32), .L(15), .W(14)) DDS(
        .id_p_ac(o_incremento),
        .ic_rst_ac(i_start | !i_rst_n),
        .ic_en_ac(i_enable),
        .ic_val_data(1'b1),
        .clk(i_clk),
        .od_cos_wave(DAC_A_cos),
        .od_sin_wave(DAC_A_sin),
        .zero_crossing(zero_crossing),
        .oc_val_data()
    );

    assign o_DAC_Sin = DAC_A_sin;
    assign o_DAC_Cos = DAC_A_cos;
    
endmodule