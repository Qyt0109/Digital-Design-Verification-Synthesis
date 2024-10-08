// Parallel In/Serial Out
parameter piso_shift = <shift_width>;

reg [piso_shift-2:0] <reg_name> = {piso_shift-1{1'b0}};
reg                  <output> = 1'b0;

always @(posedge <clock>)
   if (<reset>) begin
      <reg_name> <= 0;
      <output>    <= 1'b0;
   end
   else if (<load_signal>) begin
      <reg_name> <= <input>[piso_shift-1:1];
      <output>    <= <input>[0];
   end
   else if (<clock_enable>) begin
      <reg_name> <= {1'b0, <reg_name>[piso_shift-2:1]};
      <output>   <= <reg_name>[0];
   end
                 
                 
   // Serial In/Serial Out
   // Note: By using a reset for this shift register, this cannot
   //       be placed in an SRL shift register LUT.

   parameter siso_shift = <shift_length>;

   reg [siso_shift-1:0] <reg_name> = {siso{1'b0}};

   always @(posedge <clock>)
      if (<reset>)
         <reg_name> <= 0;
      else if (<clock_enable>)
         <reg_name>  <= {<input>, <reg_name>[siso_shift-1:1]};

   assign <output> = <reg_name>[0];
					
					
   // Static Shift SRL
   parameter clock_cycles = <number_of_clock_cycles>;
   parameter data_width = <width_of_data>;

   wire/reg [data_width-1:0] <data_in>, <data_out>;
   reg [clock_cycles-1:0] <shift_reg> [data_width-1:0];

   integer srl_index;
   initial
      for (srl_index = 0; srl_index < data_width; srl_index = srl_index + 1)
         <shift_reg>[srl_index] = {clock_cycles{1'b0}};

   genvar i;
   generate
      for (i=0; i < data_width; i=i+1)
      begin: <label>
         always @(posedge <clock>)
            if (<clock_enable>)
               <shift_reg>[i] <= {<shift_reg>[i][clock_cycles-2:0], <data_in>[i]};

         assign <data_out>[i] = <shift_reg>[i][clock_cycles-1];
      end
   endgenerate
					
					