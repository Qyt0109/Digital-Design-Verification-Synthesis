
// The `timescale compile directive information
// ============================================
//
// `timescale is a compiler directive that indicates to the simulator the time units
// and precision to be used during simulation.  The format is the following:
//
// `timescale <units> / <precision>
//
// The units should be set to the base value in which time will be communicated to
// the simulator for that module.
// The precision is the minimum time units you wish the simulator to resolve. The
// smallest resolution value in all files and models compiled for simulation dictates
// the overall simulation resolution. In general for Xilinx FPGAs, a simulator
// resolution of 1ps is recommended since some components like the DCM require this
// resolution for proper operation and 1 ps is the resolution used for timing simulation.
//
// In general, this directive should appear at the top of the testbench, simulation models
// and all design files for a Verilog project.
//
// Example:

`timescale 1 ns / 1ps

#1;           // Delays for 1 ns
#1.111;       // Delays for 1111 ps
#1.111111111; // Delays for 1111 ps since the resolution is more course than
              //    what is specified, the delay amount is truncated
				
			