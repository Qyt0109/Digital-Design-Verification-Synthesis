// 50% Duty cycle
   // Note: CLK must be defined as a reg when using this method

   parameter PERIOD = <value>;

   always begin
      CLK = 1'b0;
      #(PERIOD/2) CLK = 1'b1;
      #(PERIOD/2);
   end
				
				
   // Note: CLK must be defined as a wire when using this method

   parameter PERIOD = <value>;

   initial begin
      CLK = 1'b0;
      #(PERIOD/2);
      forever
         #(PERIOD/2) CLK = ~CLK;
   end
				
			
// Non-50% Duty cycle

   // Note: CLK must be defined as a reg when using this method

   parameter PERIOD = <value>;
   parameter DUTY_CYCLE = <value_0.01_to_0.99>;

   always begin
      CLK = 1'b0;
      #(PERIOD-(PERIOD*DUTY_CYCLE)) CLK = 1'b1;
      #(PERIOD*DUTY_CYCLE);
   end
				
				
   // Note: CLK must be defined as a wire when using this method

   parameter PERIOD = <value>;
   parameter DUTY_CYCLE = <value_0.01_to_0.99>;

   initial
      forever begin
         CLK = 1'b0;
         #(PERIOD-(PERIOD*DUTY_CYCLE)) CLK = 1'b1;
         #(PERIOD*DUTY_CYCLE);
      end
				
			