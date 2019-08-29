module altonivel (input [7:0]a, input [7:0]b, output M, output I);
assign M= a>b;
assign I= a==b;
endmodule 

module maiorIgual2b (input [1:0]a, input [1:0]b, output M, output I);
assign M= (a[1] & ~b[1]) | (a[1] & a[0] & ~b[0]) | (a[0] & ~b[0] & ~b[1]);
assign I= (~b[0] & ~b[1] & ~a[0] & ~a[1]) | (b[0] & ~b[1] & a[0] & ~a[1]) | (b[0] & b[1] & a[0] & a[1]) | (~b[0] & b[1] & ~a[0] & a[1]);
endmodule 

module maiorIgualArvore (input Me, input Md, input Ie, input Id, output M, output I);
assign M= Me|(Ie & Md);
assign I= Id & Ie;
endmodule 

module arvore(input [7:0]a, input [7:0]b, output M, output I);
wire m76, i76, m54, i54, m32, i32, m10, i10;
maiorIgual2b M76(a[7:6], b[7:6], m76, i76);
maiorIgual2b M54(a[5:4], b[5:4], m54, i54);
maiorIgual2b M32(a[3:2], b[3:2], m32, i32);
maiorIgual2b M10(a[1:0], b[1:0], m10, i10);

wire me, ie, md, id, Mt, It;
maiorIgualArvore M1(m76, m54, i76, i54, me, ie);
maiorIgualArvore M2(m32, m10, i32, i10, md, id);
maiorIgualArvore Resp(me, md, ie, id, Mt, It);

assign M = Mt;
assign I = It;

endmodule

//template do testbench esqdir
module stimulus;
    reg [7:0] a,b;
    wire m1,m2,i1,i2;
    altonivel M1(a,b,m1,i1);
    arvore M2(a,b,m2,i2);
    integer i;     
    initial begin
                
    $monitor(" a=%d,b=%d A>B %b%b A==B %b%b",a,b,m1,m2,i1,i2);
      for(i=0;i<65536;i=i+1)
	begin 
          a= i[15:8]; b = i[7:0]; #1;
	  if( m1 !== m2 || i1 !== i2 ) $display("Falha ! a=%d b=%d maior %b %b igual %b %b",a,b,m1,m2,i1,i2);
       	end  // for 
        a = 0; b=0; #2;
    end  // initial
     
    endmodule
