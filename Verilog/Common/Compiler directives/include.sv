
// The `include complier directive
// ===============================
//
// `include can be used to insert the contents of a separate file into a module.
// This is often used to communicate common functions, compiler directives, parameters
// and `defines to multiple files in a project.  The file and path name must be
// specified in quotes and can consist of just the file name (looks in the current
// working directory for the file), a relative path to the file or an absolute path
// to the file.  This directive can be specified both before the module declaration
// as well as within the module directive.
//
// Example:

// Include the contents of the parameters.vh file located in the current working directory.
// Many simulator and synthesis tools also offer a switch/option to allow specification
// of a search directory other than the working directory for files specified in this manner.
`include "parameters.vh"

// Include the contents of the ram_data.vh file in the relative directory ../data
`include "../data/ram_data.vh"

// Include the contents of master.vh in the absolute directory /export/vol1/sim_data
`include "/export/vol1/sim_data/master.vh"


