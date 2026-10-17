`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/15 15:05:37
// Design Name: 
// Module Name: tb_weights_manager
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_weights_manager#(
    parameter VECTOR_MUL_LEN = 32+1,
    // 向量的长度，额外需要一个偏移量的参数
    parameter VECTOR_WIDTH = 32,
    // 向量的宽度，每个阶段需要输出多少个数
    parameter DATA_WIDTH = 8,
    // 每个数据的位宽
    parameter STAGE_NUM = 4,
    // 拥有参数的级数

    //for 100g MAC, the AXIS width is 512b
	parameter C_S_AXIS_DATA_WIDTH = 512,
	parameter C_S_AXIS_TUSER_WIDTH = 128,
	parameter PKT_HDR_LEN = (6+4+2)*8*8+20*5+256, // check with the doc
	parameter PARSE_ACT_RAM_WIDTH = 167,
    parameter PARSER_ID = 0
)();

reg									axis_clk = 0;
reg									aresetn = 0;

wire [VECTOR_MUL_LEN*VECTOR_WIDTH*DATA_WIDTH*STAGE_NUM-1:0] weights_vector;
wire weights_vector_valid;

//control path
reg  [C_S_AXIS_DATA_WIDTH-1:0]		c_s_axis_tdata  = 0;
reg  [C_S_AXIS_TUSER_WIDTH-1:0]		c_s_axis_tuser  = 0;
reg  [C_S_AXIS_DATA_WIDTH/8-1:0]	c_s_axis_tkeep  = 0;
reg									c_s_axis_tvalid  = 0;
reg									c_s_axis_tlast  = 0;

wire [C_S_AXIS_DATA_WIDTH-1:0]		c_m_axis_tdata;
wire [C_S_AXIS_TUSER_WIDTH-1:0]		c_m_axis_tuser;
wire [C_S_AXIS_DATA_WIDTH/8-1:0]	c_m_axis_tkeep;
wire								c_m_axis_tvalid;
wire								c_m_axis_tlast;


localparam CYCLE = 10;

always begin
    #(CYCLE/2) axis_clk = ~axis_clk;
end

initial begin
    axis_clk = 0;
    aresetn=0;
    /*aresetn = 1;
    #(10);
    aresetn = 0;
    #(10);
    aresetn = 1;*/
end
//NOTE: 512b testcase
integer i;
initial begin
    #(2*CYCLE);
    #(CYCLE/2);
    for (i = 0; i<20; i=i+1) begin
        //for action table
        aresetn<=1;
        #(CYCLE)
        c_s_axis_tdata <= {128'b0, 4'b0001, 4'b10, 5'b00000, 3'b110, /*368'b0*/32'b0,16'hf2f1,320'b0};
        c_s_axis_tvalid <= 1'b1;
        c_s_axis_tkeep <= 64'hffffffffffffffff;
        c_s_axis_tuser <= 128'b0;
        c_s_axis_tlast <= 1'b0;
        #(CYCLE)
        c_s_axis_tdata <= {494'hfffffffffffffffffffffff,18'hffff};
        c_s_axis_tvalid <= 1'b1;
        c_s_axis_tkeep <= 64'hffffffffffffffff;
        c_s_axis_tuser <= 128'b0;
        c_s_axis_tlast <= 1'b0;
        #(CYCLE)
        c_s_axis_tdata <= {494'heeeeeeeeeeeeeeeeeeeeeee,18'hffff};
        c_s_axis_tvalid <= 1'b1;
        c_s_axis_tkeep <= 64'hffffffffffffffff;
        c_s_axis_tuser <= 128'b0;
        c_s_axis_tlast <= 1'b0;

        #(CYCLE)
        c_s_axis_tdata <= {494'heeeeeeeeeeeeeeeeeeeeeee,18'hffff};
        c_s_axis_tvalid <= 1'b1;
        c_s_axis_tkeep <= 64'hffffffffffffffff;
        c_s_axis_tuser <= 128'b0;
        c_s_axis_tlast <= 1'b1;

        #(CYCLE)
        c_s_axis_tdata <= 512'b0;
        c_s_axis_tvalid <= 1'b0;
        c_s_axis_tkeep <= 64'h0;
        c_s_axis_tuser <= 128'b0;
        c_s_axis_tlast <= 1'b0;
        aresetn<=0;
        #(8*CYCLE);
        $stop;
        // //for action table
        // c_s_axis_tdata <= {128'b0, 4'b0001, 4'b10, 5'b00000, 3'b000, 368'b0};
        // c_s_axis_tvalid <= 1'b1;
        // c_s_axis_tkeep <= 64'hffffffffffffffff;
        // c_s_axis_tuser <= 128'b0;
        // c_s_axis_tlast <= 1'b0;
        // #(CYCLE)
        // c_s_axis_tdata <= {494'hfffffffffffffffffffffff,18'hffff};
        // c_s_axis_tvalid <= 1'b1;
        // c_s_axis_tkeep <= 64'hffffffffffffffff;
        // c_s_axis_tuser <= 128'b0;
        // c_s_axis_tlast <= 1'b0;
        // #(CYCLE)
        // c_s_axis_tdata <= {494'heeeeeeeeeeeeeeeeeeeeeee,18'hffff};
        // c_s_axis_tvalid <= 1'b1;
        // c_s_axis_tkeep <= 64'hffffffffffffffff;
        // c_s_axis_tuser <= 128'b0;
        // c_s_axis_tlast <= 1'b0;

        // #(CYCLE)
        // c_s_axis_tdata <= {494'heeeeeeeeeeeeeeeeeeeeeee,18'hffff};
        // c_s_axis_tvalid <= 1'b1;
        // c_s_axis_tkeep <= 64'hffffffffffffffff;
        // c_s_axis_tuser <= 128'b0;
        // c_s_axis_tlast <= 1'b1;

        // #(CYCLE)
        // c_s_axis_tdata <= 512'b0;
        // c_s_axis_tvalid <= 1'b0;
        // c_s_axis_tkeep <= 64'h0;
        // c_s_axis_tuser <= 128'b0;
        // c_s_axis_tlast <= 1'b0;
        // #(8*CYCLE);
    end
end


weights_manager #(
    .C_S_AXIS_DATA_WIDTH(C_S_AXIS_DATA_WIDTH), //for 100g mac exclusively
	.C_S_AXIS_TUSER_WIDTH(C_S_AXIS_TUSER_WIDTH),
	.PKT_HDR_LEN(),
	.PARSE_ACT_RAM_WIDTH(),
	.PARSER_ID()
)
weights_manager_i
(
	.axis_clk		(axis_clk),
	.aresetn		(aresetn),
	//data path
	.weights_vector_valid	(weights_vector_valid),
    .weights_vector     (weights_vector),

	//control path
    .c_s_axis_tdata(c_s_axis_tdata),
	.c_s_axis_tuser(c_s_axis_tuser),
	.c_s_axis_tkeep(c_s_axis_tkeep),
	.c_s_axis_tvalid(c_s_axis_tvalid),
	.c_s_axis_tlast(c_s_axis_tlast),

    .c_m_axis_tdata(c_m_axis_tdata),
	.c_m_axis_tuser(c_m_axis_tuser),
	.c_m_axis_tkeep(c_m_axis_tkeep),
	.c_m_axis_tvalid(c_m_axis_tvalid),
	.c_m_axis_tlast(c_m_axis_tlast)

);


endmodule
