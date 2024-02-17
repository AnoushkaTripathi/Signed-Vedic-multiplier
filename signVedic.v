`timescale 1ns / 1ps
module msb_complement(
  input signed [7:0] input1,
  input signed [7:0] input2,
  output reg signed [15:0] fresult
);

wire [7:0] output1, output2;
wire [15:0] multiplier_result;
wire xor_result;

// Check MSB of input1 and complement if necessary
  assign output1 = (input1[7] == 1) ? (~input1 + 1) : input1;

// Check MSB of input2 and complement if necessary
  assign output2 = (input2[7] == 1) ? (~input2 + 1) : input2;

vedic_8X8 multiplier_instance(
.a(output1[7:0]),
.b(output2[7:0]),
.c(multiplier_result[15:0])
);

always @* begin
  if (input1[7] ^ input2[7] == 1) begin
fresult = {1'b1, ~multiplier_result + 1};
end else begin
fresult = {1'b0, multiplier_result};
end
end

endmodule
module ha(a, b, sum, carry);
input a;
input b;
output sum;
output carry;
assign carry=a&b;
assign sum=a^b;
endmodule

module vedic_2x2(a,b,c);
input [1:0]a;
input [1:0]b;
output [3:0]c;
wire [3:0]c;
wire [3:0]temp;
//s1 for iir
assign c[0]=a[0]&b[0];
assign temp[0]=a[1]&b[0];
assign temp[1]=a[0]&b[1];
assign temp[2]=a[1]&b[1];
//s2 two half adders for iir
ha z1(temp[0],temp[1],c[1],temp[3]);
ha z2(temp[2],temp[3],c[2],c[3]);
endmodule

module half_adder(x,y,s,c);
input x,y;
output s,c;
assign s=x^y;
assign c=x&y;
endmodule


module full_adder(x,y,c_in,s,c_out);
input x,y,c_in;
output s,c_out;
assign s = (x^y) ^ c_in;
assign c_out = (y&c_in)| (x&y) | (x&c_in);
endmodule




module add_4_bit(input1,input2,answer);
parameter N=4;
input [N-1:0] input1,input2;
output [N-1:0] answer;
wire carry_out;
wire [N-1:0] carry;
genvar i;
generate
for(i=0;i<N;i=i+1)
begin: generate_N_bit_Adder
if(i==0)
half_adder f(input1[0],input2[0],answer[0],carry[0]);
else
full_adder f(input1[i],input2[i],carry[i-1],answer[i],carry[i]);
end
assign carry_out = carry[N-1];
endgenerate
endmodule

module add_6_bit(input1,input2,answer);
parameter N=6;
input [N-1:0] input1,input2;
output [N-1:0] answer;
wire carry_out;
wire [N-1:0] carry;
genvar i;
generate
for(i=0;i<N;i=i+1)
begin: generate_N_bit_Adder
if(i==0)
half_adder f(input1[0],input2[0],answer[0],carry[0]);
else
full_adder f(input1[i],input2[i],carry[i-1],answer[i],carry[i]);
end
assign carry_out = carry[N-1];
endgenerate
endmodule

module vedic_4x4(a,b,c);
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
wire [3:0]q4;
wire [5:0]q5;
wire [5:0]q6;
// 2,2 variables 4 bit multiplier
vedic_2x2 z1(a[1:0],b[1:0],q0[3:0]);
vedic_2x2 z2(a[3:2],b[1:0],q1[3:0]);
vedic_2x2 z3(a[1:0],b[3:2],q2[3:0]);
vedic_2x2 z4(a[3:2],b[3:2],q3[3:0]);
// full adder /stage 1 adders
assign temp1 ={2'b0,q0[3:2]};
add_4_bit z5(q1[3:0],temp1,q4);
assign temp2 ={2'b0,q2[3:0]};
assign temp3 ={q3[3:0],2'b0};
add_6_bit z6(temp2,temp3,q5);
assign temp4={2'b0,q4[3:0]};
// csa output
add_6_bit z7(temp4,q5,q6);
// mac unit output
assign c[1:0]=q0[1:0];
assign c[7:2]=q6[5:0];



endmodule

module add_8_bit(input1,input2,answer);
parameter N=8;
input [N-1:0] input1,input2;
output [N-1:0] answer;
wire carry_out;
wire [N-1:0] carry;
genvar i;
generate
for(i=0;i<N;i=i+1)
begin: generate_N_bit_Adder
if(i==0)
half_adder f(input1[0],input2[0],answer[0],carry[0]);
else
full_adder f(input1[i],input2[i],carry[i-1],answer[i],carry[i]);
end
assign carry_out = carry[N-1];
endgenerate
endmodule

module add_12_bit(input1,input2,answer);
parameter N=12;
input [N-1:0] input1,input2;
output [N-1:0] answer;
wire carry_out;
wire [N-1:0] carry;
genvar i;
generate
for(i=0;i<N;i=i+1)
begin: generate_N_bit_Adder
if(i==0)
half_adder f(input1[0],input2[0],answer[0],carry[0]);
else
full_adder f(input1[i],input2[i],carry[i-1],answer[i],carry[i]);
end
assign carry_out = carry[N-1];
endgenerate
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
wire [7:0]q4;
wire [11:0]q5;
wire [11:0]q6;
// 4,4 variables to 8bit multiplier
vedic_4x4 z1(a[3:0],b[3:0],q0[15:0]);
vedic_4x4 z2(a[7:4],b[3:0],q1[15:0]);
vedic_4x4 z3(a[3:0],b[7:4],q2[15:0]);
vedic_4x4 z4(a[7:4],b[7:4],q3[15:0]);

//full adders
assign temp1 ={4'b0,q0[7:4]};
add_8_bit z5(q1[7:0],temp1,q4);
assign temp2 ={4'b0,q2[7:0]};
assign temp3 ={q3[7:0],4'b0};
add_12_bit z6(temp2,temp3,q5);
assign temp4={4'b0,q4[7:0]};
// csa 12 bit adder
add_12_bit z7(temp4,q5,q6);
// csa output
assign c[3:0]=q0[3:0];
assign c[15:4]=q6[11:0];



endmodule
`timescale 1ns / 1ps
module test_vedic_8;

  reg signed [7:0] a;
  reg signed [7:0] b;

  wire signed [15:0] c;

integer i;

// Instantiate the Unit Under Test (UUT)
msb_complement uut (
.input1(a),
.input2(b),
.fresult(c)
);

initial begin


  for (i = 0; i < 10; i = i + 1) begin
a = $random;
b = $random;
 
#30;

$display("%t  a = %d and b = %d c = %d ", $time, a, b, c);
end
end

endmodule
