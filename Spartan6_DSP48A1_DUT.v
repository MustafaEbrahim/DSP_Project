module Spartan6_DSP48A1_DUT(A, B, D, C, CLK, CARRYIN, 
OPMODE, BCIN, RSTA, RSTB, RSTM, RSTP, RSTC, RSTD, RSTCARRYIN, RSTOPMODE, 
CEA, CEB, CEM, CEP, CEC, CED, CECARRYIN, CEOPMODE, PCIN,
BCOUT, PCOUT, P, M, CARRYOUT, CARRYOUTF);

parameter A0REG = 0;
parameter A1REG = 1;
parameter B0REG = 0;
parameter B1REG = 1;
parameter CREG = 1;
parameter DREG = 1;
parameter MREG = 1;
parameter PREG = 1;
parameter CARRYINREG = 1;
parameter CARRYOUTREG = 1;
parameter OPMODEREG = 1;
parameter CARRYINSEL = "OPMODE5";
parameter B_INPUT = "DIRECT";
parameter RSTTYPE = "SYNC";

input [17:0] A, B, D;
input [47:0] C;

input CLK, CARRYIN;

input [7:0] OPMODE;
input [17:0] BCIN;

input RSTA, RSTB, RSTM, RSTP, RSTC, RSTD, RSTCARRYIN, RSTOPMODE;

input CEA, CEB, CEM, CEP, CEC, CED, CECARRYIN, CEOPMODE;

input [47:0] PCIN;


output [17:0] BCOUT;
output [47:0] PCOUT, P;
output [35:0] M;
output CARRYOUT, CARRYOUTF;


reg [17:0] A0_REG, A1_REG, B0_REG, B1_REG, D_REG;
wire [17:0] mux_A0_out, mux_A1_out, mux_B0_out, mux_B1_out, mux_D_out, Pre_Adder_out, mux_Pre_Adder_out;
reg [17:0] B_input_out;
reg [47:0] C_REG;
wire [47:0] mux_C_out, D_A_B_Concatenation;
reg [7:0] OPMODE_REG;
wire [7:0] mux_OPMODE_out;
reg [35:0] M_REG;
wire [35:0] multiplier_out, mux_multiplier_out;
reg [47:0] mux_X_out, mux_Z_out;
wire Post_Adder_CIN;
reg mux_CARRYINSEL_out, CYI_REG, CYO_REG;
wire [47:0] Post_Adder_out;
reg [47:0] P_REG;
wire Post_Adder_CO;


////////////////////////////////////////////
//////////////Sequential_Logic//////////////
////////////////////////////////////////////

generate
	if (RSTTYPE == "SYNC") begin

		always @(posedge CLK) begin
			if (RSTA) begin
				A0_REG <= 0;
				A1_REG <=0;
			end
			else if (CEA) begin
				A0_REG <= A;
				A1_REG <= mux_A0_out;
			end
		end

		always @(posedge CLK) begin
			if (RSTB) begin
				B0_REG <= 0;
				B1_REG <=0;
			end
			else if (CEB) begin
				B0_REG <= B_input_out;
				B1_REG <= mux_Pre_Adder_out;
			end
		end

		always @(posedge CLK) begin
			if (RSTC) begin
				C_REG <= 0;
			end
			else if (CEC) begin
				C_REG <= C;
			end
		end

		always @(posedge CLK) begin
			if (RSTD) begin
				D_REG <= 0;
			end
			else if (CEC) begin
				D_REG <= D;
			end
		end

		always @(posedge CLK) begin
			if (RSTOPMODE) begin
				OPMODE_REG <= 0;
			end
			else if (CEOPMODE) begin
				OPMODE_REG <= OPMODE;
			end
		end

		always @(posedge CLK) begin
			if (RSTC) begin
				C_REG <= 0;
			end
			else if (CEC) begin
				C_REG <= C;
			end
		end

		always @(posedge CLK) begin
			if (RSTM) begin
				M_REG <= 0;
			end
			else if (CEM) begin
				M_REG <= multiplier_out;
			end
		end

		always @(posedge CLK) begin
			if (RSTCARRYIN) begin
				CYI_REG <= 0;
				CYO_REG <= 0;
			end
			else if (CECARRYIN) begin
				CYI_REG <= mux_CARRYINSEL_out;
				CYO_REG <= Post_Adder_CO;
			end
		end
		always @(posedge CLK) begin
			if (RSTP) begin
				P_REG <= 0;
			end
			else if (CEP) begin
				P_REG <= Post_Adder_out;
			end
		end
	end
	else if (RSTTYPE == "ASYNC") begin

		always @(posedge CLK or posedge RSTA) begin
			if (RSTA) begin
				A0_REG <= 0;
				A1_REG <=0;
			end
			else if (CEA) begin
				A0_REG <= A;
				A1_REG <= mux_A0_out;
			end
		end

		always @(posedge CLK or posedge RSTB) begin
			if (RSTB) begin
				B0_REG <= 0;
				B1_REG <=0;
			end
			else if (CEB) begin
				B0_REG <= B_input_out;
				B1_REG <= mux_Pre_Adder_out;
			end
		end

		always @(posedge CLK or posedge RSTC) begin
			if (RSTC) begin
				C_REG <= 0;
			end
			else if (CEC) begin
				C_REG <= C;
			end
		end

		always @(posedge CLK or posedge RSTD) begin
			if (RSTD) begin
				D_REG <= 0;
			end
			else if (CEC) begin
				D_REG <= D;
			end
		end

		always @(posedge CLK or posedge RSTOPMODE) begin
			if (RSTOPMODE) begin
				OPMODE_REG <= 0;
			end
			else if (CEOPMODE) begin
				OPMODE_REG <= OPMODE;
			end
		end

		always @(posedge CLK or posedge RSTC) begin
			if (RSTC) begin
				C_REG <= 0;
			end
			else if (CEC) begin
				C_REG <= C;
			end
		end

		always @(posedge CLK or posedge RSTM) begin
			if (RSTM) begin
				M_REG <= 0;
			end
			else if (CEM) begin
				M_REG <= multiplier_out;
			end
		end

		always @(posedge CLK or posedge RSTCARRYIN) begin
			if (RSTCARRYIN) begin
				CYI_REG <= 0;
				CYO_REG <= 0;
			end
			else if (CECARRYIN) begin
				CYI_REG <= mux_CARRYINSEL_out;
				CYO_REG <= Post_Adder_CO;
			end
		end
		always @(posedge CLK or posedge RSTP) begin
			if (RSTP) begin
				P_REG <= 0;
			end
			else if (CEP) begin
				P_REG <= Post_Adder_out;
			end
		end
	end
