module Spartan6_DSP48A1_REF
 (
     input [17:0] A,B,D,BCIN,
     input [47:0] C,PCIN,
     input clk, CARRYIN,RSTA,RSTB,RSTM,RSTP,RSTC,RSTD,RSTCARRYIN,RSTOPMODE,CEA,CEB,CEM,CEP,CEC,CED,CECARRYIN,CEOPMODE,
     input [7:0] OPMODE,
     output[17:0] BCOUT,
     output[47:0] PCOUT,P,
     output[35:0] M,
     output CARRYOUT , CARRYOUTF
);
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

reg [17:0] A0_reg,B0_reg,A1_reg,B1_reg,D_reg;
wire[17:0] pre_addORsub_out,mux_A0,mux_A1,mux_B0,mux_B1,mux_D,B0_input,B1_input;
reg [47:0] C_reg,P_reg;
wire[47:0]post_addORsub_out ,mux_C,output_MUX_Z , output_MUX_X;
wire[48:0] mux_P; 
wire[35:0] mux_M,M_buff,mux_carryin,mux_carryout;
reg [7:0 ] OPMODE_reg;
wire[7:0 ] mux_OPMODE;
reg CARRYIN_reg,CYO_reg;
wire ADDER_CYO,CIN;
reg [35:0] M_reg; 
wire[35:0] MULTP_out ;
generate
     if (RSTTYPE=="SYNC")
     always @ (posedge clk)begin
     // for input A
     if (RSTA) {A0_reg,A1_reg} <=0;
     else if (CEA) {A0_reg,A1_reg} <= {A,mux_A0};
     // for input B
     if (RSTB) {B0_reg,B1_reg} <=0;
     else if (CEB) {B0_reg,B1_reg} <= {B0_input,B1_input};
     // for input C
     if (RSTC) C_reg <=0;
     else if (CEC) C_reg <= C;
     // for input D
     if (RSTD) D_reg <=0;
     else if (CED) D_reg <= D;
     // for input opmode
     if (RSTOPMODE) OPMODE_reg <=0;
     else if (CEOPMODE) OPMODE_reg <= OPMODE;
     // for input carryin and carry out
     if (RSTCARRYIN) {CARRYIN_reg,CYO_reg} <=0;
     else if (CECARRYIN) {CARRYIN_reg,CYO_reg} <= {mux_carryin, ADDER_CYO};
     // for M REG
     if (RSTM) M_reg <=0;
     else if (CEM) M_reg <= MULTP_out;
     // for P REG
     if (RSTP) P_reg <=0;
     else if (CEP) P_reg <= post_addORsub_out;
     end
else if (RSTTYPE=="ASYNC") begin
always @(posedge clk or posedge RSTA)
     // for input A
     if (RSTA) {A0_reg,A1_reg} <=0;
     else if (CEA) {A0_reg,A1_reg} <= {A,mux_A0};
always @(posedge clk or posedge RSTB)
     // for input B
     if (RSTB) {B0_reg,B1_reg} <=0;
     else if (CEB) {B0_reg,B1_reg} <= {B0_input,B1_input};
always @(posedge clk or posedge RSTC)
     // for input C
     if (RSTC) C_reg <=0;
     else if (CEC) C_reg <= C;
always @(posedge clk or posedge RSTD)
     // for input D
     if (RSTD) D_reg <=0;
     else if (CED) D_reg <= D;
always @(posedge clk or posedge RSTOPMODE)
     // for input opmode
     if (RSTOPMODE) OPMODE_reg <=0;
     else if (CEOPMODE) OPMODE_reg <= OPMODE;
always @(posedge clk or posedge RSTCARRYIN)
     // for input carryin and carry out
     if (RSTCARRYIN) {CARRYIN_reg,CYO_reg} <=0;
     else if (CECARRYIN) {CARRYIN_reg,CYO_reg} <= {mux_carryin, ADDER_CYO};
always @(posedge clk or posedge RSTM)
     // for M REG
     if (RSTM) M_reg <=0;
     else if (CEM) M_reg <= MULTP_out;
always @(posedge clk or posedge RSTP)
     if (RSTP) P_reg <=0;
     else if (CEP) P_reg <= post_addORsub_out;     
     end
endgenerate
//pre-adder / subtractor
 assign pre_addORsub_out = (mux_OPMODE[6])? (mux_D - mux_B0) :  (mux_D + mux_B0);
//post-adder/subtractor
 assign {ADDER_CYO,post_addORsub_out}= (mux_OPMODE[7])? (output_MUX_Z - (output_MUX_X + CIN )) :  (output_MUX_X + output_MUX_Z + CIN) ;
//multipler
 assign MULTP_out = mux_A1 * mux_B1;
//MUX
 assign mux_D = (DREG)? D_reg : D ;
 assign B0_input = (B_INPUT=="DIRECT")? B : BCIN ;
 assign mux_B0= (B0REG)? B0_reg : B0_input;
 assign mux_B1= (B1REG)? B1_reg:B1_input;
 assign mux_A0= (A0REG)? A0_reg : A ;
 assign mux_A1= (A1REG)? A1_reg:mux_A0;
 assign mux_C = (CREG)? C_reg : C ;
 assign mux_OPMODE = (OPMODEREG)? OPMODE_reg : OPMODE ;
 assign B1_input = (mux_OPMODE[4])? pre_addORsub_out : mux_B0 ;
 assign mux_D = (DREG)? D_reg : D ;
 assign mux_carryin =(CARRYINSEL=="OPMODE5")? mux_OPMODE[5]:CARRYIN;
 assign CIN =(CARRYINREG)? CARRYIN_reg : mux_carryin; 
 assign mux_carryout =(CARRYOUTREG)? CYO_reg:ADDER_CYO;
 assign mux_M = (MREG)? M_reg : MULTP_out;
 assign output_MUX_X = (mux_OPMODE[1:0]==2'b00)? 0 :  (mux_OPMODE[1:0]==2'b01)? mux_M : (mux_OPMODE[1:0]==2'b10)? P : {mux_D,mux_A1,mux_B1};
 assign output_MUX_Z = (mux_OPMODE[3:2]==2'b00)? 0 :  (mux_OPMODE[3:2]==2'b01)? PCIN : (mux_OPMODE[3:2]==2'b10)? P  : mux_C;
 assign mux_P = (PREG)? P_reg:post_addORsub_out;
 assign M_buff = mux_M;
//outputs
 assign P =  mux_P; 
 assign PCOUT =P ;
 assign BCOUT = mux_B1 ;
 assign M = M_buff;
 assign CARRYOUT =mux_carryout;
 assign CARRYOUTF =CARRYOUT;
endmodule


