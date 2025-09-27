module singlecycle (
  input  logic        i_clk,       // Global  clock, active on the rising edge
  input  logic        i_reset_n,   // Global low active reset
  input  logic [31:0] i_io_sw,     // Input for switches
  output logic [31:0] o_pc_debug,  // Debug program counter
  output logic        o_insn_vld,  // Instruction valid
  output logic [31:0] o_io_ledr,   // Output for driving red LEDs
  output logic [31:0] o_io_ledg,   // Output for driving green LEDs
  output logic [6 :0] o_io_hex0,   // Output for driving 7-segment LED 0 displays
  output logic [6 :0] o_io_hex1,   // Output for driving 7-segment LED 1 displays
  output logic [6 :0] o_io_hex2,   // Output for driving 7-segment LED 2 displays
  output logic [6 :0] o_io_hex3,   // Output for driving 7-segment LED 3 displays
  output logic [6 :0] o_io_hex4,   // Output for driving 7-segment LED 4 displays
  output logic [6 :0] o_io_hex5,   // Output for driving 7-segment LED 5 displays
  output logic [6 :0] o_io_hex6,   // Output for driving 7-segment LED 6 displays
  output logic [6 :0] o_io_hex7,   // Output for driving 7-segment LED 7 displays
  output logic [31:0] o_io_lcd     // Output for driving LCD register
);

  import singlecycle_pkg::*;
  
  // Data wire
  logic        pc_wren;
  logic [31:0] pc_next;
  logic [31:0] pc;
  logic [31:0] pc_four;
  logic [31:0] instr;
  logic [31:0] rs1_data;
  logic [31:0] rs2_data;
  logic [31:0] imm_data;
  logic        pc_sel;
  logic        rd_wren;
  logic [ 2:0] instr_type;
  logic        br_un;
  logic        opa_sel;
  logic        opb_sel;
  logic [ 3:0] alu_op;
  logic        lsu_wren;
  logic [ 3:0] lsu_bmask;
  logic        lsu_un;
  logic        wb_sel;
  logic        insn_vld;
  logic        br_less;
  logic        br_equal;
  logic [31:0] op_a;
  logic [31:0] op_b;
  logic [31:0] alu_data;
  logic [31:0] ld_data;
  logic [31:0] wb_data;
  
  assign pc_wren = 1'b1;
  
  // ----------------------------------------------------
  // PC MUX
  // ----------------------------------------------------
  mux2_32b u_pc_mux (
    .i_d0 (pc_four),
    .i_d1 (alu_data),
    .i_sel(pc_sel),
    .o_y  (pc_next)
  );
  
  // ----------------------------------------------------
  // Program Counter Register
  // ----------------------------------------------------
  pc_reg u_pc_reg (
    .i_clk    (i_clk),
    .i_reset  (~i_reset_n),
    .i_pc_wren(pc_wren),
    .i_pc_next(pc_next),
    .o_pc     (pc)
  );

  // ----------------------------------------------------
  // Instruction Memory
  // ----------------------------------------------------
  instr_mem u_instr_mem (
    .i_instr_addr(pc),
    .o_instr     (instr)
  );
  
  // ----------------------------------------------------
  // Register File
  // ----------------------------------------------------
  regfile u_regfile (
    .i_clk     (i_clk),
    .i_reset   (~i_reset_n),
    .i_rs1_addr(instr[11:7]),
    .i_rs2_addr(instr[19:15]),
    .i_rd_addr (instr[24:20]),
    .i_rd_data (rd_data),
    .i_rd_wren (rd_wren),
    .o_rs1_data(rs1_data),
    .o_rs2_data(rs2_data)
  );

  // ----------------------------------------------------
  // Immediate Generator
  // ----------------------------------------------------
  imm_gen u_imm_gen (
    .i_instr     (instr[31:7]),
    .i_instr_type(instr_type),
    .o_imm_data  (imm_data)
  );
  
  // ----------------------------------------------------
  // Control Unit
  // ----------------------------------------------------
  ctrlu u_ctrlu (
    .i_opcode    (instr[6:0]),    // opcode
    .i_funct3    (instr[14:12]),  // funct3
    .i_funct7    (instr[31:25]),  // funct7
    .i_br_less   (br_less),
    .i_br_equal  (br_equal),
    .o_pc_sel    (pc_sel),
    .o_rd_wren   (rd_wren),
    .o_instr_type(instr_type),
    .o_br_un     (br_un),
    .o_opa_sel   (opa_sel),
    .o_opb_sel   (opb_sel),
    .o_alu_op    (alu_op),
    .o_lsu_wren  (lsu_wren),
    .o_lsu_bmask (lsu_bmask),
    .o_lsu_un    (lsu_un),
    .o_wb_sel    (wb_sel),
    .o_insn_vld  (insn_vld)
  );

  // ----------------------------------------------------
  // Branch Comparator
  // ----------------------------------------------------
  brc u_brc (
    .i_rs1_data(rs1_data),
    .i_rs2_data(rs2_data),
    .i_br_un   (br_un),
    .o_br_less (br_less),
    .o_br_equal(br_equal)
  );

  // ----------------------------------------------------
  // OPA MUX
  // ----------------------------------------------------
  mux2_32b u_opa_mux (
    .i_d0 (rs1_data),
    .i_d1 (pc),
    .i_sel(opa_sel),
    .o_y  (op_a)
  );
  
  // ----------------------------------------------------
  // OPB MUX
  // ----------------------------------------------------
  mux2_32b u_opb_mux (
    .i_d0 (rs2_data),
    .i_d1 (imm_data),
    .i_sel(opb_sel),
    .o_y  (op_b)
  );
  
  // ----------------------------------------------------
  // Arithmetic Logic Unit
  // ----------------------------------------------------
  alu u_alu (
    .i_op_a    (op_a),
    .i_op_b    (op_b),
    .i_alu_op  (alu_op),
    .o_alu_data(alu_data)
  );
  
  // ----------------------------------------------------
  // Load/Store Unit
  // ----------------------------------------------------
  lsu u_lsu (
    .i_clk      (i_clk),
    .i_reset    (~i_reset_n),
    .i_lsu_wren (lsu_wren),
    .i_lsu_bmask(lsu_bmask),
    .i_lsu_un   (lsu_un),
    .i_lsu_addr (alu_data),
    .i_st_data  (rs2_data),
    .o_ld_data  (ld_data),
    .i_io_sw    (i_io_sw),
    .o_io_ledr  (o_io_ledr),
    .o_io_ledg  (o_io_ledg),
    .o_io_hex7  (o_io_hex7),
    .o_io_hex6  (o_io_hex6),
    .o_io_hex5  (o_io_hex5),
    .o_io_hex4  (o_io_hex4),
    .o_io_hex3  (o_io_hex3),
    .o_io_hex2  (o_io_hex2),
    .o_io_hex1  (o_io_hex1),
    .o_io_hex0  (o_io_hex0),
    .o_io_lcd   (o_io_lcd)
  );

  // ----------------------------------------------------
  // Writeback MUX
  // ----------------------------------------------------
  mux3_32b u_wb_mux (
    .i_d0 (alu_data),
    .i_d1 (ld_data),
    .i_d2 (pc_four),
    .i_sel(wb_sel),
    .o_y  (wb_data)
  );

endmodule  