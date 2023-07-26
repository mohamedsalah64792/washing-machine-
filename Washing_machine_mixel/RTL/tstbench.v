`timescale 1ns/100ps
module tstbench();

// Testbench Signals
    reg clk_tb;
    reg [1:0] clk_freq_tb;
    reg rst_n_tb;
    reg coin_in_tb;
    reg double_wash_tb;
    reg timer_pause_tb;
    wire wash_done_tb;
    
  
// Testbench Parameters 
  localparam CLK_Period = 1000;
  
// Clock Generation
  always #(CLK_Period*0.5) clk_tb = ~clk_tb;
  
// Module Instentiation
  mixel DUT (
    .clk(clk_tb),
    .clk_freq(clk_freq_tb),
    .rst_n(rst_n_tb),
    .coin_in(coin_in_tb),
    .double_wash(double_wash_tb),
    .timer_pause(timer_pause_tb),
    .wash_done(wash_done_tb)
  );
  //$dumpfile("mixel.vcd");
    //$dumpvars ;
// Initial Block
  initial
    begin
    
// Initialization
    Initialize();
// Reset the Design 
    Reset();
// Write Data
    generate_coin();
// Check Output
    do_read_check(1'b1 , 1, 0);
    #(5*CLK_Period)
    //Reset();
    generate_coin();
    do_read_check(1'b1 , 1, 1);
    #(5*CLK_Period) 
    double_wash_tb = 1'b1;
    //Reset();
    generate_coin(); 
    do_read_check(1'b1 , 0, 0);
    #(5*CLK_Period)
    //Reset();
    generate_coin();
    do_read_check(1'b1 , 0, 1);       	   
  //#(CLK_Period * 100)*/
  $stop;
    end
    
/////////////////////////////////////////////////////////////////////////
//                               Tasks                                 //
/////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////
// Task : Initialization                                               //
/////////////////////////////////////////////////////////////////////////
task Initialize ();
  begin
    rst_n_tb = 1'b1;
    clk_tb  = 1'b0;
    clk_freq_tb = 2'b00;
    coin_in_tb = 1'b0;
    double_wash_tb = 1'b0;
    timer_pause_tb = 1'b0;
  end
endtask

/////////////////////////////////////////////////////////////////////////
// Task : Reset                                                        //
/////////////////////////////////////////////////////////////////////////
task Reset ();
  begin
    rst_n_tb = 1'b1;
    #(CLK_Period*0.2)
    rst_n_tb = 1'b0;
    #(CLK_Period*0.8)
    rst_n_tb = 1'b1;
  end
endtask

task generate_coin();
begin
    coin_in_tb = 1'b1;
    #(CLK_Period)
    coin_in_tb = 1'b0;
end
endtask
//64'd 600000000000
//64'd 580000000000
//64'd 20000000000
//*64'd 1020000000000
//64'd 1000000000000
//20000000000
/////////////////////////////////////////////////////////////////////////
// Task : do_read_check                                                //
/////////////////////////////////////////////////////////////////////////
task do_read_check (
  input expected_OUT ,input integer single_double , input  integer time_pause
  );
  begin
  if(single_double == 1)
  	begin 	
  		if(time_pause == 0) 
   			begin
   			#(64'd 600000000000)
    			if(wash_done_tb == expected_OUT)
      			$display("READ Operation IS Passed");
    			else
      			$display("READ Operation IS Failed");
    			end

   		else
   			begin
     			#(64'd 580000000000)
     			timer_pause_tb = 1'b1;
     			#(64'd 20000000000)
			if(wash_done_tb == expected_OUT)
      			$display("READ Operation IS passed");
      			else
      			$display("READ Operation IS failed");
      			timer_pause_tb = 1'b0;
      			#(64'd 20000000000)
      			if(wash_done_tb == expected_OUT)
       			$display("READ Operation IS Passed");
       			else
      			$display("READ Operation IS Failed");
    			end
         end
  else
         begin
   		if(time_pause == 0) 
   			begin
   			#(64'd 1020000000000)
    			if(wash_done_tb == expected_OUT)
    			$display("READ Operation IS Passed");
    			else
    			$display("READ Operation IS Failed");
    			end

   		else
   			begin
     			#(64'd 1000000000000)
     			timer_pause_tb = 1'b1;
     			#(64'd 20000000000)
			if(wash_done_tb == expected_OUT)
      			$display("READ Operation IS passed");
      			else
      			$display("READ Operation IS failed");
      			timer_pause_tb = 1'b0;
      			#(64'd 20000000000)
      			if(wash_done_tb == expected_OUT)
       			$display("READ Operation IS Passed");
       			else
      			$display("READ Operation IS Failed");
   			end    
    
	  end
end
endtask
/////////////////////////////////////////////////////////////////////////

endmodule 
