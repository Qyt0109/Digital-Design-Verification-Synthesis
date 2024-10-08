
// 7-segment encoding
//      0
//     ---
//  5 |   | 1
//     --- <--6
//  4 |   | 2
//     ---
//      3

   always @(<4-bit_hex_input>)
   case (<4-bit_hex_input>)
       4'b0001 : <7-seg_output> = 7'b1111001;   // 1
       4'b0010 : <7-seg_output> = 7'b0100100;   // 2
       4'b0011 : <7-seg_output> = 7'b0110000;   // 3
       4'b0100 : <7-seg_output> = 7'b0011001;   // 4
       4'b0101 : <7-seg_output> = 7'b0010010;   // 5
       4'b0110 : <7-seg_output> = 7'b0000010;   // 6
       4'b0111 : <7-seg_output> = 7'b1111000;   // 7
       4'b1000 : <7-seg_output> = 7'b0000000;   // 8
       4'b1001 : <7-seg_output> = 7'b0010000;   // 9
       4'b1010 : <7-seg_output> = 7'b0001000;   // A
       4'b1011 : <7-seg_output> = 7'b0000011;   // b
       4'b1100 : <7-seg_output> = 7'b1000110;   // C
       4'b1101 : <7-seg_output> = 7'b0100001;   // d
       4'b1110 : <7-seg_output> = 7'b0000110;   // E
       4'b1111 : <7-seg_output> = 7'b0001110;   // F
       default : <7-seg_output> = 7'b1000000;   // 0
   endcase
             
             