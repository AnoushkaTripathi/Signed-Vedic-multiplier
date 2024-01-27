`timescale 1ns / 1ps
module msb_complement(input1,input2,fresult);
 input  [8:0] input1;
input [8:0] input2;

  wire [8:0] output1,output2;
  wire xor_result;
  wire signed [15:0] result;
  output [16:0] fresult;
// Check MSB of input1 and complement if necessary
  assign output1 = (input1[8] == 1) ? ~input1 + 1 : input1;

// Check MSB of input2 and complement if necessary
  assign output2 = (input2[8] == 1) ? ~input2 + 1 : input2;
  vedic_8X8 multiplier_instance(
    .a(output1[7:0]),
    .b(output2[7:0]),
    .c(result[15:0])
);

  assign xor_result = input1[8] ^ input2[8];
   
  always@(result)
  begin
    if (xor_result == 1) begin
        result = ~result + 1;
    end
end
  assign fresult = {xor_result, result};
endmodule
module ha(a,b,sum,carry);
input a,b;
output sum,carry;
xor(sum,a,b);
and(carry,a,b);
endmodule


module add_4_bit (a,b,sum);
input [3:0] a,b;
output [4:0]sum;
assign sum=a+b;
endmodule


module add_6_bit (a,b,sum);
input [5:0] a,b;
output [6:0] sum;
assign sum = a+b;
endmodule

module add_8_bit (a,b,sum);
input[7:0] a,b;
output[8:0] sum;
assign sum = a+b;
endmodule

module add_12_bit (a,b,sum);
input[11:0] a,b;
output[12:0] sum;
assign sum = a+b;
endmodule



module vedic_2_x_2(a,b,c);
input [1:0]a;
input [1:0]b;
output [3:0]c;
wire [3:0]c;
wire [3:0]temp;
assign c[0]=a[0]&b[0];
assign temp[0]=a[1]&b[0];
assign temp[1]=a[0]&b[1];
assign temp[2]=a[1]&b[1];
ha z1(temp[0],temp[1],c[1],temp[3]);
ha z2(temp[2],temp[3],c[2],c[3]);
endmodule

module vedic_4_x_4(a,b,c);
input [3:0]a;
input [3:0]b;
output [7:0]c;
wire [3:0]q0;    
wire [3:0]q1;    
wire [3:0]q2;
wire [3:0]q3;    
wire [7:0]c;
wire [3:0]temp1;
wire [5:0]temp2;
wire [5:0]temp3;
wire [5:0]temp4;
wire [4:0]q4;
wire [6:0]q5;
wire [6:0]q6;

vedic_2_x_2 z1(a[1:0],b[1:0],q0[3:0]);
vedic_2_x_2 z2(a[3:2],b[1:0],q1[3:0]);
vedic_2_x_2 z3(a[1:0],b[3:2],q2[3:0]);
vedic_2_x_2 z4(a[3:2],b[3:2],q3[3:0]);

assign temp1 ={2'b0,q0[3:2]};
add_4_bit z5(q1[3:0],temp1,q4);
assign temp2 ={2'b0,q2[3:0]};
assign temp3 ={q3[3:0],2'b0};
add_6_bit z6(temp2,temp3,q5);

assign temp4={2'b0,q4[3:0]};
add_6_bit z7(temp4,q5,q6);
assign c[1:0]=q0[1:0];
assign c[7:2]=q6[5:0];
endmodule

module vedic_8X8(a,b,c);
   
input [7:0]a;
input [7:0]b;
output [15:0]c;

wire [15:0]q0;    
wire [15:0]q1;    
wire [15:0]q2;
wire [15:0]q3;    
wire [15:0]c;
wire [7:0]temp1;
wire [11:0]temp2;
wire [11:0]temp3;
wire [11:0]temp4;
wire [8:0]q4;
wire [12:0]q5;
wire [12:0]q6;

vedic_4_x_4 z1(a[3:0],b[3:0],q0[15:0]);
vedic_4_x_4 z2(a[7:4],b[3:0],q1[15:0]);
vedic_4_x_4 z3(a[3:0],b[7:4],q2[15:0]);
vedic_4_x_4 z4(a[7:4],b[7:4],q3[15:0]);

assign temp1 ={4'b0,q0[7:4]};
add_8_bit z5(q1[7:0],temp1,q4);
assign temp2 ={4'b0,q2[7:0]};
assign temp3 ={q3[7:0],4'b0};
add_12_bit z6(temp2,temp3,q5);
assign temp4={4'b0,q4[7:0]};

add_12_bit z7(temp4,q5,q6);

assign c[3:0]=q0[3:0];
assign c[15:4]=q6[11:0];
endmodule





module test_vedic_8;

  reg signed [8:0] a;
  reg signed[8:0] b;

  wire signed[17:0] c;
  reg signed[17:0] prod;
    integer i;

    // Instantiate the Unit Under Test (UUT)
  msb_complement uut (.input1(a),.input2(b), .fresult(c));

    initial
     begin
    
    	for (i=0;i<65536;i=i+1)
    	begin
    	a=$random;
    	b=$random;
    	prod= a * b;
    	#30;
     	if(prod!==c)
     	$display("%t match not found for a =%d and b=%d prod=%d and c=%d ", $time, a,b,prod,c);
     	end
   	 

    end
 	 
endmodule




