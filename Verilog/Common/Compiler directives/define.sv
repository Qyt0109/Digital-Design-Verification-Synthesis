
// The `define, `ifdef, `elsif, `else, `ifndef and the `endif compiler directives
// ==============================================================================
//
// `define is a compiler directive that defines a value to a variable. That variable
// can then be called upon in the code by referencing the `name of the specified variable.
//
// `ifdef is a compiler directive that checks for the existence of a specified `define
// and then conditionally includes a section of code during compilation if it exists.
//
// `ifndef is the opposite of `ifdef in that if a `define was not declared, it includes
// a section of code.
//
// `elsif can be used in conjunction with a `ifdef to find the existence of another
// `define and conditionally compile a different section of code if the previous
// conditions were not met and this condition is met.
//
// `else also can be used in conjunction with a `ifdef where it will compile a section
// of code if all previous `ifdef and `elsif conditions were not met.
//
// `endif is used at the end of a `ifdef or `ifndef statement to signify the end of
// the included code.
//
// Example:

`define DATA_WIDTH 16
`define DATA_WIDTH16

reg [`DATA_WIDTH-1:0] data;

`ifdef DATA_WIDTH8
// If DATA_WIDTH8 was set, this would get compiled
`elsif DATA_WIDTH16
// Since DATA_WIDTH16 is set, this does get compiled
`else
// If DATA_WIDTH8 and DATA_WIDTH16 was not defined, this would be compiled
`endif

