// Round even/odd
// Round toward infinity/zero


// This example shows how to infer Convergent Rounding (Even) using pattern
// detect within DSP block (Width of the inputs should be within
// what can be supported by the DSP architecture)
wire_or_reg <clk>; // Clock
wire_or_reg [23:0] <a>; // First Input
wire_or_reg [15:0] <b>; // Second Input
reg signed [23:0] <zlast>; // Convergent Round Output

reg signed [23:0] <areg>;
reg signed [15:0] <breg>;
reg signed [39:0] <z1>;

reg <pattern_detect>;
wire [15:0] <pattern> = 16'b0000000000000000;
wire [39:0] <c>       = 40'b0000000000000000000000000111111111111111; // 15 ones

wire signed [39:0] <multadd>;
wire signed [15:0] <zero>;
reg  signed [39:0] <multadd_reg>;

// Convergent Rounding: LSB Correction Technique
// ---------------------------------------------
// For static convergent rounding, the pattern detector can be used
// to detect the midpoint case. For example, in an 8-bit round, if
// the decimal place is set at 4, the C input should be set to
// 0000.0111.  Round to even rounding should use CARRYIN = "1" and
// check for PATTERN "XXXX.0000" and replace the units place with 0
// if the pattern is matched. See UG193 for more details.

assign <multadd> = <z1> + <c> + 1'b1;

always @(posedge <clk>)
begin
	<areg>  <= <a>;
	<breg>  <= <b>;
	<z1>    <= <areg> * <breg>;
	<pattern_detect> <= <multadd>[15:0] == <pattern> ? 1'b1 : 1'b0;
	<multadd_reg> <= <multadd>;
end

// Unit bit replaced with 0 if pattern is detected
always @(posedge <clk>)
 <zlast> <= <pattern_detect> ? {<multadd_reg>[39:17],1'b0} : <multadd_reg>[39:16];
				
				

// This example shows how to infer Convergent Rounding (Odd) using pattern detect within DSP block (Width of the inputs should be within what can be supported by the DSP architecture)
wire_or_reg <clk>; // Clock
wire_or_reg [23:0] <a>; // First Input
wire_or_reg [15:0] <b>; // Second Input
reg signed [23:0] <zlast>; // Convergent Round Output

reg signed [23:0] <areg>;
reg signed [15:0] <breg>;
reg signed [39:0] <z1>;

reg <pattern_detect>;
wire [15:0] <pattern> = 16'b1111111111111111;
wire [39:0] <c> = 40'b0000000000000000000000000111111111111111; // 15 ones

wire signed [39:0] <multadd>;
wire signed [15:0] <zero>;
reg  signed [39:0] <multadd_reg>;

// Convergent Rounding: LSB Correction Technique
// ---------------------------------------------
// For static convergent rounding,  the pattern detector can be
// used to detect  the midpoint case. For example,  in an 8-bit
// round, if the decimal place is  set at 4, the C input should
// be  set to  0000.0111.   Round to  odd  rounding should  use
// CARRYIN =  "0" and  check for  PATTERN "XXXX.1111"  and then
// replace  the  units place  bit  with  1  if the  pattern  is
// matched. See UG193 for details

assign <multadd> = <z1> + <c>;

always @(posedge <clk>)
begin
    <areg>  <= <a>;
	<breg>  <= <b>;
	<z1>    <= <areg> * <breg>;
	<pattern_detect> <= <multadd>[15:0] == <pattern> ? 1'b1 : 1'b0;
	<multadd_reg> <= <multadd>;
end

always @(posedge <clk>)
  <zlast> <= <pattern_detect> ? {<multadd_reg>[39:17],1'b1} : <multadd_reg>[39:16];
				
				

// This example shows how to infer Symmetric Rounding towards Infinity 
wire <clk>; //Clock
<wire_or_reg> signed [23:0] <a>; // a Input
<wire_or_reg> signed [15:0] <b>; // b Input
reg signed [23:0] <p>; // Symmetric Rounding Output
reg signed [23:0] <areg>;
reg signed [15:0] <breg>;
reg signed [39:0] <mult>;

wire [39:0] <c> = 40'b0000000000000000000000000111111111111111; // 15 ones

wire signed [39:0] <multadd>;
wire <cin>;
reg <cinreg>;

// In symmetric rounding towards infinity, the midpoint number 2.5 rounds to 3.0 and â€“2.5 rounds to â€“3
// The number of continuous ones in the C port bus plus 1 indicates the number of decimal places in the original number;
// for example, in the case of 4 decimal places, C is 00 â€¦ 0111

assign <cin> = <areg>[23] ~^ <breg>[15];
assign <multadd> = <mult> + <c> + <cinreg>;

always @(posedge <clk>)
begin
	<areg>  <= <a>;
	<breg>  <= <b>;
	<cinreg>	<= <cin>;
	<mult>    <= <areg> * <breg>;
	<p> <= <multadd>[39:16];	
end
				
				

// This example shows how to infer Symmetric Rounding towards Zero 
wire <clk>; //Clock
<wire_or_reg> signed [23:0] <a>; // a Input
<wire_or_reg> signed [15:0] <b>; // b Input
reg signed [23:0] <p>; // Symmetric Rounding Output
reg signed [23:0] <areg>;
reg signed [15:0] <breg>;
reg signed [39:0] <mult>;

wire [39:0] <c> = 40'b0000000000000000000000000111111111111111; // 15 ones

wire signed [39:0] <multadd>;
wire <cin>;
reg <cinreg>;

// In symmetric rounding towards Zero, the midpoint number 2.5 rounds to 2.0 and â€“2.5 rounds to â€“2
// The number of continuous ones in the C port bus plus 1 indicates the number of decimal places in the original number;
// for example, in the case of 4 decimal places, C is 00 â€¦ 0111

assign <cin> = <areg>[23] ^ <breg>[15];
assign <multadd> = <mult> + <c> + <cinreg>;

always @(posedge <clk>)
begin
	<areg>  <= <a>;
	<breg>  <= <b>;
	<cinreg>	<= <cin>;
	<mult>    <= <areg> * <breg>;
	<p> <= <multadd>[39:16];	
end
				
			