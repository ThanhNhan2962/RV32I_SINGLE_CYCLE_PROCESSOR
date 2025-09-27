//======================================================
// Control 	Unit Module
//======================================================
module ctrlu(
  input  logic [6:0] i_opcode,     // Instruction opcode
  input  logic [2:0] i_funct3,     // Instruction funct3
  input  logic [6:0] i_funct7,     // Instruction funct7
  input  logic       i_br_less,    // Branch comparator result: rs1 < rs2
  input  logic       i_br_equal,   // Branch comparator result: rs1 == rs2
  output logic       o_pc_sel,     // PC select 
  output logic       o_rd_wren,    // RD write enable
  output logic [2:0] o_instr_type, // Instruction type
  output logic       o_br_un,      // Branch unsigned
  output logic       o_opa_sel,    // ALU operand A select
  output logic       o_opb_sel,    // ALU operand B select
  output logic [3:0] o_alu_op,     // ALU operation
  output logic       o_lsu_wren,   // LSU write enable
  output logic [3:0] o_lsu_bmask,  // LSU byte-enable mask
  output logic       o_lsu_un,     // LSU unsigned load
  output logic [1:0] o_wb_sel,     // Writeback select
  output logic       o_insn_vld    // Instruction valid
);


  import singlecycle_pkg::*;
  
  logic       pc_sel;
  logic       rd_wren;
  logic [2:0] instr_type;
  logic       br_un;
  logic       opa_sel;
  logic       opb_sel;
  logic [3:0] alu_op;
  logic       lsu_un;
  logic [3:0] lsu_bmask;
  logic       lsu_wren;
  logic [1:0] wb_sel;
  logic       insn_vld;
	
  always_comb begin
    pc_sel     = PC_SEL_PC_FOUR;
    rd_wren    = RD_WRDIS;
    instr_type = IT_RTYPE;
    br_un      = BR_SIGNED;
    opa_sel    = OPA_SEL_RS1_DATA;
    opb_sel    = OPB_SEL_RS2_DATA;
    alu_op     = ALU_ADD;
    lsu_wren   = LSU_WRDIS;
    lsu_bmask  = LSU_BMASK_WORD;
    lsu_un     = LSU_SIGNED;
    wb_sel     = WB_SEL_ALU_DATA;
    insn_vld   = INSN_INVALID;
	 
    case (i_opcode)
      OP_ITYPE_LOAD: begin
        rd_wren    = RD_WREN;
        instr_type = IT_ITYPE;
        opb_sel    = OPB_SEL_IMM_DATA;
        wb_sel     = WB_SEL_LD_DATA;
        
		  case (i_funct3)
          F3_LB: begin
            lsu_un    = LSU_SIGNED;
            lsu_bmask = LSU_BMASK_BYTE;
          end
          
          F3_LH: begin
            lsu_un    = LSU_SIGNED;
            lsu_bmask = LSU_BMASK_HALF;
          end
			 
          F3_LW: begin
            lsu_un    = LSU_SIGNED;
            lsu_bmask = LSU_BMASK_WORD;
          end

          F3_LBU: begin
            lsu_un    = LSU_UNSIGNED;
            lsu_bmask = LSU_BMASK_BYTE;
          end

          F3_LHU: begin
            lsu_un    = LSU_UNSIGNED;
            lsu_bmask = LSU_BMASK_HALF;
          end

          default: insn_vld  = INSN_INVALID;
        endcase
      end
		  
      OP_ITYPE_CALC: begin
        rd_wren    = RD_WREN;
		  instr_type = IT_ITYPE;
        opb_sel    = OPB_SEL_IMM_DATA;
        
		  case (i_funct3)
          F3_ADDI:  alu_op   = ALU_ADD;
          F3_SLLI: begin
            if (i_funct7 == F7_0) alu_op   = ALU_SLL;
            else                      insn_vld = INSN_INVALID;
          end
          F3_SLTI:  alu_op   = ALU_SLT;
          F3_SLTIU: alu_op   = ALU_SLTU;
          F3_XORI:  alu_op   = ALU_XOR;
          F3_SRLI: begin
            if      (i_funct7 == F7_0) alu_op   = ALU_SRL;
            else if (i_funct7 == F7_1) alu_op   = ALU_SRA;
            else                           insn_vld = INSN_INVALID;
          end
          F3_ORI:   alu_op   = ALU_OR;
          F3_ANDI:  alu_op   = ALU_AND;
          default:  insn_vld = INSN_INVALID;
        endcase
      end

      OP_UTYPE_AUIPC: begin
        rd_wren    = RD_WREN;
        instr_type = IT_UTYPE;
        opa_sel    = OPA_SEL_PC;
        opb_sel    = OPB_SEL_IMM_DATA;
      end

      OP_STYPE: begin
        instr_type = IT_STYPE;
        opb_sel    = OPB_SEL_IMM_DATA;
        lsu_wren   = LSU_WREN;
        
		  case (i_funct3)
          F3_SB: lsu_bmask  = LSU_BMASK_BYTE;
          F3_SH: lsu_bmask  = LSU_BMASK_HALF;
          F3_SW: lsu_bmask  = LSU_BMASK_WORD;
          default: insn_vld = INSN_INVALID;
        endcase
      end

      OP_RTYPE: begin
        rd_wren    = RD_WREN;
        
		  case (i_funct3)
          F3_ADD: begin
            if      (i_funct7 == F7_0) alu_op   = ALU_ADD;
            else if (i_funct7 == F7_1) alu_op   = ALU_SUB;
            else                       insn_vld = INSN_INVALID;
          end
			 
          F3_SLL: begin
            if (i_funct7 == F7_0)      alu_op   = ALU_SLL;
            else                       insn_vld = INSN_INVALID;
          end

          F3_SLT: begin
            if (i_funct7 == F7_0)      alu_op   = ALU_SLT;
            else                       insn_vld = INSN_INVALID;
          end

          F3_SLTU: begin
            if (i_funct7 == F7_0)      alu_op   = ALU_SLTU;
            else                       insn_vld = INSN_INVALID;
          end

          F3_XOR: begin
            if (i_funct7 == F7_0)      alu_op   = ALU_XOR;
            else                       insn_vld = INSN_INVALID;
          end

          F3_SRL: begin
            if      (i_funct7 == F7_0) alu_op   = ALU_SRL;
            else if (i_funct7 == F7_1) alu_op   = ALU_SRA;
            else                       insn_vld = INSN_INVALID;
          end

          F3_OR: begin
            if (i_funct7 == F7_0)      alu_op   = ALU_OR;
            else                       insn_vld = INSN_INVALID;
          end

          F3_AND: begin
            if (i_funct7 == F7_0)      alu_op   = ALU_AND;
            else                       insn_vld = INSN_INVALID;
          end

          default: insn_vld = INSN_INVALID;
        endcase
      end

      OP_UTYPE_LUI: begin
        rd_wren    = RD_WREN;
        instr_type = IT_UTYPE;
        opb_sel    = OPB_SEL_IMM_DATA;
        alu_op     = ALU_LUI;
      end
			
      OP_BTYPE: begin
        instr_type = IT_BTYPE;
        opa_sel    = OPA_SEL_PC;
        opb_sel    = OPB_SEL_IMM_DATA;
        
		  case (i_funct3)
          F3_BEQ: begin
            pc_sel = (i_br_equal) ? PC_SEL_ALU_DATA
                                  : PC_SEL_PC_FOUR;
            br_un  = BR_SIGNED;
          end
			 
          F3_BNE: begin
            pc_sel = (~i_br_equal) ? PC_SEL_ALU_DATA
                                   : PC_SEL_PC_FOUR;
            br_un  = BR_SIGNED;
          end
				
          F3_BLT: begin
            pc_sel = (i_br_less) ? PC_SEL_ALU_DATA
                                 : PC_SEL_PC_FOUR;
            br_un  = BR_SIGNED;
          end
				
          F3_BGE: begin
            pc_sel = (~i_br_less) ? PC_SEL_ALU_DATA
                                  : PC_SEL_PC_FOUR;
            br_un  = BR_SIGNED;
          end
				
          F3_BLTU: begin
            pc_sel = (i_br_less) ? PC_SEL_ALU_DATA
                                 : PC_SEL_PC_FOUR;
            br_un  = BR_UNSIGNED;
          end
				
          F3_BGEU: begin
            pc_sel = (~i_br_less) ? PC_SEL_ALU_DATA
                                  : PC_SEL_PC_FOUR;
            br_un 	= BR_UNSIGNED;
          end
               
          default: insn_vld = INSN_INVALID;
        endcase
      end
			
      OP_ITYPE_JUMP: begin
        if (i_funct3 == F3_JUMP) begin
          pc_sel	   = PC_SEL_ALU_DATA;
		    rd_wren    = RD_WREN;
          instr_type = IT_UTYPE;
          opb_sel    = OPB_SEL_IMM_DATA;
          wb_sel     = WB_SEL_PC_FOUR;
        end
        else insn_vld = INSN_INVALID;
		end
			
      OP_JTYPE: begin
        pc_sel	    = PC_SEL_ALU_DATA;
        rd_wren    = RD_WREN;
        instr_type = IT_UTYPE;
        opa_sel    = OPA_SEL_PC;
		  opb_sel    = OPB_SEL_IMM_DATA;
        wb_sel     = WB_SEL_PC_FOUR;
      end
			
      default: insn_vld = INSN_INVALID;
    endcase
  end
	
  assign o_pc_sel	     = pc_sel;
  assign o_rd_wren     = rd_wren;
  assign o_instr_type  = instr_type;
  assign o_br_un       = br_un;
  assign o_opa_sel     = opa_sel;
  assign o_opb_sel     = opb_sel;
  assign o_alu_op	     = alu_op;
  assign o_lsu_un	     = lsu_un;
  assign o_lsu_bmask   = lsu_bmask;
  assign o_lsu_wren    = lsu_wren;
  assign o_wb_sel      = wb_sel;
  assign o_insn_vld    = insn_vld;
  
endmodule