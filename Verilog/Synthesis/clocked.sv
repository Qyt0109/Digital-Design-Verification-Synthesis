// Clocked

// Negedge
always @(negedge <clock>)
if (<reset>) begin  // Reset High
   <signal> <= 0;
end else begin
   <signal> <= <clocked_value>;
end
          

always @(negedge <clock>)
if (!<reset>) begin // Reset Low
   <signal> <= 0;
end else begin
   <signal> <= <clocked_value>;
end
          

// Posedge
always @(posedge <clock>)
if (<reset>) begin  // Reset High
   <signal> <= 0;
end else begin
   <signal> <= <clocked_value>;
end
          

always @(posedge <clock>)
if (!<reset>) begin // Reset Low
   <signal> <= 0;
end else begin
   <signal> <= <clocked_value>;
end
          
// Simple Flop
always @(posedge <clock>) begin
    <signal> <= <clocked_value>;
 end
              
                                              