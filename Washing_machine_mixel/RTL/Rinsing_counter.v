module Rinsing_counter(
    input wire clk,
    input wire rst_n,
    input wire soft_rst,
    input wire start_Rinsing,
    input wire [1:0] clk_freq,
    input wire round2_Rinsing,
    output wire Rinsing_done
);
reg [31:0] stop_count;
localparam [31:0] temp = 2'b11;
always @ *
begin
    case(clk_freq)
        2'b00: stop_count ='h7270E00; 
        2'b01: stop_count = 'hE4E1C00;
        2'b10: stop_count = 'h1C9C3800;
        2'b11: stop_count = 'h39387000;
    endcase
end    
reg [31:0] q;
always @(posedge clk or negedge rst_n) 
begin
    if(~rst_n)
        q <= 0;
    else if (~soft_rst)
        q <= 0;  
    else if (start_Rinsing && ~Rinsing_done)
        q <= q + 1;
    else if (round2_Rinsing)
        q<= 1;            
end
assign Rinsing_done = (q == stop_count);
endmodule