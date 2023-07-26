module mixel (
    input wire clk,
    input wire [1:0] clk_freq,
    input wire rst_n,
    input wire coin_in,
    input wire double_wash,
    input wire timer_pause,
    output wire wash_done
);
wire start_Filling_wire,Filling_water_done_wire;
wire start_washing_wire,Washing_done_wire;
wire start_Rinsing_wire,Rinsing_done_wire;
wire start_spining_wire,spining_done_wire;
wire  spining_counter_stop_wire;
wire round2_Rinsing , round2_washing;
wire soft_rst1 , soft_rst2;
fsm fsm1 (
    .clk(clk),
    .rst_n(rst_n),
    .soft_rst1(soft_rst1),
    .soft_rst2(soft_rst2), 
    .coin_in(coin_in),
    .double_wash(double_wash),
    .timer_pause(timer_pause),
    .wash_done(wash_done),
    .start_Filling(start_Filling_wire), 
    .start_washing(start_washing_wire),
    .start_Rinsing(start_Rinsing_wire), 
    .start_spining(start_spining_wire),
    .Filling_water_done(Filling_water_done_wire),
    .Washing_done(Washing_done_wire),
    .spining_done(spining_done_wire),
    .Rinsing_done(Rinsing_done_wire),
    .spining_counter_stop(spining_counter_stop_wire),
    .round2_Rinsing(round2_Rinsing),
    .round2_washing(round2_washing)
);

Filling_water_counter c1 (
     .clk(clk),
     .rst_n(rst_n),
     .soft_rst(soft_rst2),
     .clk_freq(clk_freq),
     .start_Filling(start_Filling_wire),
     .Filling_water_done(Filling_water_done_wire)  
);
washing_counter c2 (
     .clk(clk),
     .rst_n(rst_n),
     .soft_rst(soft_rst1),
     .clk_freq(clk_freq),
     .start_washing(start_washing_wire),
     .Washing_done(Washing_done_wire),
     .round2_washing(round2_washing)
);
Rinsing_counter c3 (
     .clk(clk),
     .rst_n(rst_n),
     .soft_rst(soft_rst1),
     .clk_freq(clk_freq),
     .start_Rinsing(start_Rinsing_wire),
     .Rinsing_done(Rinsing_done_wire),
     .round2_Rinsing(round2_Rinsing)
);
spining_counter c4 (
     .clk(clk),
     .rst_n(rst_n),
     .soft_rst(soft_rst1),
     .clk_freq(clk_freq),
     .start_spining(start_spining_wire),
     .spining_done(spining_done_wire),
     .spining_counter_stop(spining_counter_stop_wire)
);
endmodule