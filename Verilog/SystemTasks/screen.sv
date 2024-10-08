
// information of $display, $monitor, $write, and $strobe System Functions
// =======================================================================
//
// $display will display a string to the standard output (screen/console)
// of the simulator.  Variables may be added to the string to indicate
// current time (as well as other system functions) and states of signals
// in the design.  After the string is displayed, a carriage return is
// issued.
//
// $monitor will display a string to the standard output whenever a change
// in value is detected for one of the variables being displayed.  After
// the string is displayed, a carriage return is issued.
//
// $write acts very similar to $display in that it can output a specified
// string to the standard out however it does not return a carriage return
// after performing this operation.
//
// $strobe is also similar to $display only waits for all simulation events
// in the queue to be executed before generating the message.
//
// When using these standard output commands, variables can be specified to
// the output in a variety of formats.  Also, special escape characters can
// be used to specify special characters or formatting.  These formats are
// listed below.
//
//    Variables
//    ---------
//    %b .... Binary Value
//    %h .... Hexadecimal Value
//    %d .... Decimal Value
//    %t .... Time
//    %s .... String
//    %c .... ASCII
//    %f .... Real Value
//    %e .... Exponential Value
//    %o .... Octal Value
//    %m .... Module Hierarchical Name
//    %v .... Strength
//
//    Escape Characters
//    -----------------
//    \t ........ Tab
//    \n ........ Newline
//    \\ ........ Backslash
//    %% ........ Percent
//    \" ........ Quote
//    \<octal> .. ASCII representation
//
// $display and $strobe are general used within a conditional statement
// (i.e. if (error) $display) specified from an initial or always construct
// while the $monitor is generally specified from an initial statement without
// any other qualification.  Display functions are for simulation purposes only
// and while very useful, should be used sparingly in order to increase the
// overall speed of simulation.  It is very useful to use these constructs to
// indicate problems in the simulation however every time an output is written
// to the screen, a penalty of a longer simulation runtime is seen.
//
// Example of $display:

   initial begin
    #100000;
    $display("Simulation Ended Normally at Time: %t", $realtime");
    $stop;
 end

// Example of $monitor:

 initial
    $monitor("time %t: out1=%d(decimal), out2=%h(hex), out3=%b(binary),
                       state=%s(string)", $realtime, out1, out2, out3, state);

// Example of $write:

 always @(posedge check)
    $write(".");

// Example of $strobe:

 always @(out1)
    if (out1 != correct_out1)
       $strobe("Error at time %t: out1 is %h and should be %h",
              $realtime, out1, correct_out1);

// Example of using a $monitor to display the state of a state-machine to the screen:

 reg[8*22:0] ascii_state;

 initial
   $monitor("Current State is: %s", ascii_state);

 always @(UUT.top.state_reg)
    case (UUT.top.state_reg)
       2'b00  : ascii_state = "Reset";
       2'b01  : ascii_state = "Send";
       2'b10  : ascii_state = "Poll";
       2'b11  : ascii_state = "Receive";
       default: ascii_state = "ERROR: Undefined State";
    endcase
              
              