//======================================================
// brc: Branch Comparator module
//======================================================
module brc (
  input  logic [31:0] i_rs1_data,  // Data from the first register
  input  logic [31:0] i_rs2_data,  // Data from the second register
  input  logic        i_br_un,     // Comparison mode (1 if signed, 0 if unsigned)
  output logic        o_br_less,   // Output is 1 if rs1 < rs2
  output logic        o_br_equal   // Output is 1 if rs1 = rs2
);

  logic [31:0] sub_result;        // Subtraction result: rs1 - rs2
  logic        c_out;             // Carry-out from subtraction (used in unsigned compare)
  logic        br_less_unsigned;  // Result of unsigned comparation
  logic        br_less_signed;    // Result of signed comparation
  
  // Equal detection (valid for both signed and unsigned)
  assign o_br_equal = (i_rs1_data == i_rs2_data);
  
  // Perform subtraction: rs1 - rs2
  full_adder_32b u_sub (
    .i_a  (i_rs1_data),   // Operand A
    .i_b  (~i_rs2_data),  // Operand B (inverted for subtraction)
    .i_ci (1'b1),         // Add +1 for two's complement subtraction
    .o_s  (sub_result),   // Subtraction result
    .o_co (c_out)         // Carry-out
  );

  slt_check u_slt_check (
    .i_signed_a   (i_rs1_data[31]),
	 .i_signed_b   (~i_rs2_data[31]),
	 .i_signed_s   (sub_result[31]),
	 .o_slt_result (br_less_signed)
  );
  
  assign br_less_unsigned = ~c_out;
  
  // Less-than detection
  always_comb begin
    if (i_br_un == 1'b1) begin
	   // Unsigned comparison:
      o_br_less = br_less_unsigned;
    end else begin
      // Signed comparison: use (N ^ V)
      o_br_less = br_less_signed;
    end
  end

endmodule
