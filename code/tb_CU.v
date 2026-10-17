`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/18 21:41:23
// Design Name: 
// Module Name: tb_CU
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


module tb_CU#(
    parameter VECTOR_MUL_LEN = 32,
    // 向量的长度，额外需要一个偏移量的参数
    parameter VECTOR_WIDTH = 32,
    // 向量的宽度，每个阶段需要输出多少个数
    parameter DATA_WIDTH = 8,
    // 每个数据的位宽
    parameter STAGE_NUM = 4,
    // 拥有参数的级数

    //for 100g MAC, the AXIS width is 512b
	parameter C_S_AXIS_DATA_WIDTH = 256,
	parameter C_S_AXIS_TUSER_WIDTH = 128,
	parameter PKT_HDR_LEN = (6+4+2)*8*8+20*5+256, // check with the doc
	//parameter PARSE_ACT_RAM_WIDTH = 167,
    parameter PARSER_ID = 0
)();


reg									axis_clk = 0;
reg									aresetn = 0;


initial begin
    axis_clk = 0;
    aresetn = 1;
    #(10);
    aresetn = 0;
    #(10);
    aresetn = 1;
end


wire [(VECTOR_MUL_LEN)*VECTOR_WIDTH*DATA_WIDTH*STAGE_NUM-1:0] weights_vector;
wire [(1)*VECTOR_WIDTH*DATA_WIDTH*STAGE_NUM-1:0] bias_vector;
wire weights_vector_valid;
wire bias_vector_valid;

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


reg  [8*8*4-1:0]           phv_ML_in_1    = 0;
reg  [8*8*4-1:0]           phv_ML_in_2    = 0;
reg                        phv_ML_in_valid_1= 0;
reg                        phv_ML_in_valid_2= 0;
wire [8*8*4-1:0]           phv_ML_out_1;
wire [8*8*4-1:0]           phv_ML_out_2;
wire                       phv_ML_out_valid_1;
wire                       phv_ML_out_valid_2;

reg [8 - 1:0] weight_1 = 8'd1;
reg [8 - 1:0] weight_2 = 8'd2;
reg [8 - 1:0] weight_3 = 8'd3;
reg [8 - 1:0] weight_4 = 8'd4;

reg [8 - 1:0] feature_1 = 8'd5;
reg [8 - 1:0] feature_2 = 8'd6;
reg [8 - 1:0] feature_3 = 8'd7;
reg [8 - 1:0] feature_4 = 8'd8;

reg [8 - 1:0] bias_1 = 8'd1;
reg [8 - 1:0] bias_2 = 8'd9;


//Weights manager
// wire [(VECTOR_MUL_LEN+1)*VECTOR_WIDTH*DATA_WIDTH-1:0]  cu_weight;
// wire                                               weights_vector_valid;

localparam CYCLE = 10;

always begin
    #(CYCLE/2) axis_clk = ~axis_clk;
end

initial begin
    axis_clk = 0;
    aresetn = 1;
    #(10);
    aresetn = 0;
    #(10);
    aresetn = 1;
end
//NOTE: 256b testcase
integer i;
initial begin
    #(2*CYCLE);
    #(CYCLE/2);
    for (i = 0; i<20; i=i+1) begin
        //config parameters
        // c_s_axis_tdata <= {120'd0,8'd0, 4'b0000, 4'b0000, 5'b00000, 3'b000, 112'b0};
        c_s_axis_tdata <= {112'd0,144'd0};
        c_s_axis_tvalid <= 1'b1;
        c_s_axis_tkeep <= 64'hffffffffffffffff;
        c_s_axis_tuser <= 128'b0;
        c_s_axis_tlast <= 1'b0;
        #(CYCLE)
        c_s_axis_tdata <= {120'b0, 8'd0, 4'b0000, 4'b0000, 8'd0, 32'd0, 16'hf2f1, 16'd0,  48'd0};
        c_s_axis_tvalid <= 1'b1;
        c_s_axis_tkeep <= 64'hffffffffffffffff;
        c_s_axis_tuser <= 128'b0;
        c_s_axis_tlast <= 1'b0;
        #(CYCLE)
        c_s_axis_tdata <= {240'd0,{weight_2, weight_1}};
        c_s_axis_tvalid <= 1'b1;
        c_s_axis_tkeep <= 64'hffffffffffffffff;
        c_s_axis_tuser <= 128'b0;
        c_s_axis_tlast <= 1'b0;
        #(CYCLE)
        c_s_axis_tdata <= {240'd0,{weight_4, weight_3}};
        c_s_axis_tvalid <= 1'b1;
        c_s_axis_tkeep <= 64'hffffffffffffffff;
        c_s_axis_tuser <= 128'b0;
        c_s_axis_tlast <= 1'b1;

        #(CYCLE)
        c_s_axis_tdata <= 256'd0;
        // c_s_axis_tdata <= {238'heeeeeeeeeeeeeeeeeeeeeee,18'hffff};
        c_s_axis_tvalid <= 1'b0;
        c_s_axis_tkeep <= 64'hffffffffffffffff;
        c_s_axis_tuser <= 128'b0;
        c_s_axis_tlast <= 1'b0;


// config bias
        c_s_axis_tdata <= {144'd0,112'd0};
        c_s_axis_tvalid <= 1'b1;
        c_s_axis_tkeep <= 64'hffffffffffffffff;
        c_s_axis_tuser <= 128'b0;
        c_s_axis_tlast <= 1'b0;
        #(CYCLE)
        c_s_axis_tdata <= {120'b0, 8'd4, 4'b0000, 4'b0000, 8'd0, 32'd0, 16'hf2f1, 16'd0,  48'd0};
        // c_s_axis_tdata <= {48'd0,16'd0,16'hf2f1, 32'd0, 8'd0, 4'b0000, 4'b0000, 8'd4, 120'b0};
        c_s_axis_tvalid <= 1'b1;
        c_s_axis_tkeep <= 64'hffffffffffffffff;
        c_s_axis_tuser <= 128'b0;
        c_s_axis_tlast <= 1'b0;

        #(CYCLE)
        c_s_axis_tdata <= {{bias_2, bias_1}, 240'd0};
        c_s_axis_tvalid <= 1'b1;
        c_s_axis_tkeep <= 64'hffffffffffffffff;
        c_s_axis_tuser <= 128'b0;
        c_s_axis_tlast <= 1'b1;

        #(CYCLE)
        c_s_axis_tdata <= {256'd0};
        c_s_axis_tvalid <= 1'b0;
        c_s_axis_tkeep <= 64'd0;
        c_s_axis_tuser <= 128'b0;
        c_s_axis_tlast <= 1'b0;

        #(CYCLE)
        phv_ML_in_1   <= {{feature_2, feature_1}, 240'd0};
        phv_ML_in_2   <= {{feature_4, feature_3}, 240'd0};
        phv_ML_in_valid_1   <= 1'b1;
        phv_ML_in_valid_2   <= 1'b1;
        #(CYCLE)
        phv_ML_in_valid_1   <= 1'b0;
        phv_ML_in_valid_2   <= 1'b0;
        #(CYCLE)
        #(10*CYCLE);
        $stop;
    end
end


// 这个管理了所有stage的参数信息，一个CU只需要其中的一部分参数信息。
weights_manager #(
    .C_S_AXIS_DATA_WIDTH(C_S_AXIS_DATA_WIDTH), //for 100g mac exclusively
	.C_S_AXIS_TUSER_WIDTH(C_S_AXIS_TUSER_WIDTH),
	.PKT_HDR_LEN(),
	.PARSE_ACT_RAM_WIDTH(),
	.WEIGHTS_MANAGER_ID()
)
weights_manager_i
(
	.axis_clk		(axis_clk),
	.aresetn		(aresetn),

	//data path
	.weights_vector_valid	(weights_vector_valid),
    .weights_vector     (weights_vector),

    .bias_vector_valid  (bias_vector_valid),
    .bias_vector        (bias_vector),

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

CU CU_1(
    .clk    (axis_clk),
    .aresetn    (aresetn),

    .phv_ML_in  (phv_ML_in_1),
    .phv_ML_in_valid    (phv_ML_in_valid_1),

    .phv_ML_out     (phv_ML_out_1),
    .phv_ML_out_valid   (phv_ML_out_valid_1),

    .cu_weight  (weights_vector[(VECTOR_MUL_LEN)*VECTOR_WIDTH*DATA_WIDTH-1:0]),
    .weights_vector_valid   (weights_vector_valid),

    .bias_vector (bias_vector[(1)*VECTOR_WIDTH*DATA_WIDTH-1:(0)*VECTOR_WIDTH*DATA_WIDTH]),
    .bias_vector_valid  (bias_vector_valid)
);

CU CU_2(
    .clk    (axis_clk),
    .aresetn    (aresetn),

    .phv_ML_in  (phv_ML_in_2),
    .phv_ML_in_valid    (phv_ML_in_valid_2),

    .phv_ML_out     (phv_ML_out_2),
    .phv_ML_out_valid   (phv_ML_out_valid_2),

    .cu_weight  (weights_vector[(VECTOR_MUL_LEN)*VECTOR_WIDTH*DATA_WIDTH*2-1:(VECTOR_MUL_LEN)*VECTOR_WIDTH*DATA_WIDTH]),
    .weights_vector_valid   (weights_vector_valid),


    .bias_vector (bias_vector[(2)*VECTOR_WIDTH*DATA_WIDTH-1:(1)*VECTOR_WIDTH*DATA_WIDTH]),
    .bias_vector_valid  (bias_vector_valid)
);


endmodule
