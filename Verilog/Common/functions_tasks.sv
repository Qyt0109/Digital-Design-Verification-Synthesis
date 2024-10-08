
// User defined function and task information
// ==========================================
//
// A user defined function is a set of Verilog statements that
// can be called from elsewhere within the body of the code by
// an assignment.  A function can have multiple inputs however
// can return only a single output.  No timing information can
// be specified within a function.
//
// A user defined task is a subroutine that can be executed by
// a single call from elsewhere within the body of the code.
// A task can have any number of inputs, outputs and inouts as
// well as contain timing information.
//
// Example of a function declaration:

   function  [9:0] gray_encode;
   input [9:0] binary_input;
   begin
      gray_encode[9] = binary_input[9];
      for (k=8; k>=0; k=k-1) begin
         gray_encode[k] = binary_input[k+1] ^ binary_input[k];
      end
   end
endfunction

// Example of calling a function:

// write_count is the binary input being passed to the function gray_encode.
// The output of the function gray_encode is then passed to the signal FIFO_ADDR
FIFO_ADDR = gray_encode(write_count);

// Example of a task declaration:

task error_action;
   input read_write;
   input correct_value;
   input actual_value;
   input [8*11:0] output_string;
   begin
      if (ERROR_CHECK) begin
         if (read_write)
            $display("Error: %s value incorrect during write %d at time %t\nExpecting %b, got %b",
                      output_string, write_attempt, $realtime, correct_value, actual_value);
         else
            $display("Error: %s value incorrect during read %d at time %t\nExpecting %b, got %b",
                      output_string, read_attempt, $realtime, correct_value, actual_value);
         if (ON_ERROR=="FINISH")
            $finish;
         else if (ON_ERROR=="STOP")
            $stop;
      end
   end
   endtask

// Example of calling a task:

// The task error_action is called by name and passed the four input values
//    in the order they are declared in the task
error_action(1'b1, wr_ready_value, WR_READY, "WR_READY");
         
         