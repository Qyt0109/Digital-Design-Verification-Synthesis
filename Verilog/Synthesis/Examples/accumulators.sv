
// Usage of asynchronous resets may negatively impact FPGA resources
// and timing. In general faster and smaller FPGA designs will
// result from not using asynchronous resets.

   parameter ACC_SIZE=<accumulator_width>;
   reg [ACC_SIZE-1:0] <accumulate_out>;

   always @ (posedge <clock> or posedge <reset>)
      if (<reset>)
         <accumulate_out> <= 0;
      else if (<clock_enable>)
         <accumulate_out> <= <accumulate_out> + <accumulate_in>;
				
				
   parameter ACC_SIZE=<accumulator_width>;
   reg [ACC_SIZE-1:0] <accumulate_out>;

   always @ (posedge <clock>)
      if (<reset>)
         <accumulate_out> <= 0;
      else if (<clock_enable>)
         <accumulate_out> <= <accumulate_out> + <accumulate_in>;
				
				
   parameter ACC_SIZE=<accumulator_width>;
   reg [ACC_SIZE-1:0] <accumulate_out>;

   always @ (posedge <clock>)
      if (<reset>)
         <accumulate_out> <= 0;
      else if (<clock_enable>)
         if (<load>)
            <accumulate_out> <= <load_value>;
         else
            <accumulate_out> <= <accumulate_out> + <accumulate_in>;
				
			