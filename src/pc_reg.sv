//======================================================
// Program Counter Register (PC Register)
//======================================================
module pc_reg (
    input  logic        i_clk,      // Global clock
    input  logic        i_reset,    // Global active reset
    input  logic        i_pc_wren,  // RC write enable , 1: enable, 0: disable
	 input  logic [30:0] i_pc_next,  // Next PC value
    output logic [30:0] o_pc        // Current PC value
);

  // Sequential process for PC register
  always_ff @(posedge i_clk) begin
    if (i_reset) begin
      o_pc <= 31'd0;       // Reset to 0
    end else if (i_pc_wren) begin
      o_pc <= i_pc_next;     // Update with next PC
    end
  end

endmodule
