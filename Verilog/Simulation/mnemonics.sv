
// Mnemonics
//
// Most simulators have the ability to display ASCII text in the waveform and
// other debug windows as a means to allow for easier visual reference and
// understanding of a circuit operation.  A useful debugging methodology is to
// assign text values to certain circuit values from within the testbench so
// that when added to the waveform and displayed as ASCII, would give more
// useful information about that current state of the circuit.  Such methods are
// particularly useful in state-machine designs where each state value could be
// represented as a more easily identified text string.  Other examples could
// include mapping OPMODEs, detecting certain data (i.e. packet starts, training
// sequences, etc.) or mapping address values/ranges.  Below is an example of
// defining a mnemonic in a testbench to decode a simple state-machine states to
// something more intelligible.
//

// A reg must be declared with enough bits (8 times number of characters)
//  to store the desired string.  Add this vector to the waveform and set the
//  radix to ASCII

reg [(8*12)-1:0] state_string = "??UNKNOWN??";

// There is a 4-bit register called "state" in the uart_inst sub-instance in
//  the design file.  This always statement looks at it to generate the
//  mnemonics for the state-machine to the desired state_string reg.

always @(uut.uart_inst.state)
  case (uut.uart_inst.state)
    4'b0001: begin
      $display("%t: STATE is now: START", $realtime);
      state_string = "START";
    end
    4'b0010: begin
      $display("%t: STATE is now: FIRST_MATCH", $realtime);
      state_string = "FIRST_MATCH";
    end
    4'b0100: begin
      $display("%t: STATE is now: SECOND_MATCH", $realtime);
      state_string = "SECOND_MATCH";
    end
    4'b1000: begin
      $display("%t: STATE is now: SUCCESS", $realtime);
      state_string = "SUCCESS";
    end
    default: begin
      $display("%t: ERROR: STATE is now: UNKNOWN !!!!", $realtime);
      state_string = "??UNKNOWN??";
    end
  endcase

