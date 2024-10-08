
// The following are the arithmetic operators as defined by the Verilog language.
//
//    + .... Addition
//    - .... Subtraction
//    * .... Multiplication
//    / .... Divide
//    % .... Modulus
//    ** ... Power Operator (i.e. 2**8 returns 256)
			
			
// The following operators can be used on two single bits to produce a single bit
// output or two equivalent sized bused signals where the operations are performed
// on each bit of the bus. In the case of the Invert, only one signal or bus is
// provided and the operation occurs on each bit of the signal.
//
//    ~ .... Invert a single-bit signal or each bit in a bus
//    & .... AND two single bits or each bit between two buses
//    | .... OR two single bits or each bit between two buses
//    ^ .... XOR two single bits or each bit between two buses
//    ~^ ... XNOR two single bits or each bit between two buses
			
			
// The following logical operators are used in conditional TRUE/FALSE statements
// such as an if statement in order to specify the condition for the operation.
//
//    ! .... Not True
//    && ... Both Inputs True
//    || ... Either Input True
//    == ... Inputs Equal
//    === .. Inputs Equal including X and Z (simulation only)
//    != ... Inputs Not Equal
//    !== .. Inputs Not Equal including X and Z (simulation only)
//    < .... Less-than
//    <= ... Less-than or Equal
//    > .... Greater-than
//    >= ... Greater-than or Equal
			
			
// The following operators either concatenates several bits into a bus or replicate
// a bit or combination of bits multiple times.
//
//    {a, b, c} .... Concatenate a, b and c into a bus
//    {3{a}} ....... Replicate a, 3 times
//    {{5{a}}, b} .. Replicate a, 5 times and concatenate to b
//
			
			
// The following operators will shift a bus right or left a number of bits.
//
//    << .... Left shift (i.e. a << 2 shifts a two bits to the left)
//    <<< ... Left shift and fill with zeroes
//    >> .... Right shift (i.e. b >> 1 shifts b one bits to the right)
//    >>> ... Right shift and maintain sign bit
			
			
// The following operators can be used on a bussed signal where all bits in the bus
// are used to perform the operation and a single bit output is resolved.
//
//    & .... AND all bits together to make single bit output
//    ~& ... NAND all bits together to make single bit output
//    | .... OR all bits together to make single bit output
//    ~| ... NOR all bits together to make single bit output
//    ^ .... XOR all bits together to make single bit output
//    ~^ ... XNOR all bits together to make single bit output
			
		