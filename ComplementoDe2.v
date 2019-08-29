module altonivel (input signed [3:0]x, output [4:0]y);
	assign y = (x>=0)? x+3:x-2;
endmodule

module soma (input [3:0]x, output [4:0]y);

	assign y[4] = x[3];
	assign y[3] = ((x[3] & x[1]) | (x[2] & x[1]) | (x[0] & x[2]) | (x[2] & x[3]) );
	assign y[2] = ((x[1] & x[2] & x[3]) | (x[1] & ~x[2] & ~x[3]) | (x[0] & ~x[1] & ~x[2]) | 
			(x[3] & ~x[1] & ~x[2]) | (x[2] & ~x[0] & ~x[1] & ~x[3]));
	assign y[1] = ((x[0] & x[1] & ~x[3]) | (~x[1] & x[3]) | (~x[0] & ~x[1]));
	assign y[0] = ((~x[0] & ~x[3]) | (x[0] & x[3]));

endmodule

module teste;

	reg signed [3:0] a,b;
	wire signed [4:0]y,z;

	altonivel CP(a,y);
	soma CP2(b,z);

	integer i;	
	initial begin
		$monitor("x= %d y= %d ", b,z);
		for(i= -4'd8; i<8 ; i = i+1)
		  begin
			a = i; #1;
			b = i; #1;
			if(y !== z) $display ("Falha ! Alto nivel = %d e baixaria = %d",y,z);

		  end
	end

endmodule
