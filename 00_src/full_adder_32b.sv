//======================================================
// 1-bit Full Adder
//======================================================
module full_adder_1b (
  input  logic i_a,    // First input bit
  input  logic i_b,    // Second input bit
  input  logic i_ci,   // Carry-in bit
  output logic o_s,    // Sum output
  output logic o_co    // Carry-out
);
  
  // Combinational logic for full adder
  always_comb begin
    o_s  = i_a ^ i_b ^ i_ci;                    // Sum bit
    o_co = (i_a & i_b) | (i_ci & (i_a ^ i_b));  // Carry-out calculation
  end
  
endmodule

//======================================================
// 8-bit Ripple-Carry Adder
//======================================================
module full_adder_8b (
  input  logic [7:0] i_a,   // First 8-bit input
  input  logic [7:0] i_b,   // Second 8-bit input
  input  logic       i_ci,  // Carry-in
  output logic [7:0] o_s,   // 8-bit sum output
  output logic       o_co   // Carry-out of the 8th bit
);

  logic [6:0] carry; // Internal carry signals

  // Instantiate 8 one-bit full adders
  full_adder_1b fa0 (.i_a(i_a[0]), .i_b(i_b[0]), .i_ci(    i_ci), .o_s(o_s[0]), .o_co(carry[0]));
  full_adder_1b fa1 (.i_a(i_a[1]), .i_b(i_b[1]), .i_ci(carry[0]), .o_s(o_s[1]), .o_co(carry[1]));
  full_adder_1b fa2 (.i_a(i_a[2]), .i_b(i_b[2]), .i_ci(carry[1]), .o_s(o_s[2]), .o_co(carry[2]));
  full_adder_1b fa3 (.i_a(i_a[3]), .i_b(i_b[3]), .i_ci(carry[2]), .o_s(o_s[3]), .o_co(carry[3]));
  full_adder_1b fa4 (.i_a(i_a[4]), .i_b(i_b[4]), .i_ci(carry[3]), .o_s(o_s[4]), .o_co(carry[4]));
  full_adder_1b fa5 (.i_a(i_a[5]), .i_b(i_b[5]), .i_ci(carry[4]), .o_s(o_s[5]), .o_co(carry[5]));
  full_adder_1b fa6 (.i_a(i_a[6]), .i_b(i_b[6]), .i_ci(carry[5]), .o_s(o_s[6]), .o_co(carry[6]));
  full_adder_1b fa7 (.i_a(i_a[7]), .i_b(i_b[7]), .i_ci(carry[6]), .o_s(o_s[7]), .o_co(     o_co));

endmodule

//======================================================
// 32-bit Ripple-Carry Adder
//======================================================
module full_adder_32b (
  input  logic [31:0] i_a,   // First 32-bit operand
  input  logic [31:0] i_b,   // Second 32-bit operand
  input  logic        i_ci,  // Carry-in (for subtraction or chained addition)
  output logic [31:0] o_s,   // 32-bit sum output
  output logic        o_co   // Final carry-out
);
  logic [2:0] carry; // Internal carries

  // Instantiate four 8-bit adders
  full_adder_8b fa0 (.i_a(i_a[ 7: 0]), .i_b(i_b[ 7: 0]), .i_ci(    i_ci), .o_s(o_s[ 7: 0]), .o_co(carry[0]));
  full_adder_8b fa1 (.i_a(i_a[15: 8]), .i_b(i_b[15: 8]), .i_ci(carry[0]), .o_s(o_s[15: 8]), .o_co(carry[1]));
  full_adder_8b fa2 (.i_a(i_a[23:16]), .i_b(i_b[23:16]), .i_ci(carry[1]), .o_s(o_s[23:16]), .o_co(carry[2]));
  full_adder_8b fa3 (.i_a(i_a[31:24]), .i_b(i_b[31:24]), .i_ci(carry[2]), .o_s(o_s[31:24]), .o_co(     o_co));

endmodule
