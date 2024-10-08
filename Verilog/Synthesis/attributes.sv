
// information on Synthesis Attributes
// ===================================
//
// The following templates for synthesis attributes use the Verilog-2001 attribute
// syntax for passing these constraints to the synthesis and back-end Xilinx tools.
// Since these are synthesis attributes, they are ignored for the purpose of
// simulation and thus generally should be used for passing attributes that do not
// effect design or component functionality such as placement or hierarchy
// constraints.  These can also be used to guide synthesis implementation such as in
// the case of the state-machine extraction algorithms and parallel and full case
// specifications.  To properly specify these constraints, they must be placed
// in-line with the declaring function or signal. Multiple attributes can be
// specified by comma separating them in the parenthesis-star brackets.

// Example of placing a LOC attribute on an input port declaration:
/*
   (* LOC="K1" *) input A;
*/

// Example of placing an ASYNC_REG constraint on an inferred register:
/*
    (* ASYNC_REG="true" *) reg empty_reg;
*/

// Example of placing a KEEP_HIERARCHY constraint on an instantiated module:
/*
    // Instantiation of the DECODER module
    (* keep_hierarchy="yes" *) DECODER DECODER_inst (
      .DATA_IN(DATA_IN),
      .CLK(CLK),
      .RST(RST),
      .DATA_OUT(DATA_OUT)
    );
    // End of DECODER_inst instantiation
*/

// Example of PARALLEL_CASE / FULL_CASE:

/*
   always @(A, B, C, current_state) begin (* parallel_case, full_case *)
      case (current_state)
         RESET: begin
                   ...
*/

// > Clock
// Buffer type (clock_buffer_type)
(* clock_buffer_type="NONE" *)
(* clock_buffer_type="BUFR" *)

// > I/O
// >> I/O Buffer type (io_buffer_type)
(* io_buffer_type="ibuf" *)
(* io_buffer_type="none" *)
// >> Place/Dont place register into IOB (IOB)
(* IOB="true" *)
(* IOB="false" *)
// >> I/O standard (IOSTANDARD)
(* IOSTANDARD="<standard>" *)

// > Location/Packing
// >> Absolute Location Constraint (LOC)
(* LOC="<value>" *)
// >> Relative Location Constraint (RLOC)
(* RLOC="<value>" *)
// >> Hierarchical LUT Packing Constraint (HLUTNM)
// Specifies LUT packing of two LUT5s into the same LUT6 for uniquified by hierarchy
(* HLUTNM="<value>" *)
// >> LUT Packing Constraint (LUTNM)
// Specifies LUT packing of two LUT5s into the same LUT6
(* LUTNM="<value>" *)

// > Misc
// >> Asynchronous Register Specification (ASYNC_REG)
(* ASYNC_REG="true" *)
// >> Mark Signal for Debug (MARK_DEBUG)
// This marks the debug_signal register for debugging, ensuring that it is preserved in the synthesized and implemented design,
// so you can probe this signal during runtime using an ILA or other hardware debugging tools.
(* MARK_DEBUG="true" *)

// > Synthesis
// >> BlackBox (black_box)
(* black_box="true" *)
// Apply before module declaration which needs to be black boxed
// >> Buffer type (buffer_type)
(* buffer_type="ibuf" *)
(* buffer_type="none" *)
// >> Case statement
// >>> Full case
(* full_case *)
// >>> Parallel case
(* parallel_case *)
// >>> Full case, parallel case
(* full_case, parallel_case *)
// >> Custom attribute
(* my_att = "my_value" *)
// >>  Direct enable/reset
(* direct_enable = "yes" *)
//port
(* direct_reset = "yes" *)
//port
// >> Do not optimize
(* dont_touch="true" *)
// >> DSP folding fastclock
(* dsp_folding_fastclock = "yes" *)
//2x clock port
// >> Extract enable/reset
(* extract_enable = "yes" *)
(* extract_reset = "yes" *)
// >> FSM Encoding
(* fsm_encoding = "none" *)
(* fsm_encoding = "gray" *)
(* fsm_encoding = "johnson" *)
(* fsm_encoding = "one_hot" *)
(* fsm_encoding = "sequential" *)
(* fsm_encoding = "user_encoding" *)
// >> FSM Safe State
(* fsm_safe_state = "default_state" *)
(* fsm_safe_state = "auto_safe_state" *)
(* fsm_safe_state = "power_on_state" *)
(* fsm_safe_state = "reset_state" *)
// >> Gated Clock
(* gated_clock = "true" *)
// >> Keep hierarchy
(* keep_hierarchy="yes" *)
// >> Keep/Preserve a signal
(* keep="true" *)
// >> Max fanout
(* max_fanout=<number> *)
// >> RAM decomp
(* ram_decomp = "power" *)
// >> RAM cascade
(* cascade_height=<number> *)
// >> RAM Styles
(* ram_style="block" *)
(* ram_style="distributed" *)
(* ram_style="register" *)
(* ram_style="ultra" *)
// >> ROM Styles
(* rom_style="block" *)
(* rom_style="distributed" *)
(* rom_style="ultra" *)
// >> Retiming
(* retiming_backward = 1 *)
(* retiming_forward = 1 *)
// >> RW address collision
(* rw_addr_collision = "auto" *)
(* rw_addr_collision = "yes" *)
(* rw_addr_collision = "no" *)
// >> Shift register extract
(* shreg_extract = "no" *)
// >> Shift register style
(* srl_style = "block" *)
(* srl_style = "register" *)
(* srl_style = "reg_srl" *)
(* srl_style = "reg_srl_reg" *)
(* srl_style = "srl" *)
(* srl_style = "srl_reg" *)
// >> Use DSP
(* use_dsp="yes" *)
