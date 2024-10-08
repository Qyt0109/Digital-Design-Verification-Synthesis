

//  The following represents the connectivity of the registered
//    bi-directional I/O example
//
//                                       ______
//                                      |     |
//                           |----------|D    |
//                           |          |    Q|-----in_reg
//                           |  clock___|\    |
//    ________________       |          |/    |
//   / top_level_port \______|          |_____|
//   \________________/      |
//                           |
//                           |     /|
//                           |____/ |________________________
//                                \ |              _____     |
//                      _____     |\|             |     |    |
//                     |     |    |       out_sig-|D   Q|----|
//          out_en-----|D   Q|____|               |     |
//                     |     |            clock___|\    |
//               clock_|\    |                    |/    |
//                     |/    |                    |_____|
//                     |_____|
//
//
//
//  The following represents the connectivity of the unregistered
//    bi-directional I/O example
//
//                           |----------input_signal
//                           |
//                           |
//    ________________       |
//   / top_level_port \______|
//   \________________/      |
//                           |
//                           |     /|
//                           |____/ |______output_signal
//                                \ |
//                                |\|
//                                |
//                                |---output_enable_signal
//


// Registered input only

   inout [1:0] <top_level_port>;

   wire [1:0] <output_signal>;
   wire       <output_enable_signal>;
   reg  [1:0] <input_reg> = 2'b00;

   assign <top_level_port> = <output_enable_signal> ? <output_signal> : 2'bzz;

   always @(posedge <clock>)
      if (<reset>)
         <input_reg>  <= 2'b00;
      else
         <input_reg>  <= <top_level_port>;
					
// Registered input, output and output enable

   inout [1:0] <top_level_port>;

   reg [1:0] <input_reg> = 2'b00, <output_reg> = 2'b00, <output_enable_reg> = 2'b00;

   assign <top_level_port>[0] = <output_enable_reg>[0] ? <output_reg>[0] : 1'bz;
   assign <top_level_port>[1] = <output_enable_reg>[1] ? <output_reg>[1] : 1'bz;

   always @(posedge <clock>)
      if (<reset>) begin
         <input_reg>  <= 2'b00;
         <output_reg> <= 2'b00;
         <output_enable_reg> <= 2'b00;
      end else begin
         <input_reg>  <= <top_level_port>;
         <output_reg> <= <output_signal>;
         <output_enable_reg> <= {2{<output_enable_signal>}};
      end
					
// Registered output and output enable only					
      
   inout [1:0] <top_level_port>;

   reg  [1:0] <output_reg> = 2'b00, <output_enable_reg> = 2'b00;
   wire [1:0] <input_signal>, <output_signal>;
   wire       <output_enable_wire>;

   assign <input_signal> = <top_level_port>;

   assign <top_level_port>[0] = <output_enable_reg>[0] ? <output_reg>[0] : 1'bz;
   assign <top_level_port>[1] = <output_enable_reg>[1] ? <output_reg>[1] : 1'bz;

   always @(posedge <clock>)
      if (<reset>) begin
         <output_reg>  <= 2'b00;
         <output_enable_reg> <= 2'b00;
      end
      else begin
         <output_reg>  <= <output_signal>;
         <output_enable_reg> <= {2{<output_enable_signal>}};
      end
					
// Unregistered
      
   inout [1:0] <top_level_port>;

   wire [1:0] <output_signal>, <input_signal>;
   wire       <output_enable_signal>;

   assign <top_level_port> = <output_enable_signal> ? <output_signal> : 2'bzz;

   assign <input_signal> = <top_level_port>;
					
										