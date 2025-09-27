//======================================================
// 32-bit Arithmetic Shift Right (SRA)
//======================================================
module sra_32b (
  input  logic [31:0] i_a,        // Operand to be shifted (signed)
  input  logic [ 4:0] i_shamt,    // Shift amount (0..31)
  output logic [31:0] o_result    // Shifted result
);

  always_comb begin
    case (i_shamt)
      5'b00000: o_result = i_a;                         // No shift
      5'b00001: o_result = {      i_a[31], i_a[31:1]};  // Shift right by 1 bit
      5'b00010: o_result = {{ 2{i_a[31]}}, i_a[31:2]};  // Shift right by 2 bit
      5'b00011: o_result = {{ 3{i_a[31]}}, i_a[31:3]};  // Shift right by 3 bit
      5'b00100: o_result = {{ 4{i_a[31]}}, i_a[31:4]};  // Shift right by 4 bit
      5'b00101: o_result = {{ 5{i_a[31]}}, i_a[31:5]};  // Shift right by 5 bit
      5'b00110: o_result = {{ 6{i_a[31]}}, i_a[31:6]};  // Shift right by 6 bit
      5'b00111: o_result = {{ 7{i_a[31]}}, i_a[31:7]};  // Shift right by 7 bit
      5'b01000: o_result = {{ 8{i_a[31]}}, i_a[31:8]};  // Shift right by 8 bit
      5'b01001: o_result = {{ 9{i_a[31]}}, i_a[31:9]};  // Shift right by 9 bit
      5'b01010: o_result = {{10{i_a[31]}}, i_a[31:10]}; // Shift right by 10 bit
      5'b01011: o_result = {{11{i_a[31]}}, i_a[31:11]}; // Shift right by 11 bit
      5'b01100: o_result = {{12{i_a[31]}}, i_a[31:12]}; // Shift right by 12 bit
      5'b01101: o_result = {{13{i_a[31]}}, i_a[31:13]}; // Shift right by 13 bit
      5'b01110: o_result = {{14{i_a[31]}}, i_a[31:14]}; // Shift right by 14 bit
      5'b01111: o_result = {{15{i_a[31]}}, i_a[31:15]}; // Shift right by 15 bit
      5'b10000: o_result = {{16{i_a[31]}}, i_a[31:16]}; // Shift right by 16 bit
      5'b10001: o_result = {{17{i_a[31]}}, i_a[31:17]}; // Shift right by 17 bit
      5'b10010: o_result = {{18{i_a[31]}}, i_a[31:18]}; // Shift right by 18 bit
      5'b10011: o_result = {{19{i_a[31]}}, i_a[31:19]}; // Shift right by 19 bit
      5'b10100: o_result = {{20{i_a[31]}}, i_a[31:20]}; // Shift right by 20 bit
      5'b10101: o_result = {{21{i_a[31]}}, i_a[31:21]}; // Shift right by 21 bit
      5'b10110: o_result = {{22{i_a[31]}}, i_a[31:22]}; // Shift right by 22 bit
      5'b10111: o_result = {{23{i_a[31]}}, i_a[31:23]}; // Shift right by 23 bit
      5'b11000: o_result = {{24{i_a[31]}}, i_a[31:24]}; // Shift right by 24 bit
      5'b11001: o_result = {{25{i_a[31]}}, i_a[31:25]}; // Shift right by 25 bit
      5'b11010: o_result = {{26{i_a[31]}}, i_a[31:26]}; // Shift right by 26 bit
      5'b11011: o_result = {{27{i_a[31]}}, i_a[31:27]}; // Shift right by 27 bit
      5'b11100: o_result = {{28{i_a[31]}}, i_a[31:28]}; // Shift right by 28 bit
      5'b11101: o_result = {{29{i_a[31]}}, i_a[31:29]}; // Shift right by 29 bit
      5'b11110: o_result = {{30{i_a[31]}}, i_a[31:30]}; // Shift right by 30 bit
      5'b11111: o_result = {{31{i_a[31]}}, i_a[31]};    // Shift right by 31 bit
      default:  o_result = 32'b0;
    endcase
  end

endmodule
