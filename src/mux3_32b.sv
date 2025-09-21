//======================================================
// 3-to-1 Multiplexer, 32-bit
//======================================================
module mux3_32b (
    input  logic [31:0] i_d0,   // Input 0
    input  logic [31:0] i_d1,   // Input 1
    input  logic [31:0] i_d2,   // Input 2
    input  logic [1:0]  i_sel,  // Select (00 -> d0, 01 -> d1, 10 -> d2)
    output logic [31:0] o_y     // Output
);

  always_comb begin
    unique case (i_sel)
      2'b00:   o_y = i_d0;
      2'b01:   o_y = i_d1;
      2'b10:   o_y = i_d2;
      default: o_y = 32'b0;
    endcase
  end

endmodule