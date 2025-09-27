//======================================================
// Output Buffer Module
//======================================================
module output_buffer (
  input  logic        i_clk,      // Global clock, active on the rising edge
  input  logic        i_reset,    // Global active reset
  input  logic        i_wren,     // Write enable, 1 if writing, 0 if reading
  input  logic [ 3:0] i_bmask,    // Byte mask, 1 for enable, otherwise 0
  input  logic [31:0] i_addr,     // Address for data read/write
  input  logic [31:0] i_wdata,    // Write data
  output logic [31:0] o_rdata,    // Read data
  output logic [31:0] o_io_ledr,  // Output for red LEDs
  output logic [31:0] o_io_ledg,  // Output for green LEDs
  output logic [ 6:0] o_io_hex0,  // Output for 7-segment displays
  output logic [ 6:0] o_io_hex1,
  output logic [ 6:0] o_io_hex2,
  output logic [ 6:0] o_io_hex3,
  output logic [ 6:0] o_io_hex4,
  output logic [ 6:0] o_io_hex5,
  output logic [ 6:0] o_io_hex6,
  output logic [ 6:0] o_io_hex7,
  output logic [31:0] o_io_lcd    // Output for LCD register
);

  import singlecycle_pkg::*;
  
  //======================================================
  // Output buffer array
  //======================================================
  logic [3:0][7:0] ob_array[0:2**OB_WIDTH-1];
  
  //======================================================
  // Load initial content from file (simulation only)
  //======================================================
  initial begin
    $readmemh("C:/altera/13.0sp1/CTMT_milestone2/02_test/dump/ob.dump", ob_array);
  end
  
  // ----------------------------------------------------
  // Function: Map address to ob_array index
  // ----------------------------------------------------
  function automatic logic [2:0] addr_to_index(input logic [31:0] i_addr, output logic valid);
    begin
      case (i_addr)
        LEDR_ADDR_BASE: begin
		    addr_to_index = 3'd0;
		    valid = 1;
		  end
        LEDG_ADDR_BASE: begin
          addr_to_index = 3'd1;
          valid = 1;
        end
        HEX_30_ADDR_BASE: begin
          addr_to_index = 3'd2;
          valid = 1;
        end
        HEX_74_ADDR_BASE: begin
          addr_to_index = 3'd3;
          valid = 1;
        end
        LCD_ADDR_BASE: begin
          addr_to_index = 3'd4;
          valid = 1;
        end
        default: begin
          addr_to_index = 3'd0;
          valid = 0;
        end
      endcase
    end
  endfunction
  
  //======================================================
  // Compute index and valid flag continuously
  //======================================================
  logic [2:0] idx;
  logic valid;
  always_comb idx = addr_to_index(i_addr, valid);
  
  //======================================================
  // Synchronous write
  //======================================================
  always_ff @(posedge i_clk) begin
    if (i_reset) begin
	   // Nothing will be done
    end else if (i_wren) begin
      if (valid) begin
        if (i_bmask[0]) ob_array[idx][0] <= i_wdata[ 7: 0];
        if (i_bmask[1]) ob_array[idx][1] <= i_wdata[15: 8];
        if (i_bmask[2]) ob_array[idx][2] <= i_wdata[23:16];
        if (i_bmask[3]) ob_array[idx][3] <= i_wdata[31:24];
      end

      $writememh("C:/altera/13.0sp1/CTMT_milestone2/02_test/dump/ob.dump", ob_array);
    end
  end

  // Asynchronous read
  always_comb begin
    if (valid)
      o_rdata = {ob_array[idx][3], ob_array[idx][2], ob_array[idx][1], ob_array[idx][0]};
    else
      o_rdata = 32'b0;
  end
	
  // Address red leds: 0x1000_0000
  assign o_io_ledr = {ob_array[0][3],
                      ob_array[0][2],
                      ob_array[0][1],
                      ob_array[0][0]};
	
  // Address green leds: 0x1000_1000
  assign o_io_ledg = {ob_array[1][3],
                      ob_array[1][2],
                      ob_array[1][1],
                      ob_array[1][0]};
	
  // Address seven-segment 3-0 leds: 0x1000_2000
  assign o_io_hex0 = ob_array[2][0][6:0];
  assign o_io_hex1 = ob_array[2][1][6:0];
  assign o_io_hex2 = ob_array[2][2][6:0];
  assign o_io_hex3 = ob_array[2][3][6:0];
	
  // Address seven-segment 7-4 leds: 0x1000_3000
  assign o_io_hex4 = ob_array[3][0][6:0];
  assign o_io_hex5 = ob_array[3][1][6:0];
  assign o_io_hex6 = ob_array[3][2][6:0];
  assign o_io_hex7 = ob_array[3][3][6:0];
	
  // Address lcd control registers: 0x1000_4000
  assign o_io_lcd = {ob_array[4][3],
                     ob_array[4][2],
                     ob_array[4][1],
                     ob_array[4][0]};

endmodule
