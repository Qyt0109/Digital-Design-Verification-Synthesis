
  //  Xilinx Simple Dual Port Single Clock RAM with Byte-write
  //  This code implements a parameterizable SDP single clock memory.
  //  If a reset or enable is not necessary, it may be tied off or removed from the code.

  parameter NB_COL = <col>;                       // Specify number of columns (number of bytes)
  parameter COL_WIDTH = <width>;                  // Specify column width (byte width, typically 8 or 9)
  parameter RAM_DEPTH = <depth>;                  // Specify RAM depth (number of entries)
  parameter RAM_PERFORMANCE = "HIGH_PERFORMANCE"; // Select "HIGH_PERFORMANCE" or "LOW_LATENCY" 
  parameter INIT_FILE = "";                       // Specify name/location of RAM initialization file if using one (leave blank if not)

  <wire_or_reg> [clogb2(RAM_DEPTH-1)-1:0] <addra>; // Write address bus, width determined from RAM_DEPTH
  <wire_or_reg> [clogb2(RAM_DEPTH-1)-1:0] <addrb>; // Read address bus, width determined from RAM_DEPTH
  <wire_or_reg> [(NB_COL*COL_WIDTH)-1:0] <dina>; // RAM input data
  <wire_or_reg> <clka>;                          // Clock
  <wire_or_reg> [NB_COL-1:0] <wea>;              // Byte-write enable
  <wire_or_reg> <enb>;                           // Read Enable, for additional power savings, disable when not in use
  <wire_or_reg> <rstb>;                          // Output reset (does not affect memory contents)
  <wire_or_reg> <regceb>;                        // Output register enable
  wire [(NB_COL*COL_WIDTH)-1:0] <doutb>;         // RAM output data

  reg [(NB_COL*COL_WIDTH)-1:0] <ram_name> [RAM_DEPTH-1:0];
  reg [(NB_COL*COL_WIDTH)-1:0] <ram_data> = {(NB_COL*COL_WIDTH){1'b0}};

  // The following code either initializes the memory values to a specified file or to all zeros to match hardware
  generate
    if (INIT_FILE != "") begin: use_init_file
      initial
        $readmemh(INIT_FILE, <ram_name>, 0, RAM_DEPTH-1);
    end else begin: init_bram_to_zero
      integer ram_index;
      initial
        for (ram_index = 0; ram_index < RAM_DEPTH; ram_index = ram_index + 1)
          <ram_name>[ram_index] = {(NB_COL*COL_WIDTH){1'b0}};
    end
  endgenerate

  always @(posedge <clka>)
    if (<enb>)
      <ram_data> <= <ram_name>[<addrb>];

  generate
  genvar i;
     for (i = 0; i < NB_COL; i = i+1) begin: byte_write
       always @(posedge <clka>)
         if (<wea>[i])
           <ram_name>[<addra>][(i+1)*COL_WIDTH-1:i*COL_WIDTH] <= dina[(i+1)*COL_WIDTH-1:i*COL_WIDTH];
      end
  endgenerate

  //  The following code generates HIGH_PERFORMANCE (use output register) or LOW_LATENCY (no output register)
  generate
    if (RAM_PERFORMANCE == "LOW_LATENCY") begin: no_output_register

      // The following is a 1 clock cycle read latency at the cost of a longer clock-to-out timing
       assign <doutb> = <ram_data>;

    end else begin: output_register

      // The following is a 2 clock cycle read latency with improve clock-to-out timing

      reg [(NB_COL*COL_WIDTH)-1:0] doutb_reg = {(NB_COL*COL_WIDTH){1'b0}};

      always @(posedge <clka>)
        if (<rstb>)
          doutb_reg <= {(NB_COL*COL_WIDTH){1'b0}};
        else if (<regceb>)
          doutb_reg <= <ram_data>;

      assign <doutb> = doutb_reg;

    end
  endgenerate

  //  The following function calculates the address width based on specified RAM depth
  function integer clogb2;
    input integer depth;
      for (clogb2=0; depth>0; clogb2=clogb2+1)
        depth = depth >> 1;
  endfunction
						
						

  //  Xilinx Single Port Byte-Write Read First RAM
  //  This code implements a parameterizable single-port byte-write read-first memory where when data
  //  is written to the memory, the output reflects the prior contents of the memory location.
  //  If a reset or enable is not necessary, it may be tied off or removed from the code.
  //  Modify the parameters for the desired RAM characteristics.

  parameter NB_COL = <col>;                       // Specify number of columns (number of bytes)
  parameter COL_WIDTH = <width>;                  // Specify column width (byte width, typically 8 or 9)
  parameter RAM_DEPTH = <depth>;                  // Specify RAM depth (number of entries)
  parameter RAM_PERFORMANCE = "HIGH_PERFORMANCE"; // Select "HIGH_PERFORMANCE" or "LOW_LATENCY" 
  parameter INIT_FILE = "";                       // Specify name/location of RAM initialization file if using one (leave blank if not)

  <wire_or_reg> [clogb2(RAM_DEPTH-1)-1:0] <addra>;  // Address bus, width determined from RAM_DEPTH
  <wire_or_reg> [(NB_COL*COL_WIDTH)-1:0] <dina>;  // RAM input data
  <wire_or_reg> <clka>;                           // Clock
  <wire_or_reg> [NB_COL-1:0] <wea>;               // Byte-write enable
  <wire_or_reg> <ena>;                            // RAM Enable, for additional power savings, disable port when not in use
  <wire_or_reg> <rsta>;                           // Output reset (does not affect memory contents)
  <wire_or_reg> <regcea>;                         // Output register enable
  wire [(NB_COL*COL_WIDTH)-1:0] <douta>;          // RAM output data

  reg [(NB_COL*COL_WIDTH)-1:0] <ram_name> [RAM_DEPTH-1:0];
  reg [(NB_COL*COL_WIDTH)-1:0] <ram_data> = {(NB_COL*COL_WIDTH){1'b0}};

  // The following code either initializes the memory values to a specified file or to all zeros to match hardware
  generate
    if (INIT_FILE != "") begin: use_init_file
      initial
        $readmemh(INIT_FILE, <ram_name>, 0, RAM_DEPTH-1);
    end else begin: init_bram_to_zero
      integer ram_index;
      initial
        for (ram_index = 0; ram_index < RAM_DEPTH; ram_index = ram_index + 1)
          <ram_name>[ram_index] = {(NB_COL*COL_WIDTH){1'b0}};
    end
  endgenerate

  always @(posedge <clka>)
    if (<ena>) begin
      <ram_data> <= <ram_name>[<addra>];
    end

  generate
  genvar i;
     for (i = 0; i < NB_COL; i = i+1) begin: byte_write
       always @(posedge <clka>)
         if (<ena>)
           if (<wea>[i])
             <ram_name>[<addra>][(i+1)*COL_WIDTH-1:i*COL_WIDTH] <= <dina>[(i+1)*COL_WIDTH-1:i*COL_WIDTH];
      end
  endgenerate

  //  The following code generates HIGH_PERFORMANCE (use output register) or LOW_LATENCY (no output register)
  generate
    if (RAM_PERFORMANCE == "LOW_LATENCY") begin: no_output_register

      // The following is a 1 clock cycle read latency at the cost of a longer clock-to-out timing
       assign <douta> = <ram_data>;

    end else begin: output_register

      // The following is a 2 clock cycle read latency with improve clock-to-out timing

      reg [(NB_COL*COL_WIDTH)-1:0] douta_reg = {(NB_COL*COL_WIDTH){1'b0}};

      always @(posedge <clka>)
        if (<rsta>)
          douta_reg <= {(NB_COL*COL_WIDTH){1'b0}};
        else if (<regcea>)
          douta_reg <= <ram_data>;

      assign <douta> = douta_reg;

    end
  endgenerate

  //  The following function calculates the address width based on specified RAM depth
  function integer clogb2;
    input integer depth;
      for (clogb2=0; depth>0; clogb2=clogb2+1)
        depth = depth >> 1;
  endfunction
							
							

  //  Xilinx Single Port Byte-Write Write First RAM
  //  This code implements a parameterizable single-port byte-write write-first memory where when data
  //  is written to the memory, the output reflects the new memory contents.
  //  If a reset or enable is not necessary, it may be tied off or removed from the code.
  //  Modify the parameters for the desired RAM characteristics.

  parameter NB_COL = <col>;                       // Specify number of columns (number of bytes)
  parameter COL_WIDTH = <width>;                  // Specify column width (byte width, typically 8 or 9)
  parameter RAM_DEPTH = <depth>;                  // Specify RAM depth (number of entries)
  parameter RAM_PERFORMANCE = "HIGH_PERFORMANCE"; // Select "HIGH_PERFORMANCE" or "LOW_LATENCY" 
  parameter INIT_FILE = "";                       // Specify name/location of RAM initialization file if using one (leave blank if not)

  <wire_or_reg> [clogb2(RAM_DEPTH-1)-1:0] <addra>;  // Address bus, width determined from RAM_DEPTH
  <wire_or_reg> [(NB_COL*COL_WIDTH)-1:0] <dina>;  // RAM input data
  <wire_or_reg> <clka>;                           // Clock
  <wire_or_reg> [NB_COL-1:0] <wea>;               // Byte-write enable
  <wire_or_reg> <ena>;                            // RAM Enable, for additional power savings, disable port when not in use
  <wire_or_reg> <rsta>;                           // Output reset (does not affect memory contents)
  <wire_or_reg> <regcea>;                         // Output register enable
  wire [(NB_COL*COL_WIDTH)-1:0] <douta>;          // RAM output data

  reg [(NB_COL*COL_WIDTH)-1:0] <ram_name> [RAM_DEPTH-1:0];
  reg [(NB_COL*COL_WIDTH)-1:0] <ram_data> = {(NB_COL*COL_WIDTH){1'b0}};

  // The following code either initializes the memory values to a specified file or to all zeros to match hardware
  generate
    if (INIT_FILE != "") begin: use_init_file
      initial
        $readmemh(INIT_FILE, <ram_name>, 0, RAM_DEPTH-1);
    end else begin: init_bram_to_zero
      integer ram_index;
      initial
        for (ram_index = 0; ram_index < RAM_DEPTH; ram_index = ram_index + 1)
          <ram_name>[ram_index] = {(NB_COL*COL_WIDTH){1'b0}};
    end
  endgenerate

  generate
  genvar i;
     for (i = 0; i < NB_COL; i = i+1) begin: byte_write
       always @(posedge <clka>)
         if (<ena>)
           if (<wea>[i]) begin
             <ram_name>[<addra>][(i+1)*COL_WIDTH-1:i*COL_WIDTH] <= <dina>[(i+1)*COL_WIDTH-1:i*COL_WIDTH];
             <ram_data>[(i+1)*COL_WIDTH-1:i*COL_WIDTH] <= <dina>[(i+1)*COL_WIDTH-1:i*COL_WIDTH];
           end else
             <ram_data>[(i+1)*COL_WIDTH-1:i*COL_WIDTH] <= <ram_name>[addra][(i+1)*COL_WIDTH-1:i*COL_WIDTH];

      end
  endgenerate

  //  The following code generates HIGH_PERFORMANCE (use output register) or LOW_LATENCY (no output register)
  generate
    if (RAM_PERFORMANCE == "LOW_LATENCY") begin: no_output_register

      // The following is a 1 clock cycle read latency at the cost of a longer clock-to-out timing
       assign <douta> = <ram_data>;

    end else begin: output_register

      // The following is a 2 clock cycle read latency with improve clock-to-out timing

      reg [(NB_COL*COL_WIDTH)-1:0] douta_reg = {(NB_COL*COL_WIDTH){1'b0}};

      always @(posedge <clka>)
        if (<rsta>)
          douta_reg <= {(NB_COL*COL_WIDTH){1'b0}};
        else if (<regcea>)
          douta_reg <= <ram_data>;

      assign <douta> = douta_reg;

    end
  endgenerate

  //  The following function calculates the address width based on specified RAM depth
  function integer clogb2;
    input integer depth;
      for (clogb2=0; depth>0; clogb2=clogb2+1)
        depth = depth >> 1;
  endfunction
							
						

  //  Xilinx Single Port No Change RAM
  //  This code implements a parameterizable single-port no-change memory where when data is written
  //  to the memory, the output remains unchanged.  This is the most power efficient write mode.
  //  If a reset or enable is not necessary, it may be tied off or removed from the code.

  parameter RAM_WIDTH = <width>;                  // Specify RAM data width
  parameter RAM_DEPTH = <depth>;                  // Specify RAM depth (number of entries)
  parameter RAM_PERFORMANCE = "HIGH_PERFORMANCE"; // Select "HIGH_PERFORMANCE" or "LOW_LATENCY" 
  parameter INIT_FILE = "";                       // Specify name/location of RAM initialization file if using one (leave blank if not)

  <wire_or_reg> [clogb2(RAM_DEPTH-1)-1:0] <addra>;  // Address bus, width determined from RAM_DEPTH
  <wire_or_reg> [RAM_WIDTH-1:0] <dina>;           // RAM input data
  <wire_or_reg> <clka>;                           // Clock
  <wire_or_reg> <wea>;                            // Write enable
  <wire_or_reg> <ena>;                            // RAM Enable, for additional power savings, disable port when not in use
  <wire_or_reg> <rsta>;                           // Output reset (does not affect memory contents)
  <wire_or_reg> <regcea>;                         // Output register enable
  wire [RAM_WIDTH-1:0] <douta>;                   // RAM output data

  reg [RAM_WIDTH-1:0] <ram_name> [RAM_DEPTH-1:0];
  reg [RAM_WIDTH-1:0] <ram_data> = {RAM_WIDTH{1'b0}};

  // The following code either initializes the memory values to a specified file or to all zeros to match hardware
  generate
    if (INIT_FILE != "") begin: use_init_file
      initial
        $readmemh(INIT_FILE, <ram_name>, 0, RAM_DEPTH-1);
    end else begin: init_bram_to_zero
      integer ram_index;
      initial
        for (ram_index = 0; ram_index < RAM_DEPTH; ram_index = ram_index + 1)
          <ram_name>[ram_index] = {RAM_WIDTH{1'b0}};
    end
  endgenerate

  always @(posedge <clka>)
    if (<ena>)
      if (<wea>)
        <ram_name>[<addra>] <= <dina>;
      else
        <ram_data> <= <ram_name>[<addra>];

  //  The following code generates HIGH_PERFORMANCE (use output register) or LOW_LATENCY (no output register)
  generate
    if (RAM_PERFORMANCE == "LOW_LATENCY") begin: no_output_register

      // The following is a 1 clock cycle read latency at the cost of a longer clock-to-out timing
       assign <douta> = <ram_data>;

    end else begin: output_register

      // The following is a 2 clock cycle read latency with improve clock-to-out timing

      reg [RAM_WIDTH-1:0] douta_reg = {RAM_WIDTH{1'b0}};

      always @(posedge <clka>)
        if (<rsta>)
          douta_reg <= {RAM_WIDTH{1'b0}};
        else if (<regcea>)
          douta_reg <= <ram_data>;

      assign <douta> = douta_reg;

    end
  endgenerate

  //  The following function calculates the address width based on specified RAM depth
  function integer clogb2;
    input integer depth;
      for (clogb2=0; depth>0; clogb2=clogb2+1)
        depth = depth >> 1;
  endfunction
						
						

  //  Xilinx Single Port Read First RAM
  //  This code implements a parameterizable single-port read-first memory where when data
  //  is written to the memory, the output reflects the prior contents of the memory location.
  //  If the output data is not needed during writes or the last read value is desired to be
  //  retained, it is suggested to set WRITE_MODE to NO_CHANGE as it is more power efficient.
  //  If a reset or enable is not necessary, it may be tied off or removed from the code.
  //  Modify the parameters for the desired RAM characteristics.

  parameter RAM_WIDTH = <width>;                  // Specify RAM data width
  parameter RAM_DEPTH = <depth>;                  // Specify RAM depth (number of entries)
  parameter RAM_PERFORMANCE = "HIGH_PERFORMANCE"; // Select "HIGH_PERFORMANCE" or "LOW_LATENCY" 
  parameter INIT_FILE = "";                       // Specify name/location of RAM initialization file if using one (leave blank if not)

  <wire_or_reg> [clogb2(RAM_DEPTH-1)-1:0] <addra>;  // Address bus, width determined from RAM_DEPTH
  <wire_or_reg> [RAM_WIDTH-1:0] <dina>;           // RAM input data
  <wire_or_reg> <clka>;                           // Clock
  <wire_or_reg> <wea>;                            // Write enable
  <wire_or_reg> <ena>;                            // RAM Enable, for additional power savings, disable port when not in use
  <wire_or_reg> <rsta>;                           // Output reset (does not affect memory contents)
  <wire_or_reg> <regcea>;                         // Output register enable
  wire [RAM_WIDTH-1:0] <douta>;                   // RAM output data

  reg [RAM_WIDTH-1:0] <ram_name> [RAM_DEPTH-1:0];
  reg [RAM_WIDTH-1:0] <ram_data> = {RAM_WIDTH{1'b0}};

  // The following code either initializes the memory values to a specified file or to all zeros to match hardware
  generate
    if (INIT_FILE != "") begin: use_init_file
      initial
        $readmemh(INIT_FILE, <ram_name>, 0, RAM_DEPTH-1);
    end else begin: init_bram_to_zero
      integer ram_index;
      initial
        for (ram_index = 0; ram_index < RAM_DEPTH; ram_index = ram_index + 1)
          <ram_name>[ram_index] = {RAM_WIDTH{1'b0}};
    end
  endgenerate

  always @(posedge <clka>)
    if (<ena>) begin
      if (<wea>)
        <ram_name>[<addra>] <= <dina>;
      <ram_data> <= <ram_name>[<addra>];
    end

  //  The following code generates HIGH_PERFORMANCE (use output register) or LOW_LATENCY (no output register)
  generate
    if (RAM_PERFORMANCE == "LOW_LATENCY") begin: no_output_register

      // The following is a 1 clock cycle read latency at the cost of a longer clock-to-out timing
       assign <douta> = <ram_data>;

    end else begin: output_register

      // The following is a 2 clock cycle read latency with improve clock-to-out timing

      reg [RAM_WIDTH-1:0] douta_reg = {RAM_WIDTH{1'b0}};

      always @(posedge <clka>)
        if (<rsta>)
          douta_reg <= {RAM_WIDTH{1'b0}};
        else if (<regcea>)
          douta_reg <= <ram_data>;

      assign <douta> = douta_reg;

    end
  endgenerate

  //  The following function calculates the address width based on specified RAM depth
  function integer clogb2;
    input integer depth;
      for (clogb2=0; depth>0; clogb2=clogb2+1)
        depth = depth >> 1;
  endfunction
						
						

  //  Xilinx Single Port Write First RAM
  //  This code implements a parameterizable single-port write-first memory where when data
  //  is written to the memory, the output reflects the same data being written to the memory.
  //  If the output data is not needed during writes or the last read value is desired to be
  //  it is suggested to use a No Change as it is more power efficient.
  //  If a reset or enable is not necessary, it may be tied off or removed from the code.
  //  Modify the parameters for the desired RAM characteristics.

  parameter RAM_WIDTH = <width>;                  // Specify RAM data width
  parameter RAM_DEPTH = <depth>;                  // Specify RAM depth (number of entries)
  parameter RAM_PERFORMANCE = "HIGH_PERFORMANCE"; // Select "HIGH_PERFORMANCE" or "LOW_LATENCY" 
  parameter INIT_FILE = "";                       // Specify name/location of RAM initialization file if using one (leave blank if not)

  <wire_or_reg> [clogb2(RAM_DEPTH-1)-1:0] <addra>;  // Address bus, width determined from RAM_DEPTH
  <wire_or_reg> [RAM_WIDTH-1:0] <dina>;           // RAM input data
  <wire_or_reg> <clka>;                           // Clock
  <wire_or_reg> <wea>;                            // Write enable
  <wire_or_reg> <ena>;                            // RAM Enable, for additional power savings, disable port when not in use
  <wire_or_reg> <rsta>; 			  // Output reset (does not affect memory contents)
  <wire_or_reg> <regcea>;                         // Output register enable
  wire [RAM_WIDTH-1:0] <douta>;                   // RAM output data

  reg [RAM_WIDTH-1:0] <ram_name> [RAM_DEPTH-1:0];
  reg [RAM_WIDTH-1:0] <ram_data> = {RAM_WIDTH{1'b0}};

  // The following code either initializes the memory values to a specified file or to all zeros to match hardware
  generate
    if (INIT_FILE != "") begin: use_init_file
      initial
        $readmemh(INIT_FILE, <ram_name>, 0, RAM_DEPTH-1);
    end else begin: init_bram_to_zero
      integer ram_index;
      initial
        for (ram_index = 0; ram_index < RAM_DEPTH; ram_index = ram_index + 1)
          <ram_name>[ram_index] = {RAM_WIDTH{1'b0}};
    end
  endgenerate

  always @(posedge <clka>)
    if (<ena>)
      if (<wea>) begin
        <ram_name>[<addra>] <= <dina>;
        <ram_data> <= <dina>;
      end else
        <ram_data> <= <ram_name>[<addra>];

  //  The following code generates HIGH_PERFORMANCE (use output register) or LOW_LATENCY (no output register)
  generate
    if (RAM_PERFORMANCE == "LOW_LATENCY") begin: no_output_register

      // The following is a 1 clock cycle read latency at the cost of a longer clock-to-out timing
       assign <douta> = <ram_data>;

    end else begin: output_register

      // The following is a 2 clock cycle read latency with improve clock-to-out timing

      reg [RAM_WIDTH-1:0] douta_reg = {RAM_WIDTH{1'b0}};

      always @(posedge <clka>)
        if (<rsta>)
          douta_reg <= {RAM_WIDTH{1'b0}};
        else if (<regcea?)
          douta_reg <= <ram_data>;

      assign <douta> = douta_reg;

    end
  endgenerate

  //  The following function calculates the address width based on specified RAM depth
  function integer clogb2;
    input integer depth;
      for (clogb2=0; depth>0; clogb2=clogb2+1)
        depth = depth >> 1;
  endfunction
						
					

//  Xilinx True Dual Port RAM No Change Single Clock
//  This code implements a parameterizable true dual port memory (both ports can read and write).
//  This is a no change RAM which retains the last read value on the output during writes
//  which is the most power efficient mode.
//  If a reset or enable is not necessary, it may be tied off or removed from the code.

  parameter RAM_WIDTH = <width>;                  // Specify RAM data width
  parameter RAM_DEPTH = <depth>;                  // Specify RAM depth (number of entries)
  parameter RAM_PERFORMANCE = "HIGH_PERFORMANCE"; // Select "HIGH_PERFORMANCE" or "LOW_LATENCY" 
  parameter INIT_FILE = "";                       // Specify name/location of RAM initialization file if using one (leave blank if not)

  <wire_or_reg> [clogb2(RAM_DEPTH-1)-1:0] <addra>;  // Port A address bus, width determined from RAM_DEPTH
  <wire_or_reg> [clogb2(RAM_DEPTH-1)-1:0] <addrb>;  // Port B address bus, width determined from RAM_DEPTH
  <wire_or_reg> [RAM_WIDTH-1:0] <dina>;           // Port A RAM input data
  <wire_or_reg> [RAM_WIDTH-1:0] <dinb>;           // Port B RAM input data
  <wire_or_reg> <clka>;                           // Clock
  <wire_or_reg> <wea>;                            // Port A write enable
  <wire_or_reg> <web>;                            // Port B write enable
  <wire_or_reg> <ena>;                            // Port A RAM Enable, for additional power savings, disable port when not in use
  <wire_or_reg> <enb>;                            // Port B RAM Enable, for additional power savings, disable port when not in use
  <wire_or_reg> <rsta>;                           // Port A output reset (does not affect memory contents)
  <wire_or_reg> <rstb>;                           // Port B output reset (does not affect memory contents)
  <wire_or_reg> <regcea>;                         // Port A output register enable
  <wire_or_reg> <regceb>;                         // Port B output register enable
  wire [RAM_WIDTH-1:0] <douta>;                   // Port A RAM output data
  wire [RAM_WIDTH-1:0] <doutb>;                   // Port B RAM output data

  reg [RAM_WIDTH-1:0] <ram_name> [RAM_DEPTH-1:0];
  reg [RAM_WIDTH-1:0] <ram_data_a> = {RAM_WIDTH{1'b0}};
  reg [RAM_WIDTH-1:0] <ram_data_b> = {RAM_WIDTH{1'b0}};

  // The following code either initializes the memory values to a specified file or to all zeros to match hardware
  generate
    if (INIT_FILE != "") begin: use_init_file
      initial
        $readmemh(INIT_FILE, <ram_name>, 0, RAM_DEPTH-1);
    end else begin: init_bram_to_zero
      integer ram_index;
      initial
        for (ram_index = 0; ram_index < RAM_DEPTH; ram_index = ram_index + 1)
          <ram_name>[ram_index] = {RAM_WIDTH{1'b0}};
    end
  endgenerate

  always @(posedge <clka>)
    if (<ena>)
      if (<wea>)
        <ram_name>[<addra>] <= <dina>;
      else
        <ram_data_a> <= <ram_name>[<addra>];

  always @(posedge <clka>)
    if (<enb>)
      if (<web>)
        <ram_name>[<addrb>] <= <dinb>;
      else
        <ram_data_b> <= <ram_name>[<addrb>];

  //  The following code generates HIGH_PERFORMANCE (use output register) or LOW_LATENCY (no output register)
  generate
    if (RAM_PERFORMANCE == "LOW_LATENCY") begin: no_output_register

      // The following is a 1 clock cycle read latency at the cost of a longer clock-to-out timing
       assign <douta> = <ram_data_a>;
       assign <doutb> = <ram_data_b>;

    end else begin: output_register

      // The following is a 2 clock cycle read latency with improve clock-to-out timing

      reg [RAM_WIDTH-1:0] douta_reg = {RAM_WIDTH{1'b0}};
      reg [RAM_WIDTH-1:0] doutb_reg = {RAM_WIDTH{1'b0}};

      always @(posedge <clka>)
        if (<rsta>)
          douta_reg <= {RAM_WIDTH{1'b0}};
        else if (<regcea>)
          douta_reg <= <ram_data_a>;

      always @(posedge <clka>)
        if (<rstb>)
          doutb_reg <= {RAM_WIDTH{1'b0}};
        else if (<regceb>)
          doutb_reg <= <ram_data_b>;

      assign <douta> = <douta_reg>;
      assign <doutb> = <doutb_reg>;

    end
  endgenerate

  //  The following function calculates the address width based on specified RAM depth
  function integer clogb2;
    input integer depth;
      for (clogb2=0; depth>0; clogb2=clogb2+1)
        depth = depth >> 1;
  endfunction
							
							

//  Xilinx True Dual Port RAM Read First Single Clock
//  This code implements a parameterizable true dual port memory (both ports can read and write).
//  The behavior of this RAM is when data is written, the prior memory contents at the write
//  address are presented on the output port.  If the output data is
//  not needed during writes or the last read value is desired to be retained,
//  it is suggested to use a no change RAM as it is more power efficient.
//  If a reset or enable is not necessary, it may be tied off or removed from the code.

  parameter RAM_WIDTH = <width>;                  // Specify RAM data width
  parameter RAM_DEPTH = <depth>;                  // Specify RAM depth (number of entries)
  parameter RAM_PERFORMANCE = "HIGH_PERFORMANCE"; // Select "HIGH_PERFORMANCE" or "LOW_LATENCY" 
  parameter INIT_FILE = "";                       // Specify name/location of RAM initialization file if using one (leave blank if not)

  <wire_or_reg> [clogb2(RAM_DEPTH-1)-1:0] <addra>;  // Port A address bus, width determined from RAM_DEPTH
  <wire_or_reg> [clogb2(RAM_DEPTH-1)-1:0] <addrb>;  // Port B address bus, width determined from RAM_DEPTH
  <wire_or_reg> [RAM_WIDTH-1:0] <dina>;           // Port A RAM input data
  <wire_or_reg> [RAM_WIDTH-1:0] <dinb>;           // Port B RAM input data
  <wire_or_reg> <clka>;                           // Clock
  <wire_or_reg> <wea>;                            // Port A write enable
  <wire_or_reg> <web>;                            // Port B write enable
  <wire_or_reg> <ena>;                            // Port A RAM Enable, for additional power savings, disable port when not in use
  <wire_or_reg> <enb>;                            // Port B RAM Enable, for additional power savings, disable port when not in use
  <wire_or_reg> <rsta>;                           // Port A output reset (does not affect memory contents)
  <wire_or_reg> <rstb>;                           // Port B output reset (does not affect memory contents)
  <wire_or_reg> <regcea>;                         // Port A output register enable
  <wire_or_reg> <regceb>;                         // Port B output register enable
  wire [RAM_WIDTH-1:0] <douta>;                   // Port A RAM output data
  wire [RAM_WIDTH-1:0] <doutb>;                   // Port B RAM output data

  reg [RAM_WIDTH-1:0] <ram_name> [RAM_DEPTH-1:0];
  reg [RAM_WIDTH-1:0] <ram_data_a> = {RAM_WIDTH{1'b0}};
  reg [RAM_WIDTH-1:0] <ram_data_b> = {RAM_WIDTH{1'b0}};

  // The following code either initializes the memory values to a specified file or to all zeros to match hardware
  generate
    if (INIT_FILE != "") begin: use_init_file
      initial
        $readmemh(INIT_FILE, <ram_name>, 0, RAM_DEPTH-1);
    end else begin: init_bram_to_zero
      integer ram_index;
      initial
        for (ram_index = 0; ram_index < RAM_DEPTH; ram_index = ram_index + 1)
          <ram_name>[ram_index] = {RAM_WIDTH{1'b0}};
    end
  endgenerate

  always @(posedge <clka>)
    if (<ena>) begin
      if (<wea>)
        <ram_name>[<addra>] <= <dina>;
      <ram_data_a> <= <ram_name>[<addra>];
    end

  always @(posedge <clka>)
    if (<enb>) begin
      if (<web>)
        <ram_name>[<addrb>] <= <dinb>;
      <ram_data_b> <= <ram_name>[<addrb>];
    end

  //  The following code generates HIGH_PERFORMANCE (use output register) or LOW_LATENCY (no output register)
  generate
    if (RAM_PERFORMANCE == "LOW_LATENCY") begin: no_output_register

      // The following is a 1 clock cycle read latency at the cost of a longer clock-to-out timing
       assign <douta> = <ram_data_a>;
       assign <doutb> = <ram_data_b>;

    end else begin: output_register

      // The following is a 2 clock cycle read latency with improve clock-to-out timing

      reg [RAM_WIDTH-1:0] douta_reg = {RAM_WIDTH{1'b0}};
      reg [RAM_WIDTH-1:0] doutb_reg = {RAM_WIDTH{1'b0}};

      always @(posedge <clka>)
        if (<rsta>)
          douta_reg <= {RAM_WIDTH{1'b0}};
        else if (<regcea>)
          douta_reg <= <ram_data_a>;

      always @(posedge <clka>)
        if (<rstb>)
          doutb_reg <= {RAM_WIDTH{1'b0}};
        else if (<regceb>)
          doutb_reg <= <ram_data_b>;

      assign <douta> = <douta_reg>;
      assign <doutb> = <doutb_reg>;

    end
  endgenerate

  //  The following function calculates the address width based on specified RAM depth
  function integer clogb2;
    input integer depth;
      for (clogb2=0; depth>0; clogb2=clogb2+1)
        depth = depth >> 1;
  endfunction
							
							

//  Xilinx True Dual Port RAM Byte Write Read First Single Clock RAM
//  This code implements a parameterizable true dual port memory (both ports can read and write).
//  The behavior of this RAM is when data is written, the prior memory contents at the write
//  address are presented on the output port.

  parameter NB_COL = <col>;                       // Specify number of columns (number of bytes)
  parameter COL_WIDTH = <width>;                  // Specify column width (byte width, typically 8 or 9)
  parameter RAM_DEPTH = <depth>;                  // Specify RAM depth (number of entries)
  parameter RAM_PERFORMANCE = "HIGH_PERFORMANCE"; // Select "HIGH_PERFORMANCE" or "LOW_LATENCY" 
  parameter INIT_FILE = "";                       // Specify name/location of RAM initialization file if using one (leave blank if not)

  <wire_or_reg> [clogb2(RAM_DEPTH-1)-1:0] <addra>;   // Port A address bus, width determined from RAM_DEPTH
  <wire_or_reg> [clogb2(RAM_DEPTH-1)-1:0] <addrb>;   // Port B address bus, width determined from RAM_DEPTH
  <wire_or_reg> [(NB_COL*COL_WIDTH)-1:0] <dina>;   // Port A RAM input data
  <wire_or_reg> [(NB_COL*COL_WIDTH)-1:0] <dinb>;   // Port B RAM input data
  <wire_or_reg> <clka>;                            // Clock
  <wire_or_reg> [NB_COL-1:0] <wea>;                // Port A write enable
  <wire_or_reg> [NB_COL-1:0] <web>;                // Port B write enable
  <wire_or_reg> <ena>;                             // Port A RAM Enable, for additional power savings, disable port when not in use
  <wire_or_reg> <enb>;                             // Port B RAM Enable, for additional power savings, disable port when not in use
  <wire_or_reg> <rsta>;				 // Port A output reset (does not affect memory contents)
  <wire_or_reg> <rstb>;                            // Port B output reset (does not affect memory contents)
  <wire_or_reg> <regcea>;                          // Port A output register enable
  <wire_or_reg> <regceb>;                          // Port B output register enable
  wire [(NB_COL*COL_WIDTH)-1:0] <douta>; // Port A RAM output data
  wire [(NB_COL*COL_WIDTH)-1:0] <doutb>; // Port B RAM output data

  reg [(NB_COL*COL_WIDTH)-1:0] <ram_name> [RAM_DEPTH-1:0];
  reg [(NB_COL*COL_WIDTH)-1:0] <ram_data_a> = {(NB_COL*COL_WIDTH){1'b0}};
  reg [(NB_COL*COL_WIDTH)-1:0] <ram_data_b> = {(NB_COL*COL_WIDTH){1'b0}};

  // The following code either initializes the memory values to a specified file or to all zeros to match hardware
  generate
    if (INIT_FILE != "") begin: use_init_file
      initial
        $readmemh(INIT_FILE, <ram_name>, 0, RAM_DEPTH-1);
    end else begin: init_bram_to_zero
      integer ram_index;
      initial
        for (ram_index = 0; ram_index < RAM_DEPTH; ram_index = ram_index + 1)
          <ram_name>[ram_index] = {(NB_COL*COL_WIDTH){1'b0}};
    end
  endgenerate

  always @(posedge <clka>)
    if (<ena>) begin
      <ram_data_a> <= <ram_name>[<addra>];
    end

  always @(posedge <clka>)
    if (<enb>) begin
      <ram_data_b> <= <ram_name>[<addrb>];
    end

  generate
  genvar i;
     for (i = 0; i < NB_COL; i = i+1) begin: byte_write
       always @(posedge <clka>)
         if (<ena>)
           if (<wea>[i])
             <ram_name>[<addra>][(i+1)*COL_WIDTH-1:i*COL_WIDTH] <= <dina>[(i+1)*COL_WIDTH-1:i*COL_WIDTH];
       always @(posedge <clka>)
         if (<enb>)
           if (<web>[i])
             <ram_name>[<addrb>][(i+1)*COL_WIDTH-1:i*COL_WIDTH] <= <dinb>[(i+1)*COL_WIDTH-1:i*COL_WIDTH];
end
  endgenerate

  //  The following code generates HIGH_PERFORMANCE (use output register) or LOW_LATENCY (no output register)
  generate
    if (RAM_PERFORMANCE == "LOW_LATENCY") begin: no_output_register

      // The following is a 1 clock cycle read latency at the cost of a longer clock-to-out timing
       assign <douta> = <ram_data_a>;
       assign <doutb> = <ram_data_b>;

    end else begin: output_register

      // The following is a 2 clock cycle read latency with improve clock-to-out timing

      reg [(NB_COL*COL_WIDTH)-1:0] douta_reg = {(NB_COL*COL_WIDTH){1'b0}};
      reg [(NB_COL*COL_WIDTH)-1:0] doutb_reg = {(NB_COL*COL_WIDTH){1'b0}};

      always @(posedge <clka>)
        if (<rsta>)
          douta_reg <= {(NB_COL*COL_WIDTH){1'b0}};
        else if (<regcea>)
          douta_reg <= <ram_data_a>;

      always @(posedge <clka>)
        if (<rstb>)
          doutb_reg <= {(NB_COL*COL_WIDTH){1'b0}};
        else if (<regceb>)
          doutb_reg <= <ram_data_b>;

      assign <douta> = douta_reg;
      assign <doutb> = doutb_reg;

    end
  endgenerate

  //  The following function calculates the address width based on specified RAM depth
  function integer clogb2;
    input integer depth;
      for (clogb2=0; depth>0; clogb2=clogb2+1)
        depth = depth >> 1;
  endfunction
							
							

//  Xilinx True Dual Port RAM Write First Single Clock
//  This code implements a parameterizable true dual port memory (both ports can read and write).
//  This implements write-first mode where the data being written to the RAM also resides on
//  the output port.  If the output data is not needed during writes or the last read value is
//  desired to be retained, it is suggested to use no change as it is more power efficient.
//  If a reset or enable is not necessary, it may be tied off or removed from the code.

  parameter RAM_WIDTH = <width>;                  // Specify RAM data width
  parameter RAM_DEPTH = <depth>;                  // Specify RAM depth (number of entries)
  parameter RAM_PERFORMANCE = "HIGH_PERFORMANCE"; // Select "HIGH_PERFORMANCE" or "LOW_LATENCY" 
  parameter INIT_FILE = "";                       // Specify name/location of RAM initialization file if using one (leave blank if not)

  <wire_or_reg> [clogb2(RAM_DEPTH-1)-1:0] <addra>;  // Port A address bus, width determined from RAM_DEPTH
  <wire_or_reg> [clogb2(RAM_DEPTH-1)-1:0] <addrb>;  // Port B address bus, width determined from RAM_DEPTH
  <wire_or_reg> [RAM_WIDTH-1:0] <dina>;           // Port A RAM input data
  <wire_or_reg> [RAM_WIDTH-1:0] <dinb>;           // Port B RAM input data
  <wire_or_reg> <clka>;                           // Clock
  <wire_or_reg> <wea>;                            // Port A write enable
  <wire_or_reg> <web>;                            // Port B write enable
  <wire_or_reg> <ena>;                            // Port A RAM Enable, for additional power savings, disable port when not in use
  <wire_or_reg> <enb>;                            // Port B RAM Enable, for additional power savings, disable port when not in use
  <wire_or_reg> <rsta>;                           // Port A output reset (does not affect memory contents)
  <wire_or_reg> <rstb>;                           // Port B output reset (does not affect memory contents)
  <wire_or_reg> <regcea>;                         // Port A output register enable
  <wire_or_reg> <regceb>;                         // Port B output register enable
  wire [RAM_WIDTH-1:0] <douta>;                   // Port A RAM output data
  wire [RAM_WIDTH-1:0] <doutb>;                   // Port B RAM output data

  reg [RAM_WIDTH-1:0] <ram_name> [RAM_DEPTH-1:0];
  reg [RAM_WIDTH-1:0] <ram_data_a> = {RAM_WIDTH{1'b0}};
  reg [RAM_WIDTH-1:0] <ram_data_b> = {RAM_WIDTH{1'b0}};

  // The following code either initializes the memory values to a specified file or to all zeros to match hardware
  generate
    if (INIT_FILE != "") begin: use_init_file
      initial
        $readmemh(INIT_FILE, <ram_name>, 0, RAM_DEPTH-1);
    end else begin: init_bram_to_zero
      integer ram_index;
      initial
        for (ram_index = 0; ram_index < RAM_DEPTH; ram_index = ram_index + 1)
          <ram_name>[ram_index] = {RAM_WIDTH{1'b0}};
    end
  endgenerate

  always @(posedge <clka>)
    if (<ena>)
      if (<wea>) begin
        <ram_name>[<addra>] <= <dina>;
        <ram_data_a> <= <dina>;
      end else
        <ram_data_a> <= <ram_name>[<addra>];

  always @(posedge <clka>)
    if (<enb>)
      if (<web>) begin
        <ram_name>[<addrb>] <= <dinb>;
        <ram_data_b> <= <dinb>;
      end else
        <ram_data_b> <= <ram_name>[<addrb>];

  //  The following code generates HIGH_PERFORMANCE (use output register) or LOW_LATENCY (no output register)
  generate
    if (RAM_PERFORMANCE == "LOW_LATENCY") begin: no_output_register

      // The following is a 1 clock cycle read latency at the cost of a longer clock-to-out timing
       assign <douta> = <ram_data_a>;
       assign <doutb> = <ram_data_b>;

    end else begin: output_register

      // The following is a 2 clock cycle read latency with improve clock-to-out timing

      reg [RAM_WIDTH-1:0] douta_reg = {RAM_WIDTH{1'b0}};
      reg [RAM_WIDTH-1:0] doutb_reg = {RAM_WIDTH{1'b0}};

      always @(posedge <clka>)
        if (<rsta>)
          douta_reg <= {RAM_WIDTH{1'b0}};
        else if (<regcea>)
          douta_reg <= <ram_data_a>;

      always @(posedge <clka>)
        if (<rstb>)
          doutb_reg <= {RAM_WIDTH{1'b0}};
        else if (<regceb>)
          doutb_reg <= <ram_data_b>;

      assign <douta> = <douta_reg>;
      assign <doutb> = <doutb_reg>;

    end
  endgenerate

  //  The following function calculates the address width based on specified RAM depth
  function integer clogb2;
    input integer depth;
      for (clogb2=0; depth>0; clogb2=clogb2+1)
        depth = depth >> 1;
  endfunction
							
							

//  Xilinx True Dual Port RAM Byte Write, Write First Single Clock RAM
//  This code implements a parameterizable true dual port memory (both ports can read and write).
//  The behavior of this RAM is when data is written, the new memory contents at the write
//  address are presented on the output port.

  parameter NB_COL = <col>;                       // Specify number of columns (number of bytes)
  parameter COL_WIDTH = <width>;                  // Specify column width (byte width, typically 8 or 9)
  parameter RAM_DEPTH = <depth>;                  // Specify RAM depth (number of entries)
  parameter RAM_PERFORMANCE = "HIGH_PERFORMANCE"; // Select "HIGH_PERFORMANCE" or "LOW_LATENCY" 
  parameter INIT_FILE = "";                       // Specify name/location of RAM initialization file if using one (leave blank if not)

  <wire_or_reg> [clogb2(RAM_DEPTH-1)-1:0] <addra>;  // Port A address bus, width determined from RAM_DEPTH
  <wire_or_reg> [clogb2(RAM_DEPTH-1)-1:0] <addrb>;  // Port B address bus, width determined from RAM_DEPTH
  <wire_or_reg> [(NB_COL*COL_WIDTH)-1:0] <dina>;  // Port A RAM input data
  <wire_or_reg> [(NB_COL*COL_WIDTH)-1:0] <dinb>;  // Port B RAM input data
  <wire_or_reg> <clka>;                           // Clock
  <wire_or_reg> [NB_COL-1:0] <wea>;               // Port A write enable
  <wire_or_reg> [NB_COL-1:0] <web>;		  // Port B write enable
  <wire_or_reg> <ena>;                            // Port A RAM Enable, for additional power savings, disable BRAM when not in use
  <wire_or_reg> <enb>;                            // Port B RAM Enable, for additional power savings, disable BRAM when not in use
  <wire_or_reg> <rsta>;                           // Port A output reset (does not affect memory contents)
  <wire_or_reg> <rstb>;                           // Port B output reset (does not affect memory contents)
  <wire_or_reg> <regcea>;                         // Port A output register enable
  <wire_or_reg> <regceb>;                         // Port B output register enable
  wire [(NB_COL*COL_WIDTH)-1:0] <douta>; // Port A RAM output data
  wire [(NB_COL*COL_WIDTH)-1:0] <doutb>; // Port B RAM output data

  reg [(NB_COL*COL_WIDTH)-1:0] <ram_name> [RAM_DEPTH-1:0];
  reg [(NB_COL*COL_WIDTH)-1:0] <ram_data_a> = {(NB_COL*COL_WIDTH){1'b0}};
  reg [(NB_COL*COL_WIDTH)-1:0] <ram_data_b> = {(NB_COL*COL_WIDTH){1'b0}};

  // The following code either initializes the memory values to a specified file or to all zeros to match hardware
  generate
    if (INIT_FILE != "") begin: use_init_file
      initial
        $readmemh(INIT_FILE, <ram_name>, 0, RAM_DEPTH-1);
    end else begin: init_bram_to_zero
      integer ram_index;
      initial
        for (ram_index = 0; ram_index < RAM_DEPTH; ram_index = ram_index + 1)
          <ram_name>[ram_index] = {(NB_COL*COL_WIDTH){1'b0}};
    end
  endgenerate

  generate
  genvar i;
     for (i = 0; i < NB_COL; i = i+1) begin: byte_write
       always @(posedge <clka>)
         if (<ena>)
           if (<wea>[i]) begin
             <ram_name>[<addra>][(i+1)*COL_WIDTH-1:i*COL_WIDTH] <= <dina>[(i+1)*COL_WIDTH-1:i*COL_WIDTH];
             <ram_data_a>[(i+1)*COL_WIDTH-1:i*COL_WIDTH] <= <dina>[(i+1)*COL_WIDTH-1:i*COL_WIDTH];
           end else begin
             <ram_data_a>[(i+1)*COL_WIDTH-1:i*COL_WIDTH] <= <ram_name>[<addra>][(i+1)*COL_WIDTH-1:i*COL_WIDTH];
           end

       always @(posedge <clka>)
         if (<enb>)
           if (<web>[i]) begin
             <ram_name>[<addrb>][(i+1)*COL_WIDTH-1:i*COL_WIDTH] <= <dinb>[(i+1)*COL_WIDTH-1:i*COL_WIDTH];
             <ram_data_b>[(i+1)*COL_WIDTH-1:i*COL_WIDTH] <= <dinb>[(i+1)*COL_WIDTH-1:i*COL_WIDTH];
           end else begin
             <ram_data_b>[(i+1)*COL_WIDTH-1:i*COL_WIDTH] <= <ram_name>[addrb][(i+1)*COL_WIDTH-1:i*COL_WIDTH];
           end
     end
  endgenerate

  //  The following code generates HIGH_PERFORMANCE (use output register) or LOW_LATENCY (no output register)
  generate
    if (RAM_PERFORMANCE == "LOW_LATENCY") begin: no_output_register

      // The following is a 1 clock cycle read latency at the cost of a longer clock-to-out timing
       assign <douta> = <ram_data_a>;
       assign <doutb> = <ram_data_b>;

    end else begin: output_register

      // The following is a 2 clock cycle read latency with improve clock-to-out timing

      reg [(NB_COL*COL_WIDTH)-1:0] douta_reg = {(NB_COL*COL_WIDTH){1'b0}};
      reg [(NB_COL*COL_WIDTH)-1:0] doutb_reg = {(NB_COL*COL_WIDTH){1'b0}};

      always @(posedge <clka>)
        if (<rsta>)
          douta_reg <= {(NB_COL*COL_WIDTH){1'b0}};
        else if (regcea)
          douta_reg <= <ram_data_a>;

      always @(posedge <clka>)
        if (<rstb>)
          doutb_reg <= {(NB_COL*COL_WIDTH){1'b0}};
        else if (<regceb>)
          doutb_reg <= <ram_data_b>;

      assign <douta> = douta_reg;
      assign <doutb> = doutb_reg;

    end
  endgenerate

  //  The following function calculates the address width based on specified RAM depth
  function integer clogb2;
    input integer depth;
      for (clogb2=0; depth>0; clogb2=clogb2+1)
        depth = depth >> 1;
  endfunction
							
  // Distributed RAM
  parameter RAM_WIDTH = <ram_width>;
  parameter RAM_ADDR_BITS = <ram_addr_bits>;

  (* ram_style="distributed" *)
  reg [RAM_WIDTH-1:0] <ram_name> [(2**RAM_ADDR_BITS)-1:0];

  wire [RAM_WIDTH-1:0] <output_data>;

  <reg_or_wire> [RAM_ADDR_BITS-1:0] <read_address>, <write_address>;
  <reg_or_wire> [RAM_WIDTH-1:0] <input_data>;

  always @(posedge <clock>)
     if (<write_enable>)
        <ram_name>[<write_address>] <= <input_data>;

  assign <output_data> = <ram_name>[<read_address>];
                   
               

//  Xilinx UltraRAM Simple Dual Port.  This code implements 
//  a parameterizable UltraRAM block with 1 Read and 1 write
//  when addra == addrb, old data will show at doutb 
  parameter AWIDTH = 12;  // Address Width
  parameter DWIDTH = 72;  // Data Width
  parameter NBPIPE = 3;   // Number of pipeline Registers
  <wire_or_reg> <clk>;                    // Clock 
  <wire_or_reg> <wea>;                    // Write Enable
  <wire_or_reg> <mem_en>;                 // Memory Enable
  <wire_or_reg> [DWIDTH-1:0] <dina>;      // Data <wire_or_reg>  
  <wire_or_reg> [AWIDTH-1:0] <addra>;     // Write Address
  <wire_or_reg> [AWIDTH-1:0] <addrb>;     // Read  Address
  reg [DWIDTH-1:0] <doutb>; // Data Output
  
  (* ram_style = "ultra" *)
  reg [DWIDTH-1:0] <mem>[(1<<AWIDTH)-1:0];        // Memory Declaration
  reg [DWIDTH-1:0] <memreg>;              
  reg [DWIDTH-1:0] <mem_pipe_reg>[NBPIPE-1:0];    // Pipelines for memory
  reg <mem_en_pipe_reg>[NBPIPE:0];                // Pipelines for memory enable  
  
  integer          i;
  
  // RAM : Both READ and WRITE have a latency of one
  always @ (posedge <clk>)
  begin
   if(<mem_en>) 
    begin
     if(<wea>)
       <mem>[<addra>] <= <dina>;
  
     <memreg> <= <mem>[<addrb>];
    end
  end
  
  // The enable of the RAM goes through a pipeline to produce a
  // series of pipelined enable signals required to control the data
  // pipeline.
  always @ (posedge <clk>)
  begin
   <mem_en_pipe_reg>[0] <= <mem_en>;
   for (i=0; i<NBPIPE; i=i+1)
     <mem_en_pipe_reg>[i+1] <= <mem_en_pipe_reg>[i];
  end
  
  // RAM output data goes through a pipeline.
  always @ (posedge <clk>)
  begin
   if (<mem_en_pipe_reg>[0])
    <mem_pipe_reg>[0] <= <memreg>;
  end    
  
  always @ (posedge <clk>)
  begin
   for (i = 0; i < NBPIPE-1; i = i+1)
    if (<mem_en_pipe_reg>[i+1])
     <mem_pipe_reg>[i+1] <= <mem_pipe_reg>[i];
  end      
  
  always @ (posedge <clk>)
  begin
   if (<mem_en_pipe_reg>[NBPIPE])
     <doutb> <= <mem_pipe_reg>[NBPIPE-1];
  end
  
                      

//  Xilinx UltraRAM Single Port No Change Mode.  This code implements 
//  a parameterizable UltraRAM block in No Change mode. The behavior of this RAM is 
//  when data is written, the output of RAM is unchanged. Only when write is
//  inactive data corresponding to the address is presented on the output port.

  parameter AWIDTH = 12;  // Address Width
  parameter DWIDTH = 72;  // Data Width
  parameter NBPIPE = 3;   // Number of pipeline Registers
  <wire_or_reg> <clk>;                    // Clock 
  <wire_or_reg> <we>;                     // Write Enable
  <wire_or_reg> <mem_en>;                 // Memory Enable
  <wire_or_reg> [DWIDTH-1:0] <din>;       // Data Input  
  <wire_or_reg> [AWIDTH-1:0] <addr>;      // Address Input
  reg [DWIDTH-1:0] <dout>;                // Data Output
  
  (* ram_style = "ultra" *)
  reg [DWIDTH-1:0] <mem>[(1<<AWIDTH)-1:0];        // Memory Declaration
  reg [DWIDTH-1:0] <memreg>;              
  reg [DWIDTH-1:0] <mem_pipe_reg>[NBPIPE-1:0];    // Pipelines for memory
  reg <mem_en_pipe_reg>[NBPIPE:0];                // Pipelines for memory enable  
  
  integer          i;
  
  // RAM : Both READ and WRITE have a latency of one
  always @ (posedge <clk>)
  begin
   if(<mem_en>) 
    begin
     if(<we>)
      <mem>[<addr>] <= <din>;
     else
      <memreg> <= <mem>[<addr>];
    end
  end
  
  // The enable of the RAM goes through a pipeline to produce a
  // series of pipelined enable signals required to control the data
  // pipeline.
  always @ (posedge <clk>)
  begin
   <mem_en_pipe_reg>[0] <= <mem_en>;
   for (i=0; i<NBPIPE; i=i+1)
     <mem_en_pipe_reg>[i+1] <= <mem_en_pipe_reg>[i];
  end
  
  // RAM output data goes through a pipeline.
  always @ (posedge <clk>)
  begin
   if (<mem_en_pipe_reg>[0])
    <mem_pipe_reg>[0] <= <memreg>;
  end    
  
  always @ (posedge <clk>)
  begin
   for (i = 0; i < NBPIPE-1; i = i+1)
    if (<mem_en_pipe_reg>[i+1])
     <mem_pipe_reg>[i+1] <= <mem_pipe_reg>[i];
  end      
  
  always @ (posedge <clk>)
  begin
   if (<mem_en_pipe_reg>[NBPIPE] )
     <dout> <= <mem_pipe_reg>[NBPIPE-1];
  end
                          
                                                

//  Xilinx UltraRAM Single Port Read First Mode.  This code implements 
//  a parameterizable UltraRAM block in read first mode. The behavior of this RAM is 
//  when data is written, the old memory contents at the write address are 
//  presented on the output port.
//
  parameter AWIDTH = 12;  // Address Width
  parameter DWIDTH = 72;  // Data Width
  parameter NBPIPE = 3;   // Number of pipeline Registers
  <wire_or_reg> <clk>;                    // Clock 
  <wire_or_reg> <we>;                     // Write Enable
  <wire_or_reg> <mem_en>;                 // Memory Enable
  <wire_or_reg> [DWIDTH-1:0] <din>;       // Data Input  
  <wire_or_reg> [AWIDTH-1:0] <addr>;      // Address Input
  reg [DWIDTH-1:0] <dout>;                // Data Output
  
  (* ram_style = "ultra" *)
  reg [DWIDTH-1:0] <mem>[(1<<AWIDTH)-1:0];        // Memory Declaration
  reg [DWIDTH-1:0] <memreg>;              
  reg [DWIDTH-1:0] <mem_pipe_reg>[NBPIPE-1:0];    // Pipelines for memory
  reg <mem_en_pipe_reg>[NBPIPE:0];                // Pipelines for memory enable  
  
  integer          i;
  
  // RAM : Both READ and WRITE have a latency of one
  always @ (posedge <clk>)
  begin
   if(<mem_en>) 
    begin
     if(<we>)
      <mem>[<addr>] <= <din>;
     <memreg> <= <mem>[<addr>];
    end
  end
  
  // The enable of the RAM goes through a pipeline to produce a
  // series of pipelined enable signals required to control the data
  // pipeline.
  always @ (posedge <clk>)
  begin
   <mem_en_pipe_reg>[0] <= <mem_en>;
   for (i=0; i<NBPIPE; i=i+1)
     <mem_en_pipe_reg>[i+1] <= <mem_en_pipe_reg>[i];
  end
  
  // RAM output data goes through a pipeline.
  always @ (posedge <clk>)
  begin
   if (<mem_en_pipe_reg>[0])
    <mem_pipe_reg>[0] <= <memreg>;
  end    
  
  always @ (posedge <clk>)
  begin
   for (i = 0; i < NBPIPE-1; i = i+1)
    if (<mem_en_pipe_reg>[i+1])
     <mem_pipe_reg>[i+1] <= <mem_pipe_reg>[i];
  end      
  
  always @ (posedge <clk>)
  begin
   if (<mem_en_pipe_reg>[NBPIPE])
     <dout> <= <mem_pipe_reg>[NBPIPE-1];
  end
                          
                          

//  Xilinx UltraRAM Single Port Write First Mode.  This code implements 
//  a parameterizable UltraRAM block in write first mode. The behavior of this RAM is 
//  when data is written, the new memory contents at the write address are 
//  presented on the output port.
//
  parameter AWIDTH = 12;  // Address Width
  parameter DWIDTH = 72;  // Data Width
  parameter NBPIPE = 3;   // Number of pipeline Registers
  <wire_or_reg> <clk>;                    // Clock 
  <wire_or_reg> <we>;                     // Write Enable
  <wire_or_reg> <mem_en>;                 // Memory Enable
  <wire_or_reg> [DWIDTH-1:0] <din>;       // Data Input  
  <wire_or_reg> [AWIDTH-1:0] <addr>;      // Address Input
  reg [DWIDTH-1:0] <dout>;                // Data Output
  
  (* ram_style = "ultra" *)
  reg [DWIDTH-1:0] <mem>[(1<<AWIDTH)-1:0];        // Memory Declaration
  reg [DWIDTH-1:0] <memreg>;              
  reg [DWIDTH-1:0] <mem_pipe_reg>[NBPIPE-1:0];    // Pipelines for memory
  reg <mem_en_pipe_reg>[NBPIPE:0];                // Pipelines for memory enable  
  
  integer          i;
  
  // RAM : Both READ and WRITE have a latency of one
  always @ (posedge <clk>)
  begin
   if(<mem_en>) 
    begin
     if(<we>)
      begin
       <mem>[<addr>] <= <din>;
       <memreg> <= <din>;
      end
     else
      <memreg> <= <mem>[<addr>];
    end
  end
  
  // The enable of the RAM goes through a pipeline to produce a
  // series of pipelined enable signals required to control the data
  // pipeline.
  always @ (posedge <clk>)
  begin
   <mem_en_pipe_reg>[0] <= <mem_en>;
   for (i=0; i<NBPIPE; i=i+1)
     <mem_en_pipe_reg>[i+1] <= <mem_en_pipe_reg>[i];
  end
  
  // RAM output data goes through a pipeline.
  always @ (posedge <clk>)
  begin
   if (<mem_en_pipe_reg>[0])
    <mem_pipe_reg>[0] <= <memreg>;
  end    
  
  always @ (posedge <clk>)
  begin
   for (i = 0; i < NBPIPE-1; i = i+1)
    if (<mem_en_pipe_reg>[i+1])
     <mem_pipe_reg>[i+1] <= <mem_pipe_reg>[i];
  end      
  
  always @ (posedge <clk>)
  begin
   if (<mem_en_pipe_reg>[NBPIPE] )
     <dout> <= <mem_pipe_reg>[NBPIPE-1];
  end
                          
     

//  Xilinx UltraRAM True Dual Port Mode - Byte write.  This code implements 
//  a parameterizable UltraRAM block with write/read on both ports in 
//  No change behavior on both the ports . The behavior of this RAM is 
//  when data is written, the output of RAM is unchanged w.r.t each port. 
//  Only when write is inactive data corresponding to the address is 
//  presented on the output port.
//

  parameter AWIDTH = 12;  // Address Width
  parameter DWIDTH = 72;  // Data Width
  parameter NUM_COL = 9;   // Number of columns
  parameter DWIDTH  = 72;  // Data Width, (Byte * NUM_COL) 
  
  parameter NBPIPE = 3;   // Number of pipeline Registers
  
  <wire_or_reg> <clk>;                     // Clock 
  // Port A
  <wire_or_reg> [NUM_COL-1:0] <wea>;       // Write Enable
  <wire_or_reg> <mem_ena>;                 // Memory Enable
  <wire_or_reg> [DWIDTH-1:0] <dina>;       // Data Input 
  <wire_or_reg> [AWIDTH-1:0] <addra>;      // Address Input
  reg [DWIDTH-1:0] <douta>;                // Data Output
  
  // Port B
  <wire_or_reg> [NUM_COL-1:0] <web>;       // Write Enable
  <wire_or_reg> <mem_enb>;                 // Memory Enable
  <wire_or_reg> [DWIDTH-1:0] <dinb>;       // Data Input 
  <wire_or_reg> [AWIDTH-1:0] <addrb>;      // Address Input
  reg [DWIDTH-1:0] <doutb>;                // Data Output
  
  (* ram_style = "ultra" *)
  reg [DWIDTH-1:0] <mem>[(1<<AWIDTH)-1:0];        // Memory Declaration
  
  reg [DWIDTH-1:0] <memrega>;              
  reg [DWIDTH-1:0] <mem_pipe_rega>[NBPIPE-1:0];    // Pipelines for memory
  reg <mem_en_pipe_rega>[NBPIPE:0];                // Pipelines for memory enable  
  
  reg [DWIDTH-1:0] <memregb>;              
  reg [DWIDTH-1:0] <mem_pipe_regb>[NBPIPE-1:0];    // Pipelines for memory
  reg <mem_en_pipe_regb>[NBPIPE:0];                // Pipelines for memory enable  
  integer          i;
  
  // RAM : Both READ and WRITE have a latency of one
  always @ (posedge <clk>)
  begin
   if(<mem_ena>) 
    begin
     for(i = 0;i<NUM_COL;i=i+1) 
       if(<wea>[i])
      <mem>[<addra>][i*CWIDTH +: CWIDTH] <= <dina>[i*CWIDTH +: CWIDTH];
   end
  end
  
  always @ (posedge <clk>)
  begin
   if(<mem_ena>)
    if(~|<wea>)
      <memrega> <= <mem>[<addra>];
  end
  
  // The enable of the RAM goes through a pipeline to produce a
  // series of pipelined enable signals required to control the data
  // pipeline.
  always @ (posedge <clk>)
  begin
   <mem_en_pipe_rega>[0] <= <mem_ena>;
   for (i=0; i<NBPIPE; i=i+1)
     <mem_en_pipe_rega>[i+1] <= <mem_en_pipe_rega>[i];
  end
  
  // RAM output data goes through a pipeline.
  always @ (posedge <clk>)
  begin
   if (<mem_en_pipe_rega>[0])
    <mem_pipe_rega>[0] <= <memrega>;
  end    
  
  always @ (posedge <clk>)
  begin
   for (i = 0; i < NBPIPE-1; i = i+1)
    if (<mem_en_pipe_rega>[i+1])
     <mem_pipe_rega>[i+1] <= <mem_pipe_rega>[i];
  end      
  
  always @ (posedge <clk>)
  begin
   if (<mem_en_pipe_rega>[NBPIPE]) 
     <douta> <= <mem_pipe_rega>[NBPIPE-1];
  end
  
  always @ (posedge <clk>)
  begin
   if(<mem_enb>) 
    begin
     for(i = 0;i<NUM_COL;i=i+1) 
       if(<web>[i])
      <mem>[<addrb>][i*CWIDTH +: CWIDTH] <= <dinb>[i*CWIDTH +: CWIDTH];
   end
  end
  
  always @ (posedge <clk>)
  begin
   if(<mem_enb>)
    if(~|<web>)
      <memregb> <= <mem>[<addrb>];
  end
  
  // The enable of the RAM goes through a pipeline to produce a
  // series of pipelined enable signals required to control the data
  // pipeline.
  always @ (posedge <clk>)
  begin
   <mem_en_pipe_regb>[0] <= <mem_enb>;
   for (i=0; i<NBPIPE; i=i+1)
     <mem_en_pipe_regb>[i+1] <= <mem_en_pipe_regb>[i];
  end
  
  // RAM output data goes through a pipeline.
  always @ (posedge <clk>)
  begin
   if (<mem_en_pipe_regb>[0])
    <mem_pipe_regb>[0] <= <memregb>;
  end    
  
  always @ (posedge <clk>)
  begin
   for (i = 0; i < NBPIPE-1; i = i+1)
    if (<mem_en_pipe_regb>[i+1])
     <mem_pipe_regb>[i+1] <= <mem_pipe_regb>[i];
  end      
  
  always @ (posedge <clk>)
  begin
   if (<mem_en_pipe_regb>[NBPIPE])
     <doutb> <= <mem_pipe_regb>[NBPIPE-1];
  end
                          
                          

//  Xilinx UltraRAM True Dual Port Mode.  This code implements 
//  a parameterizable UltraRAM block with write/read on both ports in 
//  No change behavior on both the ports . The behavior of this RAM is 
//  when data is written, the output of RAM is unchanged w.r.t each port. 
//  Only when write is inactive data corresponding to the address is 
//  presented on the output port.
//

  parameter AWIDTH = 12;  // Address Width
  parameter DWIDTH = 72;  // Data Width
  parameter NBPIPE = 3;   // Number of pipeline Registers
  
  <wire_or_reg> <clk>;                    // Clock 
  // Port A
  <wire_or_reg> <wea>;                     // Write Enable
  <wire_or_reg> <mem_ena>;                 // Memory Enable
  <wire_or_reg> [DWIDTH-1:0] <dina>;       // Data Input 
  <wire_or_reg> [AWIDTH-1:0] <addra>;      // Address Input
  reg [DWIDTH-1:0] <douta>;                // Data Output
  
  // Port B
  <wire_or_reg> <web>;                     // Write Enable
  <wire_or_reg> <mem_enb>;                 // Memory Enable
  <wire_or_reg> [DWIDTH-1:0] <dinb>;       // Data Input 
  <wire_or_reg> [AWIDTH-1:0] <addrb>;      // Address Input
  reg [DWIDTH-1:0] <doutb>;                // Data Output
  
  (* ram_style = "ultra" *)
  reg [DWIDTH-1:0] <mem>[(1<<AWIDTH)-1:0];        // Memory Declaration
  
  reg [DWIDTH-1:0] <memrega>;              
  reg [DWIDTH-1:0] <mem_pipe_rega>[NBPIPE-1:0];    // Pipelines for memory
  reg <mem_en_pipe_rega>[NBPIPE:0];                // Pipelines for memory enable  
  
  reg [DWIDTH-1:0] <memregb>;              
  reg [DWIDTH-1:0] <mem_pipe_regb>[NBPIPE-1:0];    // Pipelines for memory
  reg <mem_en_pipe_regb>[NBPIPE:0];                // Pipelines for memory enable  
  integer          i;
  
  // RAM : Both READ and WRITE have a latency of one
  always @ (posedge <clk>)
  begin
   if(<mem_ena>) 
    begin
     if(<wea>)
      <mem>[<addra>] <= <dina>;
     else
      <memrega> <= <mem>[<addra>];
    end
  end
  
  // The enable of the RAM goes through a pipeline to produce a
  // series of pipelined enable signals required to control the data
  // pipeline.
  always @ (posedge <clk>)
  begin
   <mem_en_pipe_rega>[0] <= <mem_ena>;
   for (i=0; i<NBPIPE; i=i+1)
     <mem_en_pipe_rega>[i+1] <= <mem_en_pipe_rega>[i];
  end
  
  // RAM output data goes through a pipeline.
  always @ (posedge <clk>)
  begin
   if (<mem_en_pipe_rega>[0])
    <mem_pipe_rega>[0] <= <memrega>;
  end    
  
  always @ (posedge <clk>)
  begin
   for (i = 0; i < NBPIPE-1; i = i+1)
    if (<mem_en_pipe_rega>[i+1])
     <mem_pipe_rega>[i+1] <= <mem_pipe_rega>[i];
  end      
  
  always @ (posedge <clk>)
  begin
   if (<mem_en_pipe_rega>[NBPIPE])
     <douta> <= <mem_pipe_rega>[NBPIPE-1];
  end
  
  
  always @ (posedge <clk>)
  begin
   if(<mem_enb>) 
    begin
     if(<web>)
      <mem>[<addrb>] <= <dinb>;
     else
      <memregb> <= <mem>[<addrb>];
    end
  end
  
  // The enable of the RAM goes through a pipeline to produce a
  // series of pipelined enable signals required to control the data
  // pipeline.
  always @ (posedge <clk>)
  begin
   <mem_en_pipe_regb>[0] <= <mem_enb>;
   for (i=0; i<NBPIPE; i=i+1)
     <mem_en_pipe_regb>[i+1] <= <mem_en_pipe_regb>[i];
  end
  
  // RAM output data goes through a pipeline.
  always @ (posedge <clk>)
  begin
   if (<mem_en_pipe_regb>[0])
    <mem_pipe_regb>[0] <= <memregb>;
  end    
  
  always @ (posedge <clk>)
  begin
   for (i = 0; i < NBPIPE-1; i = i+1)
    if (<mem_en_pipe_regb>[i+1])
     <mem_pipe_regb>[i+1] <= <mem_pipe_regb>[i];
  end      
  
  always @ (posedge <clk>)
  begin
   if (<mem_en_pipe_regb>[NBPIPE])
     <doutb> <= <mem_pipe_regb>[NBPIPE-1];
  end
  
                          
                      