
parameter PWM_PRECISION_WIDTH = <value>;

reg <pwm_output> = 1'b0;
reg [PWM_PRECISION_WIDTH-1:0] <duty_cycle_reg> = {PWM_PRECISION_WIDTH{1'b0}};
reg [PWM_PRECISION_WIDTH-1:0] <temp_reg> = {PWM_PRECISION_WIDTH{1'b0}};

always @(posedge <clock>)
   if (<reset>)
      <duty_cycle_reg> <= 0;
   else if (<new_duty_cycle>)
      <duty_cycle_reg> <= <new_duty_cycle>;

always @(posedge <clock>)
   if (<reset>)
      <temp_reg> <= 0;
   else if (&<temp_reg>)
      <temp_reg> <= <duty_cycle_reg>;
   else if (<pwm_output>)
      <temp_reg> <= <temp_reg> + 1;
   else
      <temp_reg> <= <temp_reg> - 1;

always @(posedge <clock>)
   if (<reset>)
      <pwm_output> <= 1'b0;
   else if (&<temp_reg>)
      <pwm_output> <= ~<pwm_output>;
             
         