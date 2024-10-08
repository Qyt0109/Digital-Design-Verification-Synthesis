
// information on the $fopen, $fdisplay, $fstrobe, $fwrite, $ftell,
// $feof, $ferror, $fgetc, $fgets, and $fclose system functions
// ================================================================
//
// Opening Command
// ---------------
// $fopen is used to open a file for reading, writing and/or appending.
// This operation must precede any of the reading or writing commands
// specified in this document. When using the $fopen, you must specify
// the file name and file mode (read, write, etc.). The syntax looks like
// the following: $fopen("<file_name>", "<file_mode>")
// Upon opening the file a handle number is issued for the file and must
// be used to reference the file in subsequent commands. Generally, this
// number should be assigned to a declared integer.
//
// The file mode can be one of the following:
//
//    "r" ...... Open ASCII file for reading
//    "rb" ..... Open Binary file for reading
//    "w" ...... Open ASCII file for writing (delete if exists)
//    "wb" ..... Open Binary file for writing (delete if exists)
//    "a" ...... Open ASCII file for writing (append to end of file)
//    "ab" ..... Open Binary file for writing (append to end of file)
//    "r+" ..... Open ASCII file for reading and writing
//
//
// Writing Commands
// ----------------
// $fdisplay will write formatted text to a specified file. Specific text,
// system functions/tasks and signal values can be output using this
// function.  The file handle assigned by the $fopen function must be
// specified to indicate the destination file for the text.  The syntax looks
// as follows:  $fdisplay(<file_desc>, "<string>", variables);
//
// $fwrite acts very similar to $fdisplay in that it can write a specified
// string to a file however it does not specify a carriage return after
// performing this operation.
//
// $fstrobe is also similar to $fdisplay only waits for all simulation events
// in the queue to be executed before writing the message.
//
// $fmonitor will write a string to the specified file whenever a change
// in value is detected for one of the variables being written.  After
// the string is written, a carriage return is issued.
//
// When using these write commands ($fdisplay, $fwrite, $fstrobe, $fmonitor),
// variables can be specified to the output in a variety of formats.  Also,
// special escape characters can be used to specify special characters or
// formatting.  These formats are listed below.
//
//    Variables
//    ---------
//    %b .... Binary Value
//    %h .... Hexadecimal Value
//    %d .... Decimal Value
//    %t .... Time
//    %s .... String
//    %c .... ASCII
//    %f .... Real Value
//    %e .... Exponential Value
//    %o .... Octal Value
//    %m .... Module Hierarchical Name
//    %v .... Strength
//
//    Escape Characters
//    -----------------
//    \t ........ Tab
//    \n ........ Newline
//    \\ ........ Backslash
//    %% ........ Percent
//    \" ........ Quote
//    \<octal> .. ASCII representation
//
//
// Reading Commands
// ----------------
// $fgets will read an entire line of text from a file and store it as a
// string. The format for $fgets is: $fgets(<string_reg>, <file_desc>);
// $fgets returns an integer value either indicating the number of characters
// read or a zero indication an error during the read attempt.  The <string_reg>
// should be defined a width equal to the number of characters on the longest
// line multiplied by 8.
//
// $fgetc will read a character from a file and return it as an 8-bit string.
// If EOF is encountered, a value of -1 is written.
//
// $fscanf will read a line from a file and store it in a specified form. The
// format for the $fsacnf is: $fscanf(<file_desc>, <format>, <destination_regs>)
// where the format is specified similar to how it is specified in the read
// command above and the <destination_regs> is where the read data is stored.
// $fscanf will return an integer value indicating the number of matched
// formatted data read. If an error occurs during the read, this number will
// be zero.
//
//
// Special Functions
// -----------------
// $ferror tests and reports last error encountered during a file open, read
// or write.  The written string can be up to 80 characters (640 bits) wide.
//
// $fseek will reposition the pointer within the file to the specified position.
// The format for the $fseek command is:
// $fseek(<file_desc>, <offset_value>, <operation_number>) where the operation
// number is one of three values:
// 0 - set position using the beginning of file as the reference point
// 1 - set position using the current location of the pointer as reference
// 2 - set position using the EOF as reference
// $fseek will return a zero if the command was successful and a -1 if not.
//
// $ftell specifies the position of the pointer within the file by outputting an
// integer value indicating the number of offset bytes from the beginning of the
// file.
//
// $fflush writes any buffered output to the specified file.
//
//
// Close File
// ----------
// $fclose closes a previous opened file.  The format is $fclose(<file_desc>);
//
// In general, you may wish to limit the amount and occurrences of reading and
// writing to a file during simulation as it may have a negative impact on
// overall simulation runtime. File access can be a slow process and if done
// often can weigh down simulation quite a bit.
//
//
// Example of writing monitored signals:
// -------------------------------------

// Define file handle integer
integer outfile;

initial begin
  // Open file output.dat for writing
  outfile = $fopen("output.dat", "w");

  // Check if file was properly opened and if not, produce error and exit
  if (outfile == 0) begin
    $display("Error: File, output.dat could not be opened.\nExiting Simulation.");
    $finish;
  end

  // Write monitor data to a file
  $fmonitor(outfile, "Time: %t\t Data_out = %h", $realtime, Data_out);

  // Wait for 1 ms and end monitoring
  #1000000;

  // Close file to end monitoring
  $fclose(outfile);
end

// Example of reading a file using $fscanf:
// ----------------------------------------

real number;

// Define integers for file handling
integer number_file;
integer i = 1;

initial begin
  // Open file numbers.txt for reading
  number_file = $fopen("numbers.txt", "r");
  // Produce error and exit if file could not be opened
  if (number_file == 0) begin
    $display("Error: Failed to open file, numbers.txt\nExiting Simulation.");
    $finish;
  end
  // Loop while data is being read from file
  //    (i will be -1 when end of file or 0 for blank line)
  while (i > 0) begin
    $display("i = %d", i);
    i = $fscanf(number_file, "%f", number);
    $display("Number read from file is %f", number);
    @(posedge CLK);
  end
  // Close out file when finished reading
  $fclose(number_file);
  #100;
  $display("Simulation ended normally");
  $stop;
end

