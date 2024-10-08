
// information on the system tasks $time, $stime, $realtime, and $timeformat
// =========================================================================
//
// $time is a system function in which returns the current simulation time
// as a 64-bit integer.
//
// $stime is a system function in which returns the lower 32-bits of the
// current simulation time.
//
// $realtime is a system function that returns the current simulation time
// as a real number.
//
// Generally, these system time functions are using within screen
// ($monitor and $display) and file output ($fwrite and $fmonitor) commands
// to specify within the message the simulation time at which the message is
// displayed or written.
//
//
// $timeformat is a system call which specifies the format in which the $time,
// $stime and $realtime should be displayed when used with the %t format
// variable in a display or write call.  It is recommended to specify this
// within the testbench when using the %t variable to make the time value more
// readable.  The $timeformat must be specified within an initial declaration.
// The format of $timeformat is the following:

initial
$timeformat (<unit>, <precision>, <suffix_string>, <min_field_width>);

//
// Example:
//
// This specifies the output to be displayed in nano-seconds, a precision
//    down to pico seconds, to append the string " ns" after the time and
//    to allow for 13 numbers to be displayed to show this value.
initial
$timeformat (-9, 3, " ns", 13);

// This will display the system time in the format specified above after
//   the string "Time=" as well as display the value of DATA_OUT every
//   time DATA_OUT changes value.
initial
$monitor("Time=%t : DATA_OUT=%b", $realtime, DATA_OUT);

             
         