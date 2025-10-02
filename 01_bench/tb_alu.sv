`timescale 1ns/1ps
module tb_alu;
  logic [31:0] i_op_a;
  logic [31:0] i_op_b;
  logic [3:0]  i_alu_op;   
  logic [31:0] o_alu_data;
	
  alu dut (.i_op_a(i_op_a),
	         .i_op_b(i_op_b),
					 .i_alu_op(i_alu_op),
					 .o_alu_data(o_alu_data)
	);
	
	/*                         MIM(decimal)   |          MAX(decimal)
	  32 bit unsign :           0             |   (2^32)-1   = 4294967295 
	  32 bit sign   : -2^(32-1) = -2147483648 |   (2^32-1)-1 = 2147483647
	*/
	
	
	initial begin
    $display("==== ADD - OPERATION ====");
   	// Case 0:  Tat ca bang 0
	  automatic_case(32'h00000000,32'h00000000,4'b0000);
		$display("Time: %0t ps | Case 0: | i_op_a = %d | i_op_b = %d | i_alu_op = %b | o_alu_data = %d ",
		         $time, i_op_a ,i_op_b ,i_alu_op, o_alu_data);
		
		// Case 1:  Max + 0 = 32'd4294967295
		automatic_case(32'hFFFFFFFF,32'h00000000,4'b0000);
    $display("Time: %0t ps | Case 1: | i_op_a = %d | i_op_b = %d | i_alu_op = %b | o_alu_data = %d ",
		         $time, i_op_a ,i_op_b ,i_alu_op, o_alu_data);
		
    assert(o_alu_data == 32'hFFFFFFFF)
		  else $error("FAIL: Case 1 o_alu_data = %d , Expect: o_alu_data = 32'hFFFFFFFF ", o_alu_data);
			
		// Case 2:  Max + 1 = 0 Overflow
		automatic_case(32'hFFFFFFFF,32'h00000001,4'b0000);
    $display("Time: %0t ps | Case 2: | i_op_a = %d | i_op_b = %d | i_alu_op = %b | o_alu_data = %d ",
		         $time, i_op_a ,i_op_b ,i_alu_op, o_alu_data);
		
    assert(o_alu_data == 32'h00000000)
		  else $error("FAIL: Case 2 o_alu_data = %d , Expect: o_alu_data = 32'h00000000 ", o_alu_data);
			
		// Case 3:  2147483648 + 2147483648 = 4294967296 33 bit Overflow -> 0
		automatic_case(32'd2147483648,32'd2147483648,4'b0000);
    $display("Time: %0t ps | Case 3: | i_op_a = %d | i_op_b = %d | i_alu_op = %b | o_alu_data = %d ",
		         $time, i_op_a ,i_op_b ,i_alu_op, o_alu_data);
		
    assert(o_alu_data == 32'h00000000)
		  else $error("FAIL: Case 3 o_alu_data = %d , Expect: o_alu_data = 32'd4294967295 ", o_alu_data);
		
		// Case 4:  2147483648 + 2147483647 = 4294967295 Max 
		automatic_case(32'd2147483647,32'd2147483648,4'b0000);
    $display("Time: %0t ps | Case 4: | i_op_a = %d | i_op_b = %d | i_alu_op = %b | o_alu_data = %d ",
		         $time, i_op_a ,i_op_b ,i_alu_op, o_alu_data);
		
    assert(o_alu_data == 32'd4294967295)
		  else $error("FAIL: Case 4 o_alu_data = %d , Expect: o_alu_data = 32'd4294967295 ", o_alu_data);
			
		// Case 5: random + random 
		automatic_case(32'd0123456789,32'd1111111111,4'b0000);
    $display("Time: %0t ps | Case 5: | i_op_a = %d | i_op_b = %d | i_alu_op = %b | o_alu_data = %d ",
		         $time, i_op_a ,i_op_b ,i_alu_op, o_alu_data);
		
    assert(o_alu_data == 32'd1234567900)
		  else $error("FAIL: Case 5 o_alu_data = %d , Expect: o_alu_data = 32'd1234567900 ", o_alu_data);
			
		// Case 6: -2147483648 + 2147483647 = -1 Max -> 4294967295
		automatic_case(32'h80000000,32'd2147483647,4'b0000);
    $display("Time: %0t ps | Case 6: | i_op_a = %d | i_op_b = %d | i_alu_op = %b | o_alu_data = %d ",
		         $time, i_op_a ,i_op_b ,i_alu_op, o_alu_data);
		
    assert(o_alu_data == 32'd4294967295)
		  else $error("FAIL: Case 6 o_alu_data = %d , Expect: o_alu_data = 32'd4294967295 ", o_alu_data);	
		
		// Case 7: 2000000000 + 4000000000 = 6000000000 Overflow
		automatic_case(32'd2000000000,32'd4000000000,4'b0000);
    $display("Time: %0t ps | Case 7: | i_op_a = %d | i_op_b = %d | i_alu_op = %b | o_alu_data = %d ",
		         $time, i_op_a ,i_op_b ,i_alu_op, o_alu_data);
		
    assert(o_alu_data == 32'd1705032704)
		  else $error("FAIL: Case 7 o_alu_data = %d , Expect: o_alu_data = 32'd1705032704 ", o_alu_data);	
			
		$display("==== SUB - OPERATION ====");
		
		// Case 8: 4294967295 - 4294967295 = 0
		automatic_case(32'd4294967295,32'd4294967295,4'b0001);
    $display("Time: %0t ps | Case 8: | i_op_a = %d | i_op_b = %d | i_alu_op = %b | o_alu_data = %d ",
		         $time, i_op_a ,i_op_b ,i_alu_op, o_alu_data);
		
    assert(o_alu_data == 32'd0)
		  else $error("FAIL: Case 8 o_alu_data = %d , Expect: o_alu_data = 32'd0000000000 ", o_alu_data);	
		
    // Case 9: 1234567890 - 3214567891 = -1980000001 -> unsign = 2314967295
		automatic_case(32'd1234567890,32'd3214567891,4'b0001);
    $display("Time: %0t ps | Case 9: | i_op_a = %d | i_op_b = %d | i_alu_op = %b | o_alu_data = %d ",
		         $time, i_op_a ,i_op_b ,i_alu_op, o_alu_data);
		
    assert(o_alu_data == 32'd2314967295)
		  else $error("FAIL: Case 9 o_alu_data = %d , Expect: o_alu_data = 32'd2314967295 ", o_alu_data);	
			
    // Case 10: 4000000000 - 1234567890 = 2765432110
		automatic_case(32'd4000000000,32'd1234567890,4'b0001);
    $display("Time: %0t ps | Case 10: | i_op_a = %d | i_op_b = %d | i_alu_op = %b | o_alu_data = %d ",
		         $time, i_op_a ,i_op_b ,i_alu_op, o_alu_data);
		
    assert(o_alu_data == 32'd2765432110)
		  else $error("FAIL: Case 10 o_alu_data = %d , Expect: o_alu_data = 32'd2765432110 ", o_alu_data);
			
		$display("==== SLT - OPERATION ====");
    // Case 11: 4000000000(-294967296) < 1234567890 
		automatic_case(32'd4000000000,32'd1234567890,4'b0010);
    $display("Time: %0t ps | Case 11: | i_op_a = %d | i_op_b = %d | i_alu_op = %b | o_alu_data = %d ",
		         $time, i_op_a ,i_op_b ,i_alu_op, o_alu_data);
		
    assert(o_alu_data == 32'd1)
		  else $error("FAIL: Case 11 o_alu_data = %d , Expect: o_alu_data = 32'd0000000001 ", o_alu_data);
	
    // Case 12: 1111111111 < 1234567890 = 1
		automatic_case(32'd1111111111,32'd1234567890,4'b0010);
    $display("Time: %0t ps | Case 12: | i_op_a = %d | i_op_b = %d | i_alu_op = %b | o_alu_data = %d ",
		         $time, i_op_a ,i_op_b ,i_alu_op, o_alu_data);
		
    assert(o_alu_data == 32'd1)
		  else $error("FAIL: Case 12 o_alu_data = %d , Expect: o_alu_data = 32'd0000000001 ", o_alu_data);
			
    // Case 13: 2222222222 = 2222222222 = 0
		automatic_case(32'd2222222222,32'd2222222222,4'b0010);
    $display("Time: %0t ps | Case 13: | i_op_a = %d | i_op_b = %d | i_alu_op = %b | o_alu_data = %d ",
		         $time, i_op_a ,i_op_b ,i_alu_op, o_alu_data);
		
    assert(o_alu_data == 32'd0)
		  else $error("FAIL: Case 13 o_alu_data = %d , Expect: o_alu_data = 32'd0000000000 ", o_alu_data);
			
    // Case 14: 4294967295(-1) < 1 = 1
		automatic_case(32'd4294967295,32'd1,4'b0010);
    $display("Time: %0t ps | Case 14: | i_op_a = %d | i_op_b = %d | i_alu_op = %b | o_alu_data = %d ",
		         $time, i_op_a ,i_op_b ,i_alu_op, o_alu_data);
		
    assert(o_alu_data == 32'd1)
		  else $error("FAIL: Case 14 o_alu_data = %d , Expect: o_alu_data = 32'd0000000001 ", o_alu_data);
			
    // Case 15: -123(4294967173) < 123 = 1
		automatic_case(32'd4294967173,32'd123,4'b0010);
    $display("Time: %0t ps | Case 15: | i_op_a = %d | i_op_b = %d | i_alu_op = %b | o_alu_data = %d ",
		         $time, i_op_a ,i_op_b ,i_alu_op, o_alu_data);
		
    assert(o_alu_data == 32'd1)
		  else $error("FAIL: Case 15 o_alu_data = %d , Expect: o_alu_data = 32'd0000000001 ", o_alu_data);
			
    // Case 16: 123 > -123(4,294,967,173) = 0
		automatic_case(32'd123,32'd4294967173,4'b0010);
    $display("Time: %0t ps | Case 16: | i_op_a = %d | i_op_b = %d | i_alu_op = %b | o_alu_data = %d ",
		         $time, i_op_a ,i_op_b ,i_alu_op, o_alu_data);
		
    assert(o_alu_data == 32'd0)
		  else $error("FAIL: Case 16 o_alu_data = %d , Expect: o_alu_data = 32'd0000000000 ", o_alu_data);
			
		$display("==== SLTU - OPERATION ====");
    // Case 17: 4000000000 > 1234567890 
		automatic_case(32'd4000000000,32'd1234567890,4'b0011);
    $display("Time: %0t ps | Case 17: | i_op_a = %d | i_op_b = %d | i_alu_op = %b | o_alu_data = %d ",
		         $time, i_op_a ,i_op_b ,i_alu_op, o_alu_data);
		
    assert(o_alu_data == 32'd0)
		  else $error("FAIL: Case 17 o_alu_data = %d , Expect: o_alu_data = 32'd0000000000 ", o_alu_data);
	
    // Case 18: 1111111111 < 1234567890 = 1
		automatic_case(32'd1111111111,32'd1234567890,4'b0011);
    $display("Time: %0t ps | Case 18: | i_op_a = %d | i_op_b = %d | i_alu_op = %b | o_alu_data = %d ",
		         $time, i_op_a ,i_op_b ,i_alu_op, o_alu_data);
		
    assert(o_alu_data == 32'd1)
		  else $error("FAIL: Case 18 o_alu_data = %d , Expect: o_alu_data = 32'd0000000001 ", o_alu_data);
			
    // Case 19: 2222222222 = 2222222222 = 0
		automatic_case(32'd2222222222,32'd2222222222,4'b0011);
    $display("Time: %0t ps | Case 19: | i_op_a = %d | i_op_b = %d | i_alu_op = %b | o_alu_data = %d ",
		         $time, i_op_a ,i_op_b ,i_alu_op, o_alu_data);
		
    assert(o_alu_data == 32'd0)
		  else $error("FAIL: Case 19 o_alu_data = %d , Expect: o_alu_data = 32'd0000000000 ", o_alu_data);
			
    // Case 20: 4294967295 > 1 = 0
		automatic_case(32'd4294967295,32'd1,4'b0011);
    $display("Time: %0t ps | Case 20: | i_op_a = %d | i_op_b = %d | i_alu_op = %b | o_alu_data = %d ",
		         $time, i_op_a ,i_op_b ,i_alu_op, o_alu_data);
		
    assert(o_alu_data == 32'd0)
		  else $error("FAIL: Case 20 o_alu_data = %d , Expect: o_alu_data = 32'd0000000000 ", o_alu_data);
			
    // Case 21: (4294967173) > 123 = 0
		automatic_case(32'd4294967173,32'd123,4'b0011);
    $display("Time: %0t ps | Case 21: | i_op_a = %d | i_op_b = %d | i_alu_op = %b | o_alu_data = %d ",
		         $time, i_op_a ,i_op_b ,i_alu_op, o_alu_data);
		
    assert(o_alu_data == 32'd0)
		  else $error("FAIL: Case 21 o_alu_data = %d , Expect: o_alu_data = 32'd0000000000 ", o_alu_data);
			
    // Case 22: 123 < (4,294,967,173) = 1
		automatic_case(32'd123,32'd4294967173,4'b0011);
    $display("Time: %0t ps | Case 22: | i_op_a = %d | i_op_b = %d | i_alu_op = %b | o_alu_data = %d ",
		         $time, i_op_a ,i_op_b ,i_alu_op, o_alu_data);
		
    assert(o_alu_data == 32'd1)
		  else $error("FAIL: Case 22 o_alu_data = %d , Expect: o_alu_data = 32'd0000000001 ", o_alu_data);
			
    $display("==== XOR - OPERATION ====");
    // Case 23: 32'hFFFFFFFF xor 32'hFFFFFFFF = 0
		automatic_case(32'hFFFFFFFF,32'hFFFFFFFF,4'b0100);
    $display("Time: %0t ps | Case 23: | i_op_a = %d | i_op_b = %d | i_alu_op = %b | o_alu_data = %d ",
		         $time, i_op_a ,i_op_b ,i_alu_op, o_alu_data);
		
    assert(o_alu_data == 32'd0)
		  else $error("FAIL: Case 24 o_alu_data = %d , Expect: o_alu_data = 32'd0000000000 ", o_alu_data);
			
		// Case 24: 32'hFFFFFFFF xor 32'h0 = 32'h4294967295
		automatic_case(32'h00000000,32'hFFFFFFFF,4'b0100);
    $display("Time: %0t ps | Case 24: | i_op_a = %d | i_op_b = %d | i_alu_op = %b | o_alu_data = %d ",
		         $time, i_op_a ,i_op_b ,i_alu_op, o_alu_data);
		
    assert(o_alu_data == 32'd4294967295)
		  else $error("FAIL: Case 25 o_alu_data = %d , Expect: o_alu_data = 32'd4294967295 ", o_alu_data);
			
		// Case 25: 32'h0 xor 32'h0 = 32'h0
		automatic_case(32'd0,32'd0,4'b0100);
    $display("Time: %0t ps | Case 25: | i_op_a = %d | i_op_b = %d | i_alu_op = %b | o_alu_data = %d ",
		         $time, i_op_a ,i_op_b ,i_alu_op, o_alu_data);
		
    assert(o_alu_data == 32'd0)
		  else $error("FAIL: Case 25 o_alu_data = %d , Expect: o_alu_data = 32'd0 ", o_alu_data);
			
		// Case 26: 32'h0 xor 32'hFFFFFFFF = 32'h
		automatic_case(32'hFFFFFFFF,32'd0,4'b0100);
    $display("Time: %0t ps | Case 26: | i_op_a = %d | i_op_b = %d | i_alu_op = %b | o_alu_data = %d ",
		         $time, i_op_a ,i_op_b ,i_alu_op, o_alu_data);
		
    assert(o_alu_data == 32'd4294967295)
		  else $error("FAIL: Case 26 o_alu_data = %d , Expect: o_alu_data = 32'd4294967295 ", o_alu_data);
	
    $display("==== OR - OPERATION ====");
    // Case 27: 32'hFFFFFFFF or 32'hFFFFFFFF = 32'hFFFFFFFF
		automatic_case(32'hFFFFFFFF,32'hFFFFFFFF,4'b0101);
    $display("Time: %0t ps | Case 27: | i_op_a = %d | i_op_b = %d | i_alu_op = %b | o_alu_data = %d ",
		         $time, i_op_a ,i_op_b ,i_alu_op, o_alu_data);
		
    assert(o_alu_data == 32'd4294967295)
		  else $error("FAIL: Case 27 o_alu_data = %d , Expect: o_alu_data = 32'd4294967295 ", o_alu_data);
			
		// Case 28: 32'hFFFFFFFF or 32'h0 = 32'h4294967295
		automatic_case(32'h00000000,32'hFFFFFFFF,4'b0101);
    $display("Time: %0t ps | Case 28: | i_op_a = %d | i_op_b = %d | i_alu_op = %b | o_alu_data = %d ",
		         $time, i_op_a ,i_op_b ,i_alu_op, o_alu_data);
		
    assert(o_alu_data == 32'd4294967295)
		  else $error("FAIL: Case 25 o_alu_data = %d , Expect: o_alu_data = 32'd4294967295 ", o_alu_data);
			
		// Case 29: 32'h0 or 32'h0 = 32'h0
		automatic_case(32'd0,32'd0,4'b0101);
    $display("Time: %0t ps | Case 29: | i_op_a = %d | i_op_b = %d | i_alu_op = %b | o_alu_data = %d ",
		         $time, i_op_a ,i_op_b ,i_alu_op, o_alu_data);
		
    assert(o_alu_data == 32'd0)
		  else $error("FAIL: Case 29 o_alu_data = %d , Expect: o_alu_data = 32'd0 ", o_alu_data);
			
		// Case 30: 32'h0 or 32'hFFFFFFFF = 32'hFFFFFFFF
		automatic_case(32'hFFFFFFFF,32'd0,4'b0101);
    $display("Time: %0t ps | Case 30: | i_op_a = %d | i_op_b = %d | i_alu_op = %b | o_alu_data = %d ",
		         $time, i_op_a ,i_op_b ,i_alu_op, o_alu_data);
		
    assert(o_alu_data == 32'd4294967295)
		  else $error("FAIL: Case 30 o_alu_data = %d , Expect: o_alu_data = 32'd4294967295 ", o_alu_data);
			
    $display("==== AND - OPERATION ====");
    // Case 31: 32'hFFFFFFFF or 32'hFFFFFFFF = 32'hFFFFFFFF
		automatic_case(32'hFFFFFFFF,32'hFFFFFFFF,4'b0110);
    $display("Time: %0t ps | Case 31: | i_op_a = %d | i_op_b = %d | i_alu_op = %b | o_alu_data = %d ",
		         $time, i_op_a ,i_op_b ,i_alu_op, o_alu_data);
		
    assert(o_alu_data == 32'd4294967295)
		  else $error("FAIL: Case 31 o_alu_data = %d , Expect: o_alu_data = 32'd4294967295 ", o_alu_data);
			
		// Case 32: 32'hFFFFFFFF or 32'h0 = 32'h0
		automatic_case(32'h00000000,32'hFFFFFFFF,4'b0110);
    $display("Time: %0t ps | Case 32: | i_op_a = %d | i_op_b = %d | i_alu_op = %b | o_alu_data = %d ",
		         $time, i_op_a ,i_op_b ,i_alu_op, o_alu_data);
		
    assert(o_alu_data == 32'd0)
		  else $error("FAIL: Case 32 o_alu_data = %d , Expect: o_alu_data = 32'd0 ", o_alu_data);
			
		// Case 33: 32'h0 and 32'h0 = 32'h0
		automatic_case(32'd0,32'd0,4'b0110);
    $display("Time: %0t ps | Case 33: | i_op_a = %d | i_op_b = %d | i_alu_op = %b | o_alu_data = %d ",
		         $time, i_op_a ,i_op_b ,i_alu_op, o_alu_data);
		
    assert(o_alu_data == 32'd0)
		  else $error("FAIL: Case 33 o_alu_data = %d , Expect: o_alu_data = 32'd0 ", o_alu_data);
			
		// Case 34: 32'h0 and 32'hFFFFFFFF = 32'h0
		automatic_case(32'hFFFFFFFF,32'd0,4'b0110);
    $display("Time: %0t ps | Case 34: | i_op_a = %d | i_op_b = %d | i_alu_op = %b | o_alu_data = %d ",
		         $time, i_op_a ,i_op_b ,i_alu_op, o_alu_data);
		
    assert(o_alu_data == 32'd0)
		  else $error("FAIL: Case 34 o_alu_data = %d , Expect: o_alu_data = 32'd4294967295 ", o_alu_data);
			
    $display("==== SLL - OPERATION ====");
		// Case 35: 32'hFFFFFFFF SLL 32'h5
		automatic_case(32'hFFFFFFFF,32'd5,4'b0111);
    $display("Time: %0t ps | Case 35: | i_op_a = %d | i_op_b = %d | i_alu_op = %b | o_alu_data = %d ",
		         $time, i_op_a ,i_op_b ,i_alu_op, o_alu_data);
		
    assert(o_alu_data == 32'd4294967264)
		  else $error("FAIL: Case 35 o_alu_data = %d , Expect: o_alu_data = 32'd4294967264 ", o_alu_data);
			
		// Case 36: 32'hFFFFFFFF SLL 32'h0
		automatic_case(32'hFFFFFFFF,32'd0,4'b0111);
    $display("Time: %0t ps | Case 36: | i_op_a = %d | i_op_b = %d | i_alu_op = %b | o_alu_data = %d ",
		         $time, i_op_a ,i_op_b ,i_alu_op, o_alu_data);
		
    assert(o_alu_data == 32'hFFFFFFFF)
		  else $error("FAIL: Case 36 o_alu_data = %d , Expect: o_alu_data = 32'hFFFFFFFF ", o_alu_data);
	
		// Case 37: 32'hFFFFFFFF SLL 32'd32
		automatic_case(32'hFFFFFFFF,32'd31,4'b0111);
    $display("Time: %0t ps | Case 37: | i_op_a = %d | i_op_b = %d | i_alu_op = %b | o_alu_data = %d ",
		         $time, i_op_a ,i_op_b ,i_alu_op, o_alu_data);
		
    assert(o_alu_data == 32'd2147483648)
		  else $error("FAIL: Case 37 o_alu_data = %d , Expect: o_alu_data = 32'd2147483648 ", o_alu_data);
			
    $display("==== SRL - OPERATION ====");
		// Case 38: 32'hFFFFFFFF SRL 32'h6
		automatic_case(32'hFFFFFFFF,32'd6,4'b1000);
    $display("Time: %0t ps | Case 38: | i_op_a = %d | i_op_b = %d | i_alu_op = %b | o_alu_data = %d ",
		         $time, i_op_a ,i_op_b ,i_alu_op, o_alu_data);
		
    assert(o_alu_data == 32'd67108863)
		  else $error("FAIL: Case 38 o_alu_data = %d , Expect: o_alu_data = 32'd67108863 ", o_alu_data);
			
		// Case 38: 32'hFFFFFFFF SRL 32'h0
		automatic_case(32'hFFFFFFFF,32'd0,4'b1000);
    $display("Time: %0t ps | Case 38: | i_op_a = %d | i_op_b = %d | i_alu_op = %b | o_alu_data = %d ",
		         $time, i_op_a ,i_op_b ,i_alu_op, o_alu_data);
		
    assert(o_alu_data == 32'hFFFFFFFF)
		  else $error("FAIL: Case 38 o_alu_data = %d , Expect: o_alu_data = 32'hFFFFFFFF ", o_alu_data);
	
		// Case 39: 32'hFFFFFFFF SRL 32'd31
		automatic_case(32'hFFFFFFFF,32'd31,4'b1000);
    $display("Time: %0t ps | Case 39: | i_op_a = %d | i_op_b = %d | i_alu_op = %b | o_alu_data = %d ",
		         $time, i_op_a ,i_op_b ,i_alu_op, o_alu_data);
		
    assert(o_alu_data == 32'd1)
		  else $error("FAIL: Case 39 o_alu_data = %d , Expect: o_alu_data = 32'd1 ", o_alu_data);
			
    $display("==== SRA - OPERATION ====");
		// Case 40: -123(4294967173) SRA 32'h6 = -2(4294967294)
		automatic_case(32'd4294967173,32'd6,4'b1001);
    $display("Time: %0t ps | Case 40: | i_op_a = %d | i_op_b = %d | i_alu_op = %b | o_alu_data = %d ",
		         $time, i_op_a ,i_op_b ,i_alu_op, o_alu_data);
		
    assert(o_alu_data == 32'd4294967294)
		  else $error("FAIL: Case 40 o_alu_data = %d , Expect: o_alu_data = 32'd4294967294 ", o_alu_data);
			
		// Case 41: 36 SRA 32'h6
		automatic_case(32'd36,32'd31,4'b1001);
    $display("Time: %0t ps | Case 41: | i_op_a = %d | i_op_b = %d | i_alu_op = %b | o_alu_data = %d ",
		         $time, i_op_a ,i_op_b ,i_alu_op, o_alu_data);
		
    assert(o_alu_data == 32'd0)
		  else $error("FAIL: Case 41 o_alu_data = %d , Expect: o_alu_data = 32'd0 ", o_alu_data);

		// Case 42: 2147483647 SRA 32'h0
		automatic_case(32'd2147483647,32'd0,4'b1001);
    $display("Time: %0t ps | Case 42: | i_op_a = %d | i_op_b = %d | i_alu_op = %b | o_alu_data = %d ",
		         $time, i_op_a ,i_op_b ,i_alu_op, o_alu_data);
		
    assert(o_alu_data == 32'd2147483647)
		  else $error("FAIL: Case 42 o_alu_data = %d , Expect: o_alu_data = 32'd2147483647 ", o_alu_data);

		// Case 43: 2147483647 SRA 32'h6
		automatic_case(32'd2147483647,32'd6,4'b1001);
    $display("Time: %0t ps | Case 43: | i_op_a = %d | i_op_b = %d | i_alu_op = %b | o_alu_data = %d ",
		         $time, i_op_a ,i_op_b ,i_alu_op, o_alu_data);
		
    assert(o_alu_data == 32'd33554431)
		  else $error("FAIL: Case 43 o_alu_data = %d , Expect: o_alu_data = 32'd33554431 ", o_alu_data);
	
	
	  #20;
		$display("==== All testcases finished ====");
		$finish;
	end 
	
	task automatic_case;
	  input [31:0] op_a;
		input [31:0] op_b;
		input [3:0] alu_op;
		begin
		  i_op_a = op_a;
			i_op_b = op_b;
			i_alu_op = alu_op;
			#40;
		end 
  endtask 
	

endmodule
