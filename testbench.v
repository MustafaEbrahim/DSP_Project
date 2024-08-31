module tb_Spartan6_DSP48A1();
parameter A0REG =0 ;
parameter A1REG =1 ;
parameter B0REG =0 ;
parameter B1REG =1 ;
parameter CREG =1 ;
parameter DREG =1 ;
parameter MREG =1 ;
parameter PREG =1 ;
parameter CARRYINREG  =1 ;
parameter CARRYOUTREG =1 ;
parameter OPMODEREG   =1 ;
parameter CARRYINSEL  ="OPMODE5";
parameter B_INPUT = "DIRECT";
parameter RSTTYPE = "SYNC"  ;
integer i=0;
reg [17:0] A,B,D,BCIN;
reg [47:0] C,PCIN;
reg clk, CARRYIN,RSTA,RSTB,RSTM,RSTP,RSTC,RSTD,RSTCARRYIN,RSTOPMODE,CEA,CEB,CEM,CEP,CEC,CED,CECARRYIN,CEOPMODE;
reg [7:0] OPMODE;
wire[17:0] BCOUT_1,BCOUT_2;
wire [47:0] PCOUT_1,PCOUT_2,P_1,P_2;
wire [35:0] M_1,M_2;
wire CARRYOUT_1 , CARRYOUTF_1,CARRYOUT_2 , CARRYOUTF_2;
     Spartan6_DSP48A1_REF #(A0REG,A1REG,B0REG,B1REG,CREG,DREG,MREG,PREG,CARRYINREG,CARRYOUTREG,OPMODEREG,CARRYINSEL,B_INPUT,RSTTYPE) 
     DUT (A,B,D,BCIN,C,PCIN,clk, CARRYIN,RSTA,RSTB,RSTM,RSTP,RSTC,RSTD,RSTCARRYIN,RSTOPMODE,CEA,CEB,CEM,CEP,CEC,CED,CECARRYIN,CEOPMODE, OPMODE, BCOUT_1,PCOUT_1,P_1,M_1,
      CARRYOUT_1 , CARRYOUTF_1);
     Spartan6_DSP48A1_DUT #(A0REG,A1REG,B0REG,B1REG,CREG,DREG,MREG,PREG,CARRYINREG,CARRYOUTREG,OPMODEREG,CARRYINSEL,B_INPUT,RSTTYPE) 
     DUT2 (A, B, D, C, clk, CARRYIN,
OPMODE, BCIN, RSTA, RSTB, RSTM, RSTP, RSTC, RSTD, RSTCARRYIN, RSTOPMODE, 
CEA, CEB, CEM, CEP, CEC, CED, CECARRYIN, CEOPMODE, PCIN,
BCOUT_2, PCOUT_2, P_2, M_2, CARRYOUT_2, CARRYOUTF_2);

initial begin
//initial values
clk=1;CARRYIN=0;CEA=1;CEB=1;CEM=1;CEP=1;CEC=1;CED=1;CECARRYIN=1;CEOPMODE=1;
A=1;B=2;D=3;C=4;PCIN=5;BCIN=6;OPMODE=8'b0000_0000;{RSTA,RSTB,RSTM,RSTP,RSTC,RSTD,RSTCARRYIN,RSTOPMODE}=8'b1111_1111;
forever 
#5 clk=~clk;
end
initial begin
#20;
for (OPMODE=0;OPMODE<=8'b1111_1111;OPMODE=OPMODE+1) begin
repeat(5)
@(negedge clk) {RSTA,RSTB,RSTM,RSTP,RSTC,RSTD,RSTCARRYIN,RSTOPMODE}=8'b0000_0000;
A=$urandom_range(5,15);  B=$urandom_range(5,15);  C=$urandom_range(5,15);  D=$urandom_range(5,15);  BCIN=$urandom_range(0,5);
if (BCOUT_2==BCOUT_1 && P_2==P_1 && PCOUT_2==PCOUT_1 && M_2==M_1 &&CARRYOUT_2==CARRYOUT_1 && CARRYOUTF_2==CARRYOUTF_1)  
$display ("iteraion %d is correct",OPMODE);
else begin
$display ("Error in iteration %d",OPMODE);
$display ("BCOUT_1=%d, P_1=%d, PCOUT_1=%d,M_1=%d,CARRYOUT_1=%d,CARRYOUTF_1=%d",BCOUT_1,P_1,PCOUT_1,M_1,CARRYOUT_1,CARRYOUTF_1);
$display ("BCOUT_2=%d, P_2=%d, PCOUT_2=%d,M_2=%d,CARRYOUT_2=%d,CARRYOUTF_2=%d",BCOUT_2,P_2,PCOUT_2,M_2,CARRYOUT_2,CARRYOUTF_2);
$stop;
end
if(OPMODE==8'b1101_1111) 
  {RSTA,RSTB,RSTM,RSTP,RSTC,RSTD,RSTCARRYIN,RSTOPMODE}=8'b1111_1111;
if(OPMODE==8'b1111_1110) 
  {CEA,CEB,CEC,CECARRYIN,CECARRYIN,CED,CEM,CEOPMODE}=8'b0000_0000;
if (OPMODE==8'b1111_1111)
$stop;
end
$stop;
end
endmodule