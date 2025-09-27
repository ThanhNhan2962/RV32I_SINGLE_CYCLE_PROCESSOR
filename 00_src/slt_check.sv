//======================================================
// slt_check: Signed let than comparation using sign bits
//======================================================
module slt_check (
  input  logic i_signed_a,   // Signed bit of operand a
  input  logic i_signed_b,   // Signed bit of operand b
  input  logic i_signed_s,   // Signed bit of subtraction result
  output logic o_slt_result  // If (A < B) then 1 else 0
);
  
  logic v;
  
  assign v = (i_signed_a != i_signed_b) && (i_signed_s != i_signed_a);
  assign o_slt_result = i_signed_s ^ v;
  
endmodule
