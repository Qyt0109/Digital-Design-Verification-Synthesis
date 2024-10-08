
reg [2:0] <reg_name> = 3'b000;

always @(posedge <clock>)
   if (reset == 1)
      <reg_name> <= 3'b000;
   else
      <reg_name> <= {<reg_name>[1:0], <input>};

assign <output> = <reg_name>[0] & <reg_name>[1] & !<reg_name>[2];
             
             