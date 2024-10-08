
// information for Verilog Looping Statements (i.e. while, repeat, forever, for, etc.)
// ===================================================================================
//
// There are several ways to create a looping statement within a verilog
// testbench.  Each of these constructs must appear within an initial or
// always block and can be disabled if the block is labeled.
//
// Repeat - A repeat loop is generally the easiest construct if it is desired
//          to perform an action a known, finite number of times and the loop
//          variable is not needed for the function.
//
//          Example: The following example will apply random data to the
//                   DATA_IN signal 30 times at each clock signal.

initial begin
    repeat (30) begin
       @(posedge CLK);
       #1 DATA_IN = $random;
    end
 end
 
 // While - The while loop is a good way to create a conditional loop that will
 //         execute as long as a condition is met.
 //
 //         Example: The following example will read from a FIFO as long as the
 //                  EMPTY flag is true.
 
 initial begin
    while (EMPTY==1'b0) begin
       @(posedge CLK);
       #1 read_fifo = 1'b1;
    end
 
 // for - The for loop is generally used when a finite loop is desired and it
 //       is necessary to key off the loop variable.  Depending on how the for
 //       condition is created, an incrementing or decrementing loop can be created.
 //
 //       Example: The following will assign a 1'b0 to each bit in the 32 bit
 //                DATA signal at time zero. An incrementing for loop will be used.
 
 parameter WIDTH=32;
 reg [WIDTH-1:0] DATA;
 integer i;
 
 initial
    for (i=0; i<WIDTH; i=i+1)
       DATA[i] = 1'b0;
 
 // forever - The forever loop is a construct generally used to create an infinite
 //           loop for simulation.
 //
 //           Example: The following will create a clock using a forever loop with
 //                    a period of 10 ns and a 50% duty cycle.
 
 `timescale 1ns/1ps
 
 initial
    forever begin
       CLK = 1'b0;
       #5 CLK = 1'b1;
       #5;
    end
 
 // Disable - Any loop can be disabled by using the disable construct.  In order
 //           to disable a loop, a loop identifier or label must be used on the
 //           loop to be disabled.
 //
 //           Example: The following will stop a clock created in a forever loop
 //                    if a signal called stop_clock is 1'b1.
 
 `timescale 1ns/1ps
 
 initial
    forever begin : clock_10ns
       CLK = 1'b0;
       #5 CLK = 1'b1;
       #5;
    end
 
 always @(posedge stop_clock)
    if (stop_clock)
       disable clock_10ns;
             
             