//======================================================
// Register File (32 x 32-bit)
//======================================================
module regfile (
  input  logic        i_clk,       // Global clock
  input  logic        i_reset,     // Global active reset
  input  logic [ 4:0] i_rs1_addr,  // Address of the first source register
  input  logic [ 4:0] i_rs2_addr,  // Address of the second source register
  input  logic [ 4:0] i_rd_addr,   // Address of the destination register
  input  logic [31:0] i_rd_data,   // Data to write to the destination register
  input  logic        i_rd_wren,   // Write enable for the destination register
  output logic [31:0] o_rs1_data,  // Data from the first source register
  output logic [31:0] o_rs2_data   // Data from the second source register
);


  // Array of 32 registers, each 32 bits
  logic [31:0] register [31:0];

  //====================================================
  // Asynchronous read
  //====================================================
  always_comb begin
    o_rs1_data = register[i_rs1_addr];
    o_rs2_data = register[i_rs2_addr];
  end

  //====================================================
  // Synchronous write
  //====================================================
  always_ff @(posedge i_clk) begin
    if (i_reset) begin
      // Reset all registers to zero
      register[ 0] <= 32'b0;
      register[ 1] <= 32'b0;
      register[ 2] <= 32'b0;
      register[ 3] <= 32'b0;
      register[ 4] <= 32'b0;
      register[ 5] <= 32'b0;
      register[ 6] <= 32'b0;
      register[ 7] <= 32'b0;
      register[ 8] <= 32'b0;
      register[ 9] <= 32'b0;
      register[10] <= 32'b0;
      register[11] <= 32'b0;
      register[12] <= 32'b0;
      register[13] <= 32'b0;
      register[14] <= 32'b0;
      register[15] <= 32'b0;
      register[16] <= 32'b0;
      register[17] <= 32'b0;
      register[18] <= 32'b0;
      register[19] <= 32'b0;
      register[20] <= 32'b0;
      register[21] <= 32'b0;
      register[22] <= 32'b0;
      register[23] <= 32'b0;
      register[24] <= 32'b0;
      register[25] <= 32'b0;
      register[26] <= 32'b0;
      register[27] <= 32'b0;
      register[28] <= 32'b0;
      register[29] <= 32'b0;
      register[30] <= 32'b0;
      register[31] <= 32'b0;
    end else if (i_rd_wren) begin
      // Write operation (x0 is hardwired to 0)
      if (i_rd_addr != 5'b00000) begin
        register[i_rd_addr] <= i_rd_data;
      end
    end
  end

endmodule
