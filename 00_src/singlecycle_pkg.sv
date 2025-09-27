//======================================================
// Package: singlecycle_pkg
// Description: Common typedefs and parameters for single-cycle CPU
//======================================================

package singlecycle_pkg;
  
  //======================================================
  // Memory mapping
  //======================================================
  localparam MEMORY_ADDR      = 21'h0;          // Region address for memory
  localparam MEMORY_WIDTH     = 9;              // 2^9 words (32-bit) = 2048B = 2KB

  //======================================================
  // Output buffer mapping
  //======================================================
  localparam OB_WIDTH         = 3;              // Output buffer size (8 locations)
  localparam LEDR_ADDR_BASE   = 32'h1000_0000;  // Red LEDs
  localparam LEDG_ADDR_BASE   = 32'h1000_1000;  // Green LEDs
  localparam HEX_30_ADDR_BASE = 32'h1000_2000;  // HEX0–HEX3
  localparam HEX_74_ADDR_BASE = 32'h1000_3000;  // HEX4–HEX7
  localparam LCD_ADDR_BASE    = 32'h1000_4000;  // LCD

  //======================================================
  // Input buffer mapping
  //======================================================
  localparam IB_WIDTH         = 2;              // Input buffer size (4 locations)
  localparam SW_ADDR_BASE     = 32'h1001_0000;  // Switch inputs

  //======================================================
  // Instruction memory mapping
  //======================================================
  localparam INSTR_MEM_WIDTH     = 11;  // 2^11 words (32-bit) = 8192B = 8KB
  
  //======================================================
  // Opcode
  //======================================================
  typedef enum logic [6:0] {
    OP_ITYPE_LOAD  = 7'b0000011,
    OP_ITYPE_CALC  = 7'b0010011,
    OP_UTYPE_AUIPC = 7'b0010111,
    OP_STYPE       = 7'b0100011,
    OP_RTYPE       = 7'b0110011,
    OP_UTYPE_LUI   = 7'b0110111,
    OP_BTYPE       = 7'b1100011,
    OP_ITYPE_JUMP  = 7'b1100111,
    OP_JTYPE       = 7'b1101111
  } opcode_e;

  //======================================================
  // Funct3
  //======================================================
  typedef enum logic [2:0] {
    F3_LB  = 3'b000,
    F3_LH  = 3'b001,
    F3_LW  = 3'b010,
    F3_LBU = 3'b100,
    F3_LHU = 3'b101
  } funct3_itype_load_e;

  typedef enum logic [2:0] {
    F3_ADDI  = 3'b000,
    F3_SLLI  = 3'b001,
    F3_SLTI  = 3'b010,
    F3_SLTIU = 3'b011,
    F3_XORI  = 3'b100,
    F3_SRLI  = 3'b101,
    F3_ORI   = 3'b110,
    F3_ANDI  = 3'b111
  } funct3_itype_calc_e;

  typedef enum logic [2:0] {
    F3_SB = 3'b000,
    F3_SH = 3'b001,
    F3_SW = 3'b010
  } funct3_stype_e;

  typedef enum logic [2:0] {
    F3_ADD  = 3'b000,
    F3_SLL  = 3'b001,
    F3_SLT  = 3'b010,
    F3_SLTU = 3'b011,
    F3_XOR  = 3'b100,
    F3_SRL  = 3'b101,
    F3_OR   = 3'b110,
    F3_AND  = 3'b111
  } funct3_rtype_e;

  typedef enum logic [2:0] {
    F3_BEQ  = 3'b000,
    F3_BNE  = 3'b001,
    F3_BLT  = 3'b100,
    F3_BGE  = 3'b101,
    F3_BLTU = 3'b110,
    F3_BGEU = 3'b111
  } funct3_btype_e;
  
  localparam F3_JUMP = 3'b000;
  
  //======================================================
  // Funct7
  //======================================================
  typedef enum logic [6:0] {
    F7_0 = 7'b0000000,
    F7_1 = 7'b0100000
  } funct7_e;

  //======================================================
  // PC select
  //======================================================
  typedef enum logic {
    PC_SEL_PC_FOUR  = 1'b0,
    PC_SEL_ALU_DATA = 1'b1
  } pc_sel_e;

  //======================================================
  // Rd write enable
  //======================================================
  typedef enum logic {
    RD_WRDIS = 1'b0,
    RD_WREN  = 1'b1
  } rd_wren_e;

  //======================================================
  // Instruction type
  //======================================================
  typedef enum logic [2:0] {
    IT_RTYPE = 3'b000,
    IT_ITYPE = 3'b001,
    IT_STYPE = 3'b010,
    IT_BTYPE = 3'b011,
    IT_UTYPE = 3'b100,
    IT_JTYPE = 3'b101
  } instr_type_e;
  
  //======================================================
  // Branch unsigned comparison
  //======================================================
  typedef enum logic {
    BR_SIGNED   = 1'b0,
    BR_UNSIGNED = 1'b1
  } br_un_e;
  
  //======================================================
  // OPA select
  //======================================================
  typedef enum logic {
    OPA_SEL_RS1_DATA = 1'b0,
    OPA_SEL_PC = 1'b1
  } opa_sel_e;

  //======================================================
  // OPB select
  //======================================================
  typedef enum logic {
    OPB_SEL_RS2_DATA = 1'b0,
    OPB_SEL_IMM_DATA = 1'b1
  } opb_sel_e;
  
  //======================================================
  // ALU operation
  //======================================================
  typedef enum logic [3:0] {
    ALU_ADD  = 4'b0000,
    ALU_SUB  = 4'b0001,
    ALU_SLT  = 4'b0010,
    ALU_SLTU = 4'b0011,
    ALU_XOR  = 4'b0100,
    ALU_OR   = 4'b0101,
    ALU_AND  = 4'b0110,
    ALU_SLL  = 4'b0111,
    ALU_SRL  = 4'b1000,
    ALU_SRA  = 4'b1001,
	 ALU_LUI  = 4'b1010
  } alu_op_e;

  //======================================================
  // LSU write enable
  //======================================================
  typedef enum logic {
    LSU_WRDIS = 1'b0,
    LSU_WREN  = 1'b1
  } lsu_wren_e;
  
  //======================================================
  // LSU byte-enable mask
  //======================================================
  typedef enum logic [3:0] {
    LSU_BMASK_BYTE = 4'b0001,
    LSU_BMASK_HALF = 4'b0011,
    LSU_BMASK_WORD = 4'b1111
  } lsu_bmask_e;

  //======================================================
  // LSU unsigned load
  //======================================================
  typedef enum logic {
    LSU_SIGNED   = 1'b0,
    LSU_UNSIGNED = 1'b1
  } lsu_un_e;
  
  // -------------------------
  // Writeback select
  // -------------------------
  typedef enum logic [1:0] {
    WB_SEL_ALU_DATA = 2'b00,
    WB_SEL_LD_DATA  = 2'b01,
    WB_SEL_PC_FOUR  = 2'b10
  } wb_sel_e;

  //======================================================
  // Instruction valid
  //======================================================
  typedef enum logic {
    INSN_INVALID = 1'b0,
    INSN_VALID   = 1'b1
  } insn_vld_e;

endpackage : singlecycle_pkg
