module fsm (
    input wire Filling_water_done, Washing_done,spining_done,Rinsing_done,
    input wire clk,
    input wire rst_n,
    input wire coin_in,
    input wire double_wash,
    input wire timer_pause,
    output reg wash_done,
    output reg spining_counter_stop,
    output reg start_Filling , start_washing , start_Rinsing , start_spining,
    output reg round2_Rinsing , round2_washing,
    output reg soft_rst1 , soft_rst2
);

localparam [2:0] idle = 3'b000,
                 Filling_water = 3'b001,
                 Washing1 = 3'b010,
                 Rinsing1 = 3'b011,
                 Spining = 3'b100,
                 washing2 = 3'b101,
                 Rinsing2 = 3'b110;

reg [2:0] state_reg , state_next;


always @(posedge clk or negedge rst_n) 
begin
    if(~rst_n)
        state_reg <= idle;
    else 
        state_reg <= state_next;    
end

always @ *
begin
    soft_rst1 = 1'b1;
    soft_rst2 = 1'b1;
    round2_washing = 1'b0;
    round2_Rinsing = 1'b0;
    start_Filling = 1'b0;
    start_washing = 1'b0; 
    start_Rinsing = 1'b0; 
    start_spining = 1'b0;
    wash_done = 1'b0;
    spining_counter_stop = 1'b0;
    state_next = state_reg;
    case(state_reg)
        idle : 
            begin
                soft_rst1 = 1'b0;
                wash_done = 1'b1;
                if(coin_in)
                    begin
                        state_next = Filling_water;
                        start_Filling = 1'b1;
                    end    
            end

        Filling_water:
            begin
                start_Filling = 1'b1;
                if(Filling_water_done)
                    begin
                        state_next = Washing1;
                        start_washing = 1'b1;
                    end    
            end

        Washing1:
            begin
                         start_washing = 1'b1;
                        if(Washing_done)
                            begin
                                state_next = Rinsing1;
                                start_Rinsing = 1'b1;
                            end 
                     
            end

        Rinsing1:
            begin
                start_Rinsing = 1'b1;
                if(Rinsing_done)
                    begin
                        if(double_wash )
                            begin
                                state_next = washing2;
                                start_washing = 1'b1;
                                round2_washing = 1'b1;
                            end
                        else
                            begin
                                state_next = Spining;
                                start_spining = 1'b1;
                            end    
                    end
            end
        washing2:
            begin
                start_washing = 1'b1;
                        if(Washing_done)
                            begin
                                state_next = Rinsing2;
                                start_Rinsing = 1'b1;
                                round2_Rinsing = 1'b1;
                            end 
            end 
        Rinsing2:
            begin
                start_Rinsing = 1'b1;
                if(Rinsing_done)
                    begin
                            state_next = Spining;
                            start_spining = 1'b1;
                    end    
            end       
        Spining:
            begin
                start_spining = 1'b1;
                if(timer_pause)
                    spining_counter_stop = 1'b1;
                else if (spining_done)
                    begin
                        state_next = idle;
                        wash_done = 1'b1;
                        soft_rst2 = 1'b0;
                    end
            end
    endcase
end
endmodule

