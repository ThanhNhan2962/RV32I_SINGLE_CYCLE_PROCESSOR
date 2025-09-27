//tb_brc.sv
module tb_brc ();
  
  //Interface signals
  logic [31:0] tb_i_rs1_data, tb_i_rs2_data;
  logic        tb_i_br_un;
  logic        tb_o_br_less, tb_o_br_equal;
  
  //Instantiate DUT
  brc DUT (
    .i_rs1_data (tb_i_rs1_data),
    .i_rs2_data (tb_i_rs2_data),
    .i_br_un (tb_i_br_un),
    .o_br_less (tb_o_br_less),
    .o_br_equal (tb_o_br_equal)
  );
  
  //Task: run a single testcase
  task automatic run_test (
    input logic [31:0] rs1,
    input logic [31:0] rs2,
    input logic        br_un,
    input logic        exp_less,
    input logic        exp_equal,
    input string       test_name
  );
  
    begin
      tb_i_rs1_data = rs1;
      tb_i_rs2_data = rs2;
      tb_i_br_un = br_un;
      #1; //Wait for combinational for logic to setle
    
      if (tb_o_br_less !== exp_less)
        $error ("[%s] o_br_less mismatch: got %b, expected %b", test_name, tb_o_br_less, exp_less);
      if (tb_o_br_equal !== exp_equal)
        $error("[%s] o_br_equal mismatch: got %b, expected %b", test_name, tb_o_br_equal, exp_equal);
      else
        $display("[%s] PASS", test_name);
    end
  endtask 
  
  // Initial block to run all tests
  initial begin
    $display ("=== BRC Testbench Start ===");
    // Test 1: Equal values
    run_test(32'd42, 32'd42, 1'b0, 1'b0, 1'b1, "Equal Signed");

    // Test 2: rs1 < rs2 (signed)
    run_test(-32'd10, 32'd5, 1'b0, 1'b1, 1'b0, "Less Signed");

    // Test 3: rs1 > rs2 (signed)
    run_test(32'd100, -32'd50, 1'b0, 1'b0, 1'b0, "Greater Signed");

    // Test 4: rs1 < rs2 (unsigned)
    run_test(32'd1, 32'd2, 1'b1, 1'b1, 1'b0, "Less Unsigned");

    // Test 5: rs1 > rs2 (unsigned)
    run_test(32'hFFFFFFFE, 32'd1, 1'b1, 1'b0, 1'b0, "Greater Unsigned");
    
    // Test 6: rs1 = 0, rs2 = MAX_INT (unsigned)
    run_test(32'd0, 32'hFFFFFFFF, 1'b1, 1'b1, 1'b0, "Zero vs Max Unsigned");

    // Test 7: rs1 = MIN_INT, rs2 = 0 (signed)
    run_test(32'h80000000, 32'd0, 1'b0, 1'b1, 1'b0, "Min Signed vs Zero");

    // Test 8: rs1 = rs2 = 0
    run_test(32'd0, 32'd0, 1'b0, 1'b0, 1'b1, "Zero Equal");

    // Test 9: rs1 = rs2 = MAX_INT
    run_test(32'hFFFFFFFF, 32'hFFFFFFFF, 1'b1, 1'b0, 1'b1, "Max Equal Unsigned");


    $display("=== BRC Testbench Complete ===");
    $stop;
  end
  
  initial begin
    $dumpfile("D:/CTMT/Milestones/Milestone_2/milestone2/10_sim/tb_brc.vcd");     // Tên file VCD
    $dumpvars(0, tb_brc);               // Ghi toàn b? tín hi?u trong tb_brc
  end

endmodule
    