
//  Finite State-machines
//
//  There are several methods to code state-machines however following certain
// coding styles ensures the synthesis tool FSM (Finite State-Machine)
// extraction algorithms properly identify and optimize the state-machine as
// well as possibly improving the simulation, timing and debug of the circuit.
// The following examples are broken down into Mealy vs. Moore, One-hot vs.
// Binary and Safe vs. Fast implementations.  The basic trade-offs for each
// implementation is explained below.  The general recommendation for the
// choice of state-machine depends on the target architecture and specifics of
// the state-machine size and behavior.
//
//  Mealy vs. Moore Styles
//
//  There are two well-known implementation styles for state-machines, Mealy
// and Moore.  The main difference between Mealy and Moore styles is the Mealy
// state-machine determines the output values based on both the current state
// as well as the inputs to the state-machine where Moore determines its
// outputs solely on the state.  In general, Moore type of state-machines
// implement best in FPGAs due to the fact that most often one-hot
// state-machines is the chosen encoding method and there is little or no
// decode and thus logic necessary for output values.  If a binary encoding is
// used, it is possible that a more compact and sometimes faster state-machine
// can be built using the Mealy method however this is not always true and not
// easy to determine without knowing more specifics of the state-machine.
//
//  One-hot vs. Binary Encoding
//
//  There are several encoding methods for state-machine design however the two
// most popular for FPGA design are binary and one-hot.  Most modern synthesis tools
// contain FSM extraction algorithms that can identify state-machine code and choose
// the best encoding method for the size, type and target architecture.  Even though
// this facility exists, many times it can be most advantageous to manually code
// and control the best encoding scheme for the design to allow better control
// and possibly ease debug of the implemented design.  It is suggested to
// consult the synthesis tool documentation for details about the state-machine
// extraction capabilities of the synthesis tool you are using.
//
//  Safe vs. Fast
//
//  When coding a state-machine, there are two generally conflicting goals that
// must be understood, safe vs. fast.  A safe state-machine implementation
// refers to the case where if a state-machine should get an unknown input or
// into an unknown state that it can recover into a known state the next clock
// cycle and resume from that recovery state.  On the other hand, if this
// requirement is discarded (no recovery state) many times the state-machine
// can be implemented with less logic and more speed than if state-machine
// recovery is necessary.  How to design a safe state-machine generally
// involves coding in a default state into the state-machine next-state case
// clause and/or specifying to the synthesis tool to implement the
// state-machine encoding in a "safe" mode.  If a safe state-machine is desired
// many times binary encoding works best due to the fact there are generally fewer
// unassigned states with that encoding method.  Again it is suggested to consult
// the synthesis tool documentation for details about implementing a safe
// state-machine.
//
// SystemVerilog Enumerated Type
//
// SystemVerilog adds a new data type enum, short for enumerated, which in many cases
// is beneficial for state-machine creation. Enum allows for named stated without
// implicit mapping to a register encoding.  The benefit this provides to synthesis is
// flexibility in state-machine encoding techniques and for simulation, the ability to
// display and query specific states by name to improve overall debugging. For these
// reasons, it is encouraged to use enum types when SystemVerilog is available.
				

// Mealy

   parameter <state1> = 2'b00;
   parameter <state2> = 2'b01;
   parameter <state3> = 2'b10;
   parameter <state4> = 2'b11;

   reg [1:0] <state> = <state1>;

   always @(posedge <clock>)
      if (<reset>)
         <state> <= <state1>;
      else
         case (state)
            <state1> : begin
               if (<condition>)
                  <state> <= <next_state>;
               else if (<condition>)
                  <state> <= <next_state>;
               else
                  <state> <= <next_state>;
            end
            <state2> : begin
               if (<condition>)
                  <state> <= <next_state>;
               else if (<condition>)
                  <state> <= <next_state>;
               else
                  <state> <= <next_state>;
            end
            <state3> : begin
               if (<condition>)
                  <state> <= <next_state>;
               else if (<condition>)
                  <state> <= <next_state>;
               else
                  <state> <= <next_state>;
            end
            <state4> : begin
               if (<condition>)
                  <state> <= <next_state>;
               else if (<condition>)
                  <state> <= <next_state>;
               else
                  <state> <= <next_state>;
            end
            default : begin  // Fault Recovery
               <state> <= <state1>;
            end
         endcase

   assign <output1> = <logic_equation_based_on_states_and_inputs>;
   assign <output2> = <logic_equation_based_on_states_and_inputs>;
   // Add other output equations as necessary
							
// Moore

   parameter <state1> = 2'b00;
   parameter <state2> = 2'b01;
   parameter <state3> = 2'b10;
   parameter <state4> = 2'b11;

   reg [1:0] <state> = <state1>;

   always @(posedge <clock>)
      if (<reset>) begin
         <state> <= <state1>;
         <outputs> <= <initial_values>;
      end
      else
         case (state)
            <state1> : begin
               if (<condition>)
                  <state> <= <next_state>;
               else if (<condition>)
                  <state> <= <next_state>;
               else
                  <state> <= <next_state>;
               <outputs> <= <values>;
            end
            <state2> : begin
               if (<condition>)
                  <state> <= <next_state>;
               else if (<condition>)
                  <state> <= <next_state>;
               else
                  <state> <= <next_state>;
               <outputs> <= <values>;
            end
            <state3> : begin
               if (<condition>)
                  <state> <= <next_state>;
               else if (<condition>)
                  <state> <= <next_state>;
               else
                  <state> <= <next_state>;
               <outputs> <= <values>;
            end
            <state4> : begin
               if (<condition>)
                  <state> <= <next_state>;
               else if (<condition>)
                  <state> <= <next_state>;
               else
                  <state> <= <next_state>;
               <outputs> <= <values>;
            end
            default : begin  // Fault Recovery
               <state> <= <state1>;
               <outputs> <= <values>;
            end
         endcase
							
														