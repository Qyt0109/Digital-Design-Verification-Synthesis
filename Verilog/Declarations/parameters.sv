
// information on the Verilog Parameter, Local Parameter,
//           Defparam and Named Parameter Value Assignment
// =======================================================
//
// Parameters are a method within Verilog in order to define constants
// within the code.  They are very useful in order to define bus widths,
// memory depths, state-machine assignments, clock periods and other useful
// constants used throughout the design and testbench.  Parameters can bring
// more meaning and documentation to the code or can be used to make the
// code more parameterizable and thus help enable re-use or help adjust to
// late changes in the design.  There are two main types of parameters, the
// parameter and local parameter.  A local parameter acts the same as a
// parameter however its contents cannot be modified via a defparam or a
// named parameter value assignment in the instantiation.  A defparam allows
// the reassignment to the value of a parameter from a different level of
// hierarchy in the testbench or design.  A named parameter value assignment
// allows a respecification of the parameter value within the instance
// declaration of the instantiation of the component.  Both local parameters
// and parameters can be sized to a specified number of bits and/or can be typed
// to be either a signed value, an integer, a real number, a time (64-bit
// precision) or a realtime (double-precision floating point) value.

// Example declaring a parameter and local parameter

// Define pi as a local real number parameter since I do not want to ever change this

localparam real pi = 3.14;

// Define BUS_WIDTH as a parameter with a default value of 8

parameter BUS_WIDTH = 8;

// Use this parameter to define the width of a declared register

reg [BUS_WIDTH-1:0] my_reg;

// Use a defparam from my testbench to change BUS_WIDTH to 16 for the instantiated
//    design instance UUT

defparam UUT.BUS_WIDTH = 16;

//  Alternatively to the defparam, I could have done this using the named parameter value assignment when I instantiate UUT

my_design #(
   .BUS_WIDTH(16)
) UUT (
   .A(A),
   .B(B),
   .C(C)
);
				
				