// Adder
parameter ADDER_WIDTH = <adder_bit_width>;

wire signed [ADDER_WIDTH-1:0] <a_input>;
wire signed [ADDER_WIDTH-1:0] <b_input>;
wire signed [ADDER_WIDTH-1:0] <sum>;

assign <sum> = <a_input> + <b_input>;
                     

parameter ADDER_WIDTH = <adder_bit_width>;

wire [ADDER_WIDTH-1:0] <a_input>;
wire [ADDER_WIDTH-1:0] <b_input>;
wire [ADDER_WIDTH-1:0] <sum>;

assign <sum> = <a_input> + <b_input>;
                     

parameter ADDER_WIDTH = <adder_bit_width>;

wire [ADDER_WIDTH-1:0] <a_input>;
wire [ADDER_WIDTH-1:0] <b_input>;
wire                   <carry_out>;
wire [ADDER_WIDTH-1:0] <sum>;

assign {<carry_out>, <sum>} = <a_input> + <b_input>;
                     

parameter ADDER_WIDTH = <adder_bit_width>;

reg signed [ADDER_WIDTH-1:0] <sum> = {ADDER_WIDTH{1'b0}};

always @(posedge <CLK>)
   <sum> <= <a_input> + <b_input>;
                     

   parameter ADDER_WIDTH = <adder_bit_width>;

   reg [ADDER_WIDTH-1:0] <sum> = {ADDER_WIDTH{1'b0}};

   always @(posedge <CLK>)
      <sum> <= <a_input> + <b_input>;
						
						                                                                                
   parameter ADDER_WIDTH = <adder_bit_width>;

   reg [ADDER_WIDTH-1:0] <sum> = {ADDER_WIDTH{1'b0}};
   reg                   <carry_out> = 1'b0;

   always @(posedge <CLK>)
      {<carry_out>, <sum>} <= <a_input> + <b_input>;
						
// Sub					

      parameter SUB_WIDTH = <sub_bit_width>;

      wire [SUB_WIDTH-1:0] <a_input>;
      wire [SUB_WIDTH-1:0] <b_input>;
      wire [SUB_WIDTH-1:0] <difference>;
   
      assign <difference> = <a_input> - <b_input>;
                       
// Mul
      

   // Note: Performance of un-registered multiplier may be lacking.
   // Suggested to use pipeline registers when possible for best performance characteristics.

   parameter MULT_INPUT_WIDTH = <mult_input_bit_width>;

   wire [MULT_INPUT_WIDTH-1:0] <a_input>;
   wire [MULT_INPUT_WIDTH-1:0] <b_input>;
   wire [MULT_INPUT_WIDTH*2-1:0] <product>;

   assign <product> = <a_input> * <b_input>;
					

   wire [17:0] <a_input>;
   wire [17:0] <b_input>;
   reg  [35:0] <product> = {36{1'b0}};

   always @(posedge <clock>)
      <product> <= <a_input> * <b_input>;
					
					

// 27x35 Large signed Multiplier with clock enable. This infers 2 DSP Slices
      parameter AW = 27; // input data width-<a_input>
      parameter BW = 35; // input data width-<b_input>
      wire signed [AW-1:0] <a_input>;
      wire signed [BW-1:0] <b_input>;
      wire <clk>;
      wire <clken>;
      wire signed [AW+BW-1:0] <product>;
      wire signed [AW+BW-1:0] <mult>;
      reg signed [AW+BW-1:0] <p0>,<p1>,<p2>,<p3>;
      
      assign <mult>	= <a_input> * <b_input>;
      always@(posedge <clk>)
      begin
          if(<clken> == 1) begin //Clock enable
            <p0> <= <mult>;
            <p1> <= <p0>;
            <p2> <= <p1>;
            <p3> <= <p2>;
          end
      end
      //4 Pipeline registers are used. Here minimum 2 pipeline registers are required.
      //No of pipeline registers required depends on the large multiplier size
      assign <product> = <p3>;
                          
                                             