//======================================================
// Input Buffer Module
//======================================================
module input_buffer (
  input  logic        i_clk,      // Global clock
  input  logic        i_reset,    // Global active reset
  input  logic [31:0] i_io_sw,    // Input for switches
  output logic [31:0] o_rdata     // Read data
);
  
  import singlecycle_pkg::*;
  
  // ----------------------------------------------------
  // Input buffer array
  // ----------------------------------------------------
  logic [3:0][7:0] ib_array[0:2**IB_WIDTH-1];
  logic [31:0]     io_sw_q;
  
  // ----------------------------------------------------
  // Initialize memory content from file (simulation only)
  // ----------------------------------------------------
  initial begin
    $readmemh("C:/altera/13.0sp1/CTMT_milestone2/02_test/dump/ib.dump", ib_array);
  end

  //====================================================
  // Synchronous write
  //====================================================
  always_ff @(posedge i_clk) begin
    if (i_reset) begin
      // Nothing will be done
    end else begin
      // Update only when input changes
      if (i_io_sw != io_sw_q) begin
        ib_array[0][0] <= i_io_sw[7:0];    // byte 0 (LSB)
        ib_array[0][1] <= i_io_sw[15:8];   // byte 1
        ib_array[0][2] <= i_io_sw[23:16];  // byte 2
        ib_array[0][3] <= i_io_sw[31:24];  // byte 3 (MSB)
        io_sw_q        <= i_io_sw;
      end
    end
  end

  //====================================================
  // Asynchronous read
  //====================================================

  assign o_rdata = {ib_array[0][3],
                    ib_array[0][2],
						  ib_array[0][1],
						  ib_array[0][0]};

endmodule
