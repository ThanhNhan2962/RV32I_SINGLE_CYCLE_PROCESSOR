//======================================================
// 32-bit Logical Shift Left (SLL)
//======================================================
module sll_32b (
  input  logic [31:0] i_a,        // Operand to be shifted
  input  logic [ 4:0] i_shamt,    // Shift amount (0..31)
  output logic [31:0] o_result    // Shifted result
);

  always_comb begin
    case (i_shamt)
      5'b00000: o_result = i_a;                // No shift
      5'b00001: o_result = {i_a[30:0],  1'b0}; // Shift left by 1 bit
      5'b00010: o_result = {i_a[29:0],  2'b0}; // Shift left by 2 bit
      5'b00011: o_result = {i_a[28:0],  3'b0}; // Shift left by 3 bit
      5'b00100: o_result = {i_a[27:0],  4'b0}; // Shift left by 4 bit
      5'b00101: o_result = {i_a[26:0],  5'b0}; // Shift left by 5 bit
      5'b00110: o_result = {i_a[25:0],  6'b0}; // Shift left by 6 bit
      5'b00111: o_result = {i_a[24:0],  7'b0}; // Shift left by 7 bit
      5'b01000: o_result = {i_a[23:0],  8'b0}; // Shift left by 8 bit
      5'b01001: o_result = {i_a[22:0],  9'b0}; // Shift left by 9 bit
      5'b01010: o_result = {i_a[21:0], 10'b0}; // Shift left by 10 bit
      5'b01011: o_result = {i_a[20:0], 11'b0}; // Shift left by 11 bit
      5'b01100: o_result = {i_a[19:0], 12'b0}; // Shift left by 12 bit
      5'b01101: o_result = {i_a[18:0], 13'b0}; // Shift left by 13 bit
      5'b01110: o_result = {i_a[17:0], 14'b0}; // Shift left by 14 bit
      5'b01111: o_result = {i_a[16:0], 15'b0}; // Shift left by 15 bit
      5'b10000: o_result = {i_a[15:0], 16'b0}; // Shift left by 16 bit
      5'b10001: o_result = {i_a[14:0], 17'b0}; // Shift left by 17 bit
      5'b10010: o_result = {i_a[13:0], 18'b0}; // Shift left by 18 bit
      5'b10011: o_result = {i_a[12:0], 19'b0}; // Shift left by 19 bit
      5'b10100: o_result = {i_a[11:0], 20'b0}; // Shift left by 20 bit
      5'b10101: o_result = {i_a[10:0], 21'b0}; // Shift left by 21 bit
      5'b10110: o_result = {i_a[ 9:0], 22'b0}; // Shift left by 22 bit
      5'b10111: o_result = {i_a[ 8:0], 23'b0}; // Shift left by 23 bit
      5'b11000: o_result = {i_a[ 7:0], 24'b0}; // Shift left by 24 bit
      5'b11001: o_result = {i_a[ 6:0], 25'b0}; // Shift left by 25 bit
      5'b11010: o_result = {i_a[ 5:0], 26'b0}; // Shift left by 26 bit
      5'b11011: o_result = {i_a[ 4:0], 27'b0}; // Shift left by 27 bit
      5'b11100: o_result = {i_a[ 3:0], 28'b0}; // Shift left by 28 bit
      5'b11101: o_result = {i_a[ 2:0], 29'b0}; // Shift left by 29 bit
      5'b11110: o_result = {i_a[ 1:0], 30'b0}; // Shift left by 30 bit
      5'b11111: o_result = {i_a[   0], 31'b0}; // Shift left by 31 bit
      default:  o_result = 32'b0;              // Invalid shift
    endcase
  end

endmodule