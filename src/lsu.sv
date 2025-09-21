//======================================================
// LSU (Load/Store Unit) with memory-mapped I/O
//======================================================
module lsu (
  input  logic        i_clk,        // Global clock
  input  logic        i_reset,      // Global active reset
  input  logic        i_lsu_wren,   // Write enable signal
  input  logic [ 3:0] i_lsu_bmask,  // Byte-enable mask signal (0001 = byte, 0011 = halfword, 1111 = word)
  input  logic        i_lsu_un,     // Unsigned flag signal (1 = unsigned, 0 = signed)
  input  logic [31:0] i_lsu_addr,   // Address for both read and write operations
  input  logic [31:0] i_st_data,    // Store data
  output logic [31:0] o_ld_data,    // Load data
  // Input peripherals
  input  logic [31:0] i_io_sw,      // Input for switches

  // Output peripherals
  output logic [31:0] o_io_ledr,    // Output for red LEDs
  output logic [31:0] o_io_ledg,    // Output for green LEDs
  output logic [ 6:0] o_io_hex7,    // Output for 7-segment displays
  output logic [ 6:0] o_io_hex6,
  output logic [ 6:0] o_io_hex5,
  output logic [ 6:0] o_io_hex4,
  output logic [ 6:0] o_io_hex3,
  output logic [ 6:0] o_io_hex2,
  output logic [ 6:0] o_io_hex1,
  output logic [ 6:0] o_io_hex0,
  output logic [31:0] o_io_lcd      // Output for LCD register
);

  import singlecycle_pkg::*;
  
  // ----------------------------
  // Wires for submodules
  // ----------------------------
  logic [31:0] mem_rdata;
  logic [31:0] ib_rdata;
  logic [31:0] ob_rdata;
  logic [31:0] mux_rdata; // data after 3-1 mux

  // ----------------------------
  // Submodule instantiations
  // ----------------------------

  // Data memory
  memory u_mem (
    .i_clk   (i_clk),
    .i_reset (i_reset),
	 .i_wren  (i_lsu_wren),
	 .i_bmask (i_lsu_bmask),
    .i_addr  (i_lsu_addr),
    .i_wdata (i_st_data),
    .o_rdata (mem_rdata)
  );

  // Output buffer (LEDs, HEX, LCD)
  output_buffer u_outbuf (
    .i_clk    (i_clk),
    .i_reset  (i_reset),
	 .i_wren   (i_lsu_wren),
	 .i_bmask  (i_lsu_bmask),
	 .i_addr   (i_lsu_addr),
    .i_wdata  (i_st_data),
    .o_rdata  (ob_rdata),
    .o_io_ledr(o_io_ledr),
    .o_io_ledg(o_io_ledg),
    .o_io_hex0(o_io_hex0),
    .o_io_hex1(o_io_hex1),
    .o_io_hex2(o_io_hex2),
    .o_io_hex3(o_io_hex3),
    .o_io_hex4(o_io_hex4),
    .o_io_hex5(o_io_hex5),
    .o_io_hex6(o_io_hex6),
    .o_io_hex7(o_io_hex7),
    .o_io_lcd (o_io_lcd)
  );

  // Input buffer (switches)
  input_buffer u_inbuf (
    .i_clk   (i_clk),
    .i_reset (i_reset),
    .i_io_sw (i_io_sw),
    .o_rdata (ib_rdata)
  );

  // ----------------------------
  // 3-1 mux for read data
  // ----------------------------
  always_comb begin
    if (i_lsu_addr[31:11] == MEMORY_ADDR) begin
      mux_rdata = mem_rdata;    // memory region
    end else if ((i_lsu_addr == LEDR_ADDR_BASE)   ||
	              (i_lsu_addr == LEDG_ADDR_BASE)   ||
					  (i_lsu_addr == HEX_30_ADDR_BASE) ||
					  (i_lsu_addr == HEX_74_ADDR_BASE) ||
					  (i_lsu_addr == LCD_ADDR_BASE)) begin
      mux_rdata = ob_rdata;  // output buffer region
    end else if (i_lsu_addr == SW_ADDR_BASE) begin
      mux_rdata = ib_rdata; // input buffer region
	 end else begin
      mux_rdata = 32'h0000_0000;
    end
  end

  // ----------------------------
  // Sign/zero extension unit
  // ----------------------------
  always_comb begin
    unique case (i_lsu_bmask)
      4'b0001: o_ld_data = i_lsu_un ? {24'h0, mux_rdata[7:0]}
                                    : {{24{mux_rdata[7]}}, mux_rdata[7:0]};
      4'b0011: o_ld_data = i_lsu_un ? {16'h0, mux_rdata[15:0]}
                                    : {{16{mux_rdata[15]}}, mux_rdata[15:0]};
      4'b1111: o_ld_data = mux_rdata;
      default: o_ld_data = 32'h0;
    endcase
  end

endmodule
