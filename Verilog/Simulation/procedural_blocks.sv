// Conditional repeated execution
always @(<signals>) begin
    <statements>;
 end
          
// Execute once          
   initial begin
    //  Wait for Global Reset to Complete
    #100;
    <statements>;
 end
          
// Repeated execution          
   always begin
    <statements>;
 end
          
      