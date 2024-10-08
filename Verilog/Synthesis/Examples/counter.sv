// UP/DOWN
parameter COUNTER_WIDTH = <width>;

reg [COUNTER_WIDTH-1:0] <reg_name> = {COUNTER_WIDTH{1'b0}};

always @(posedge <clock>)
   if (<reset>)
      <reg_name> <= {COUNTER_WIDTH{1'b0}};
   else if (<clock_enable>)
      if (<load_enable>)
         <reg_name> <= <load_signal_or_value>;
      else if (<up_down>)
         <reg_name> <= <reg_name> + 1'b1;
      else
         <reg_name> <= <reg_name> - 1'b1;
                     
// Gray
   parameter gray_width = <gray_value_width>;

   reg  [gray_width-1:0] <binary_value> = {{gray_width{1'b0}}, 1'b1};
   reg  [gray_width-1:0] <gray_value> = {gray_width{1'b0}};

   always @(posedge <clock>)
      if (<reset>) begin
         <binary_value> <= {{gray_width{1'b0}}, 1'b1};
         <gray_value> <= {gray_width{1'b0}};
      end
      else if (<clock_enable>) begin
         <binary_value> <= <binary_value> + 1;
         <gray_value> <= (<binary_value> >> 1) ^ <binary_value>;
      end
					
// LFSR
   reg [7:0] <reg_name> = 8'h00;

   always @(posedge <clock>)
      if (<reset>)
         <reg_name> <= 8'h00;
      else if (<clock_enable>) begin
         <reg_name>[7:1] <= <reg_name>[6:0];
         <reg_name>[0] <= ~^{<reg_name>[7], <reg_name>[5:3]};
      end
					
					 				                     