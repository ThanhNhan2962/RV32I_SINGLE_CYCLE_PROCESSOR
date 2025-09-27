//======================================================
// ALU (Arithmetic Logic Unit) module
//======================================================
module alu (
  input  logic [31:0] i_op_a,     // First operand for ALU operations
  input  logic [31:0] i_op_b,     // Second operand for ALU operations
  input  logic [ 3:0] i_alu_op,   // The operation to be performed
  output logic [31:0] o_alu_data  // Result of the ALU operation
);

  import singlecycle_pkg::*;
  
  // Internal signals for computation
  logic [31:0] op_b;         // Tempotary of operand b
  logic        c_in;         // Carry-in flag to addition operation
  logic        c_out;        // Carry-out flag from addition operation
  logic [31:0] add_result;	  // Result of ADD operation
  logic        slt_temp;     // Tempotary of SLT result
  logic [31:0] slt_result;	  // Result of SLT operation
  logic [31:0] sltu_result;  // Result of SLTU operation
  logic [31:0] xor_result;   // Result of XOR operation
  logic [31:0] or_result;    // Result of OR operation
  logic [31:0] and_result;   // Result of AND operation
  logic [31:0] sll_result;   // Result of logical left shift
  logic [31:0] srl_result;   // Result of logical right shift
  logic [31:0] sra_result;   // Result of arithmetic right shift

  //======================================================
  // Determine operands for addition/subtraction
  //======================================================
  always_comb begin
    case (i_alu_op)
      ALU_SUB, ALU_SLT, ALU_SLTU: begin
        op_b = ~i_op_b;
        c_in = 1'b1;
      end
		
      default: begin
        op_b = i_op_b;
        c_in = 1'b0;
      end
    endcase
  end

  //======================================================
  // Instantiations of ADD/SUB operation module
  //======================================================
  full_adder_32b u_add (
    .i_a  (i_op_a),
    .i_b  (op_b),
    .i_ci (c_in),
    .o_s  (add_result),
    .o_co (c_out)
  );
  
  //======================================================
  // Instantiations of SLT operation module
  //======================================================
  slt_check u_slt_check (
    .i_signed_a   (i_op_a[31]),
	 .i_signed_b   (op_b[31]),
	 .i_signed_s   (add_result[31]),
	 .o_slt_result (slt_temp)
  );
  
  assign slt_result = {31'b0, slt_temp};
  
  // SLTU operation
  assign sltu_result = {31'b0, ~c_out};
  
  // XOR operation
  assign xor_result  = i_op_a ^ i_op_b;
  
  // OR operation
  assign or_result	 = i_op_a | i_op_b;
  
  // AND operation
  assign and_result  = i_op_a & i_op_b;
	
  //======================================================
  // Instantiations of SLL operation module
  //======================================================
  sll_32b u_sll (
    .i_a	      (i_op_a),
    .i_shamt	(i_op_b[4:0]),
    .o_result  (sll_result)
  );

  //======================================================
  // Instantiations of SRL operation module
  //======================================================
  srl_32b u_srl (
    .i_a       (i_op_a),
    .i_shamt   (i_op_b[4:0]),
    .o_result	(srl_result)
  );

  //======================================================
  // Instantiations of SRA operation module
  //======================================================
  sra_32b u_sra (
    .i_a       (i_op_a),
    .i_shamt   (i_op_b[4:0]),
    .o_result	(sra_result)
  );

  //======================================================
  // Select the correct ALU result based on the operation code
  //======================================================
  always_comb begin
    case (i_alu_op)
      ALU_ADD, ALU_SUB:	o_alu_data = add_result;
      ALU_SLT: 			o_alu_data = slt_result;
      ALU_SLTU:			o_alu_data = sltu_result;
      ALU_XOR: 			o_alu_data = xor_result;
      ALU_OR: 				o_alu_data = or_result;
      ALU_AND: 			o_alu_data = and_result;
      ALU_SLL: 			o_alu_data = sll_result;
      ALU_SRL: 			o_alu_data = srl_result;
      ALU_SRA: 			o_alu_data = sra_result;
      default:				o_alu_data = 32'b0;
    endcase
  end

endmodule
