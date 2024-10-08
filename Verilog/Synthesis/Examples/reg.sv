
always @(posedge <clock>)
if (<reset>) begin
   <reg> <= 1'b0;
end else if (<clock_enable>) begin
   <reg> <= <signal>;
end
                  
                  