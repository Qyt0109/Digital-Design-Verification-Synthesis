
parameter ROM_WIDTH = <rom_width>;
parameter ROM_ADDR_BITS = <rom_addr_bits>;

(* rom_style="{distributed | block}" *)
reg [ROM_WIDTH-1:0] <rom_name> [(2**ROM_ADDR_BITS)-1:0];
reg [ROM_WIDTH-1:0] <output_data>;

<reg_or_wire> [ROM_ADDR_BITS-1:0] <address>;

initial
   $readmemb("<data_file_name>", <rom_name>, 0, (2**ROM_ADDR_BITS)-1);
   // $readmemh("<data_file_name>", <rom_name>, 0, (2**ROM_ADDR_BITS)-1);

always @(posedge <clock>)
   if (<enable>)
      <output_data> <= <rom_name>[<address>];
             
             
      