//======================================================
// 2-to-1 Multiplexer, 32-bit
//======================================================
module mux2_32b (
    input  logic [31:0] i_d0,   // Input 0
    input  logic [31:0] i_d1,   // Input 1
    input  logic        i_sel,  // Select (0 -> d0, 1 -> d1)
    output logic [31:0] o_y     // Output
);

  assign o_y = (i_sel) ? i_d1 : i_d0;

endmodule
