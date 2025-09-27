module imm_gen (
  input  logic [24:0] i_instr,
  input  logic [ 2:0] i_instr_type,
  output logic [31:0] o_imm_data
);
  
  import singlecycle_pkg::*;
  
  always_comb begin
    case(i_instr_type)
      IT_RTYPE: o_imm_data <= 32'd0;
      IT_ITYPE: o_imm_data <= {{20{i_instr[24]}}, i_instr[24:13]}; 
      IT_STYPE: o_imm_data <= {{20{i_instr[24]}}, i_instr[24:18], i_instr[4:0]};
      IT_BTYPE: o_imm_data <= {{20{i_instr[24]}}, i_instr[0], i_instr[23:18], i_instr[4:1], 1'b0};
      IT_UTYPE: o_imm_data <= {i_instr[24:5], 12'b0};
      IT_JTYPE: o_imm_data <= {{12{i_instr[24]}}, i_instr[12:5], i_instr[13], i_instr[23:14], 1'b0};
      default:  o_imm_data <= 32'h0000_0000;
    endcase
  end
  
endmodule