endgenerate


///////////////////////////////////////////////
//////////////Combinational_Logic//////////////
///////////////////////////////////////////////

//Gray_colored_multiplexers of A input
assign mux_A0_out = (A0REG)? A0_REG : A;
assign mux_A1_out = (A1REG)? A1_REG : mux_A0_out;

//Gray_colored_multiplexer of C input
assign mux_C_out = (CREG)? C_REG : C;

//Gray_colored_multiplexer of D input
assign mux_D_out = (DREG)? D_REG : D;

//Gray_colored_multiplexers of B input
always @(*) begin
	if (B_INPUT == "DIRECT") begin
		B_input_out = B;
	end
	else if (B_INPUT == "CASCADE") begin
		B_input_out = BCIN;
	end
	else begin
		B_input_out = 0;
	end
end
assign mux_B0_out = (B0REG)? B0_REG : B_input_out;
assign mux_B1_out = (B1REG)? B1_REG : mux_Pre_Adder_out;

//Pre-Adder/Subtracter
assign Pre_Adder_out = (mux_OPMODE_out[6])? (mux_D_out - mux_B0_out) : (mux_D_out + mux_B0_out);

//mux of Pre-Adder/Subtracter and B
assign mux_Pre_Adder_out = (mux_OPMODE_out[4])? Pre_Adder_out : mux_B0_out;

//Gray_colored_multiplexer of OPMODE input
assign mux_OPMODE_out = (OPMODEREG)? OPMODE_REG : OPMODE;

//output BCOUT
assign BCOUT = mux_B1_out;

//Concatenated D:A:B input signals
assign D_A_B_Concatenation = {mux_D_out,mux_A1_out,mux_B1_out};

//Multiplier
assign multiplier_out = mux_B1_out * mux_A1_out;
assign mux_multiplier_out = (MREG)? M_REG : multiplier_out;

//output M (buffered)
assign M = ~(~mux_multiplier_out);

//mux_X
always @(*) begin
	case(mux_OPMODE_out[1:0])
	    0: mux_X_out = 0;
	    1: mux_X_out = mux_multiplier_out;
	    2: mux_X_out = P;  //accumulator
	    3: mux_X_out = D_A_B_Concatenation;
	endcase
end

//mux_Z
always @(*) begin
	case(mux_OPMODE_out[3:2])
	    0: mux_Z_out = 0;
	    1: mux_Z_out = PCIN;
	    2: mux_Z_out = P;  //accumulator
	    3: mux_Z_out = mux_C_out;
	endcase
end

//Gray_colored_multiplexer of CYI Cascade
always @(*) begin
	if (CARRYINSEL == "OPMODE5") begin
		mux_CARRYINSEL_out = mux_OPMODE_out[5];
	end
	else if (CARRYINSEL == "CARRYIN") begin
		mux_CARRYINSEL_out = CARRYIN;
	end
	else begin
		mux_CARRYINSEL_out = 0;
	end
end

//Gray_colored_multiplexer of CYI
assign Post_Adder_CIN = (CARRYINREG)? CYI_REG : mux_CARRYINSEL_out;

//Post-Adder/Subtracter
assign {Post_Adder_CO , Post_Adder_out} = (mux_OPMODE_out[7])? (mux_Z_out - (mux_X_out + Post_Adder_CIN)) : (mux_Z_out + mux_X_out + Post_Adder_CIN);

//Gray_colored_multiplexer of P
//output P
assign P = (PREG)? P_REG : Post_Adder_out;

//output PCOUT
assign PCOUT = P;

//Gray_colored_multiplexer of CYO Cascade
//output CARRYOUT
assign CARRYOUT = (CARRYOUTREG)? CYO_REG : Post_Adder_CO;

//output CARRYOUTF
assign CARRYOUTF = CARRYOUT;

endmodule