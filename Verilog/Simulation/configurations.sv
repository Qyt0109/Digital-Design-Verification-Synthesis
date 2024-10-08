
// The Verilog-2001 Configuration Statement
// ========================================
//
// Verilog-2001 adds a new construct, the configuration or config statement,
// to the Verilog language to allow the modification of library binding rules.
// In general, it is still suggested to use the simulator to specify the library
// binding however at times more specific control is needed and this construct
// allows very specific binding rules for libraries.  This is generally used
// for simulation where different models (i.e. behavioral, rtl or gate-level) can
// be used and inter-changed during simulation.
//
// Example: The following will change the default library binding rules for
//          a design named ethernet_top located in the work library so that
//          the library named gate_lib is used first and if not found there,
//          rtl_lib is used. The configuration is name mixed_gate_sim

config mixed_gate_sim;
design work.ethernet_top
default liblist gate_lib rtl_lib;
endconfig;

// Example: The following will change the default library binding rules for
//          any instantiation of a module named sram512 in the module named
//          ethernet_top located in the work library so that the library named
//          sim_lib is used for that model

config mixed_gate_sim;
design work.ethernet_top
default liblist gate_lib rtl_lib;
cell sram512 use sim_lib.sram512;
endconfig;

// Example: The following will change the default library binding rules for
//          the instance named sdram_ctrl_inst in the module named
//          custom_cpu located in the work library so that the library named
//          dave_lib is used for that model

config mixed_gate_sim;
design work.custom_cpu
default liblist gate_lib rtl_lib;
instance custom_cpu_top.sdram_ctrl_inst liblist dave_lib;
endconfig;
         
         