
// information on the $readmemb and $readmemh system functions
// ===========================================================
//
// $readmemb is a system function which will read binary data from a
// specified file and place it in an array. The syntax is the following:
// $readmemb ("<file_name>", <reg_name>, <start_address>, <end_address>);
// where the <file_name> is the name and location of the file containing
// the binary data, the <reg_name> is a 2-D register array in which the
// memory data is stored, and the last two optional comma separated  numbers
// specify the beginning and ending address of the data.  The data file
// may only contain binary data, white spaces and comments.  This function
// must be executed within an initial block.
//
// $readmemh is the same as $readmemb with the exception that it
// inputs hex data as the read values.
//
// In the past, these functions could only be used for simulation
// purposes however synthesis tools now has the ability to initialize RAM
// and ROM arrays using this construct.
//
// Example of reading binary data from a file:

   reg  [31:0] rom_data[1023:0];

   initial
     $readmemb("../data/mem_file.dat", rom_data, 0, 7);

// The initialization file may only contain white spaces, address
// labels (denoted by @<address>), comments and the actual binary
// or hexadecimal data.
// The following is a small example of a binary memory file data:

// This is a comment

1111000011110000     // This specifies these 16-bits to the first address
1010_0101_1010_0101  // This is for the second address with underscores
                     // to make this more readable
<more entries like above to fill up the array>

// Optionally, we can change addresses
@025 // Now at address 025
11111111_00000000

// Addresses can also be specified in-line
@035 00000000_11111111

// It is highly suggested to fill all memory contents with a known value
//  when initializing memories.
					
				