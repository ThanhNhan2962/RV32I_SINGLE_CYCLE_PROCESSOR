//======================================================
// Data Memory Module
//======================================================
module memory (
  input  logic        i_clk,    // Global clock
  input  logic        i_reset,  // Global active reset
  input  logic        i_wren,   // Write enable,1 if writing,0 if reading
  input  logic [ 3:0] i_bmask,  // Byte mask,1 for enable, otherwise 0
  input  logic [31:0] i_addr,   // Address for both read and write operations
  input  logic [31:0] i_wdata,  // Write data
  output logic [31:0] o_rdata   // Read data
);

  import singlecycle_pkg::*;
  
`ifndef SIMULATION
  // ==================================================
  // Simulation model
  // ==================================================
  logic [3:0][7:0] memory_array [0:(2**MEMORY_WIDTH)-1];

  // Load memory from file
  initial begin
    $readmemh("C:/altera/13.0sp1/CTMT_milestone2/02_test/dump/mem.dump", memory_array, 0, 511);
  end

  // Synchronous write
  always_ff @(posedge i_clk) begin
    if (i_reset) begin
	   // Nothing will be done
    end else if (i_wren && (i_addr[31:11] == MEMORY_ADDR)) begin
      if (i_bmask[0]) memory_array[i_addr[10:2]][0] <= i_wdata[ 7: 0];
      if (i_bmask[1]) memory_array[i_addr[10:2]][1] <= i_wdata[15: 8];
      if (i_bmask[2]) memory_array[i_addr[10:2]][2] <= i_wdata[23:16];
      if (i_bmask[3]) memory_array[i_addr[10:2]][3] <= i_wdata[31:24];
    end
 
    // dump lại ra file
    $writememh("C:/altera/13.0sp1/CTMT_milestone2/02_test/dump/mem.dump", memory_array, 0, 511);
  end

  // Asynchronous read
  assign o_rdata = {memory_array[i_addr[10:2]][3],
                    memory_array[i_addr[10:2]][2],
                    memory_array[i_addr[10:2]][1],
                    memory_array[i_addr[10:2]][0]};

`else
  // ==================================================
  // Synthesis model
  // ==================================================
  mem u_mem (
    .clock   (i_clk),
    .address (i_addr[10:2]),
    .data    (i_wdata),
    .wren    (i_wren),
    .q       (o_rdata)
  );
`endif

endmodule
