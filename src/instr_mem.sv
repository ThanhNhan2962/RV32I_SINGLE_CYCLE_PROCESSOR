module instr_mem (
  input  logic [31:0] i_instr_addr,
  output logic [31:0] o_instr
);

  import singlecycle_pkg::*;
  
  logic [3:0][7:0] instr_mem_array [2**(INSTR_MEM_WIDTH)-1:0];

  // Load memory from file
  initial begin
    $readmemh("C:/altera/13.0sp1/CTMT_milestone2/02_test/dump/instr_mem.dump", instr_mem_array, 0, 2047);
  end

  always_comb begin
    o_instr <=  instr_mem_array [i_instr_addr[12:2]][3:0];
  end
endmodule