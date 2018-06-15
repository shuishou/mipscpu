`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:13:04 01/05/2014 
// Design Name: 
// Module Name:    mipscpu 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module mipscpu(CLK,LEDS,SWS,BTNS
    );


///////////////////////memory-reg bus define///////////////
wire [15:0] MRADDR_IO_BUS,MDATA_OUT_IO_BUS,MRADDR_CPU_BUS,MDATA_OUT_CPU_BUS,
				MWADDR_IO_BUS,MDATA_IN_IO_BUS,MWADDR_CPU_BUS,MDATA_IN_CPU_BUS,
				RDATA_OUT1_BUS,RDATA_OUT2_BUS,RDATA_IN_BUS;
wire MW_CPU_ON_BUS,MW_IO_ON_BUS,RW_ON_BUS;
wire [3:0] RRADDR1_BUS,RRADDR2_BUS,RWADDR_BUS;
//////////////PC////////////////////////

 wire [15:0] PC_BUS;
 wire [15:0] OFFSET_BUS;
 wire REALPCWRITEBACK_BUS,STAGE1WRITEBACK_BUS;
 wire [15:0] STAGE1IN_BUS,STAGE2IN_BUS,STAGE3IN_BUS,STAGE4IN_BUS,STAGE1OUT_BUS,STAGE2OUT_BUS,STAGE3OUT_BUS,STAGE4OUT_BUS;
 wire WILLWRITE_BUS,ENDWRITE_BUS,READREG_BUS;
 wire [3:0]READREG1_BUS,READREG2_BUS ,ENDREG_BUS,STARTREG_BUS;
 wire [15:0] STAGE4ADDR_BUS,STAGE4DATA_BUS;

//////////////////test/////////////////////////

input CLK;


output [7:0]LEDS;
input [7:0]SWS;
input [3:0] BTNS;


////////////////////////////////////

reg CLK25MHz;
reg [15:0]count_2;

wire [7:0] REG_BUS;


assign LEDS [7:0] = (SWS[3:1]==4'b000)?REG_BUS:(
								(SWS[3:1]==4'b001)?MDATA_OUT_CPU_BUS:(
								(SWS[3:1]==4'b010)?PC_BUS:(
								(SWS[3:1]==4'b011)?MRADDR_CPU_BUS:8'b0000_1111)
								));



initial
begin
	CLK25MHz = 0;
	count_2 = 16'b0000_0000_0000_0000;
end

always @ (posedge SWS[0]) begin
    CLK25MHz = ~CLK25MHz;
		end

//////////////////////////////////////////
Memorynew M(
.CLK(CLK25MHz),
.RADDR_IO(MRADDR_IO_BUS),
.DATA_OUT_IO(MDATA_OUT_IO_BUS),
.RADDR_CPU(MRADDR_CPU_BUS),
.DATA_OUT_CPU(MDATA_OUT_CPU_BUS),
.WADDR_IO(MWADDR_IO_BUS),
.DATA_IN_IO(MDATA_IN_IO_BUS),
.WADDR_CPU(MWADDR_CPU_BUS),
.DATA_IN_CPU(MDATA_IN_CPU_BUS),

.MW_CPU_ON(MW_CPU_ON_BUS),
.MW_IO_ON(MW_IO_ON_BUS),

.STAGE4ADDR(STAGE4ADDR_BUS),
.STAGE4OUT(STAGE4DATA_BUS)
);    

Reg R(
.CLK(CLK25MHz),
.RADDR1(RRADDR1_BUS),
.DATA_OUT1(RDATA_OUT1_BUS),
.RADDR2(RRADDR2_BUS),
.DATA_OUT2(RDATA_OUT2_BUS),
.W_ON(RW_ON_BUS),
.WADDR(RWADDR_BUS),
.DATA_IN(RDATA_IN_BUS),
.TESTADDR(SWS[7:4]),
.TESTDATAOUT( REG_BUS)
); 

pc PC(
.PCOUT(PC_BUS),
.STAGE1WRITEBACK(STAGE1WRITEBACK_BUS),
.REALPCWRITEBACK(REALPCWRITEBACK_BUS),
.OFFSET(OFFSET_BUS),
.CLK(CLK25MHz),
.WILLWRITE(WILLWRITE_BUS),
.STARTREG(STARTREG_BUS),
.READREG1(READREG1_BUS),
.READREG2(READREG2_BUS),
.ENDWRITE(ENDWRITE_BUS),
.ENDREG(ENDREG_BUS),
.STAGE1IN(STAGE1IN_BUS),
.STAGE2IN(STAGE2IN_BUS),
.STAGE3IN(STAGE3IN_BUS),
.STAGE4IN(STAGE4IN_BUS),

.STAGE1OUT(STAGE1OUT_BUS),
.STAGE2OUT(STAGE2OUT_BUS),
.STAGE3OUT(STAGE3OUT_BUS),
.STAGE4OUT(STAGE4OUT_BUS),

.READREG(READREG_BUS)
    );
 
 
 wire [15:0]IR_12_BUS;
wire [15:0]PC_12_BUS;

 
fetch STAGE1(
.RADDR_CPU(MRADDR_CPU_BUS),
.DATA_IN(MDATA_OUT_CPU_BUS),
.STAGE1IN(STAGE1IN_BUS),
.STAGE1OUT(STAGE1OUT_BUS),
.IROUT(IR_12_BUS),
.PCOUT(PC_12_BUS),
.PCIN(PC_BUS),
.STAGE1WRITEBACK(STAGE1WRITEBACK_BUS),
.CLK(CLK25MHz)
 );  


wire [15:0] IR_23_BUS,
				 PC_23_BUS,
				 DATA1_23_BUS,
				 DATA2_23_BUS,
				 DATA3_23_BUS;
 
convert STAGE2(
	.IRIN(IR_12_BUS),
	.PCIN(PC_12_BUS),
	.DATAIN1(RDATA_OUT1_BUS),
	.DATAIN2(RDATA_OUT2_BUS), 
	.STAGE2IN(STAGE2IN_BUS),
	.STAGE2OUT(STAGE2OUT_BUS),
	.IROUT(IR_23_BUS),
	.PCOUT(PC_23_BUS),
	.DATAOUT1(DATA1_23_BUS),
	.DATAOUT2(DATA2_23_BUS),
	.DATAOUT3(DATA3_23_BUS),
	.RADDR1(RRADDR1_BUS),
	.RADDR2(RRADDR2_BUS),
	.CLK(CLK25MHz),
	.WILLWRITE(WILLWRITE_BUS),
	.STARTREG(STARTREG_BUS),
	.READREG1(READREG1_BUS),
	.READREG2(READREG2_BUS),
	.READREG(READREG_BUS)
    );

wire [15:0] IR_34_BUS,
				 PC_34_BUS,
				 DATA_34_BUS,
				 ADDR_34_BUS;
	 
alu STAGE3(
		.IRIN(IR_23_BUS),
		.PCIN(PC_23_BUS),
		.DATAIN1(DATA1_23_BUS),
		.DATAIN2(DATA2_23_BUS),
		.DATAIN3(DATA3_23_BUS),
		.STAGE3IN(STAGE3IN_BUS),
		.STAGE3OUT(STAGE3OUT_BUS),
		.CLK(CLK25MHz), 
		.PCOUT(PC_34_BUS),
		.IROUT(IR_34_BUS),
		.DATAOUT(DATA_34_BUS),
		.ADDROUT(ADDR_34_BUS));

wire [15:0] IR_45_BUS,
				 PC_45_BUS,
				 DATA_45_BUS,
				 ADDR_45_BUS;

writememory STAGE4(
			.CLK(CLK25MHz),
		   .IRIN(IR_34_BUS),
			.DATAIN(DATA_34_BUS),
			.ADDRIN(ADDR_34_BUS),
			.STAGE4IN(STAGE4IN_BUS),
			.STAGE4OUT(STAGE4OUT_BUS),
			.WADDR_CPU(MWADDR_CPU_BUS),
			.DATA_OUT_CPU(MDATA_IN_CPU_BUS),
			.ADDROUT(ADDR_45_BUS),
			.DATAOUT(DATA_45_BUS),
			.IROUT(IR_45_BUS),
			.MW_CPU_ON(MW_CPU_ON_BUS),
			.REALPCWRITEBACK(REALPCWRITEBACK_BUS) ,
			.OFFSET(OFFSET_BUS),
			.PCIN(PC_34_BUS),
			.RADDR_CPU(STAGE4ADDR_BUS),
			.DATA_IN_CPU(STAGE4DATA_BUS)

    );
	 
writereg STAGE5(
			.CLK(CLK25MHz),
			.IRIN(IR_45_BUS),
			.DATAIN(DATA_45_BUS),
			.ADDRIN(ADDR_45_BUS),
			.DATA_OUT(RDATA_IN_BUS),
			.W_ON(RW_ON_BUS),
			.WADDR(RWADDR_BUS),
			.ENDWRITE(ENDWRITE_BUS),
			.ENDREG(ENDREG_BUS)
    );

			
			
  endmodule