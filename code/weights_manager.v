//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: YangLing
// 
// Create Date: 2023/06/15
// Design Name: 
// Module Name: weights_manager
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

module weights_manager#(
    parameter VECTOR_MUL_LEN = 32,
    // 向量的长度，额外需要一个偏移量的参数(+1)
    parameter VECTOR_WIDTH = 32,
    // 向量的宽度，每个阶段需要输出多少个数
    parameter DATA_WIDTH = 8,
    // 每个数据的位宽
    parameter STAGE_NUM = 4,
    // 拥有参数的级数

    //for 100g MAC, the AXIS width is 512b
	parameter C_S_AXIS_DATA_WIDTH = 256,
	parameter C_S_AXIS_TUSER_WIDTH = 128,
	parameter PKT_HDR_LEN = (6+4+2)*8*8+256, // check with the doc
    parameter PARSE_ACT_RAM_WIDTH = 167,
    parameter WEIGHTS_MANAGER_ID = 7,
    parameter WEIGHTS_CONFIG = 0,
    parameter BIAS_CONFIG = 1,
    parameter CONTROL_FLAG = 16'hf2f1
    )(
    input									axis_clk,
	input									aresetn,

// 先传输weights，最后传输bias
// [...weights(VECTOR_MUL_LEN*VECTOR_WIDTH*DATA_WIDTH*STAGE_NUM)...]
// [...bias( 1 * VECTOR_WIDTH*DATA_WIDTH*STAGE_NUM)...]
// 每次传输 VECTOR_MUL_LEN*DATA_WIDTH 数据，需要传输(VECTOR_WIDTH*STAGE_NUM + [VECTOR_WIDTH*STAGE_NUM/VECTOR_MUL_LEN])次数据。
    output reg[(VECTOR_MUL_LEN)*VECTOR_WIDTH*DATA_WIDTH*STAGE_NUM-1:0] weights_vector,
    output reg[1 * VECTOR_WIDTH*DATA_WIDTH*STAGE_NUM-1:0] bias_vector,
    output reg         weights_vector_valid,
    output reg         bias_vector_valid,

    //control path
    input [C_S_AXIS_DATA_WIDTH-1:0]			c_s_axis_tdata,
	input [C_S_AXIS_TUSER_WIDTH-1:0]		c_s_axis_tuser,
	input [C_S_AXIS_DATA_WIDTH/8-1:0]		c_s_axis_tkeep,
	input									c_s_axis_tvalid,
	input									c_s_axis_tlast,

    output reg [C_S_AXIS_DATA_WIDTH-1:0]	c_m_axis_tdata,
	output reg [C_S_AXIS_TUSER_WIDTH-1:0]	c_m_axis_tuser,
	output reg [C_S_AXIS_DATA_WIDTH/8-1:0]	c_m_axis_tkeep,
	output reg								c_m_axis_tvalid,
	output reg								c_m_axis_tlast

    );

/****control path for 512b*****/
wire [7:0]          mod_id; //module ID
wire [15:0]         control_flag; //dst udp port num
reg  [7:0]          c_index; //table index(addr)
reg                 c_wr_en; //enable table write(wen)
// reg  [159:0]        entry_reg;

reg  [3:0]          state;

localparam IDLE_C = 1,
           WAIT_LAST_S  =2,
           HEAD0_S  =3,
           BIAS_S = 4,
           WEIGHTS0_S = 5,
           WEIGHTS1_S = 6,
           WEIGHTS2_S = 7,
           WEIGHTS3_S = 8,
           WAIT_S = 9
           ;

reg [C_S_AXIS_DATA_WIDTH-1:0]		c_s_axis_tdata_d0;
reg [C_S_AXIS_TUSER_WIDTH-1:0]		c_s_axis_tuser_d0;
reg [C_S_AXIS_DATA_WIDTH/8-1:0]		c_s_axis_tkeep_d0;
reg									c_s_axis_tvalid_d0;
reg									c_s_axis_tlast_d0;

reg [C_S_AXIS_DATA_WIDTH-1:0]		c_s_axis_tdata_d1;
reg [C_S_AXIS_TUSER_WIDTH-1:0]		c_s_axis_tuser_d1;
reg [C_S_AXIS_DATA_WIDTH/8-1:0]		c_s_axis_tkeep_d1;
reg									c_s_axis_tvalid_d1;
reg									c_s_axis_tlast_d1;

assign mod_id           = c_s_axis_tdata_d0[112+:8];       //256   Module ID
assign control_flag     = c_s_axis_tdata_d0[64+:16];       //256   UDP 目的端口号

always @(posedge axis_clk or negedge aresetn) begin
    if(~aresetn) begin
        c_s_axis_tdata_d0 <= 0;
        c_s_axis_tuser_d0 <= 0;
        c_s_axis_tkeep_d0 <= 0;
        c_s_axis_tvalid_d0 <= 0;
        c_s_axis_tlast_d0 <= 0;

        c_s_axis_tdata_d1 <= 0;
        c_s_axis_tuser_d1 <= 0;
        c_s_axis_tkeep_d1 <= 0;
        c_s_axis_tvalid_d1 <= 0;
        c_s_axis_tlast_d1 <= 0;
    end
    else begin
        c_s_axis_tdata_d0   <= c_s_axis_tdata;
        c_s_axis_tuser_d0   <= c_s_axis_tuser;
        c_s_axis_tkeep_d0   <= c_s_axis_tkeep;
        c_s_axis_tvalid_d0  <= c_s_axis_tvalid;
        c_s_axis_tlast_d0   <= c_s_axis_tlast;

        c_s_axis_tdata_d1   <= c_s_axis_tdata_d0;
        c_s_axis_tuser_d1   <= c_s_axis_tuser_d0;
        c_s_axis_tkeep_d1   <= c_s_axis_tkeep_d0;
        c_s_axis_tvalid_d1  <= c_s_axis_tvalid_d0;
        c_s_axis_tlast_d1   <= c_s_axis_tlast_d0;
    end
end

//LE to BE switching
// REWRITE CODE
wire[C_S_AXIS_DATA_WIDTH-1:0] c_s_axis_tdata_swapped;
genvar swapvar;
generate
    for(swapvar = 0; swapvar <(C_S_AXIS_DATA_WIDTH/8); swapvar = swapvar + 1)begin
        assign c_s_axis_tdata_swapped[swapvar*8 +: 8] = c_s_axis_tdata_d1[C_S_AXIS_DATA_WIDTH-1-swapvar*8 -:8];
    end
endgenerate


always @(posedge axis_clk or negedge aresetn) begin
    if(~aresetn) begin
        c_wr_en <= 1'b0;
        c_index <= 4'b0;

        c_m_axis_tdata <= 0;
        c_m_axis_tuser <= 0;
        c_m_axis_tkeep <= 0;
        c_m_axis_tvalid <= 0;
        c_m_axis_tlast <= 0;
        // entry_reg <= 0;

        state <= IDLE_C;

        weights_vector_valid <= 0;
        bias_vector_valid <= 0;
        bias_vector <= {(1)*VECTOR_WIDTH*DATA_WIDTH*STAGE_NUM{1'b0}};
        weights_vector <= {(VECTOR_MUL_LEN+1)*VECTOR_WIDTH*DATA_WIDTH*STAGE_NUM{1'b0}};
    end
    else begin
        case(state)
            IDLE_C: begin
                if((c_s_axis_tvalid_d1) && (mod_id[2:0] == WEIGHTS_MANAGER_ID) && (control_flag == CONTROL_FLAG))begin
                    // 如果是自己的控制报文，丢掉前两拍
                    c_index <= c_s_axis_tdata_d0[128 +: 8];        // 256 index
                    state <= HEAD0_S;
                end
                else begin
                    // 如果不是自己的控制报文
                    c_m_axis_tdata <= c_s_axis_tdata_d1;
                    c_m_axis_tuser <= c_s_axis_tuser_d1;
                    c_m_axis_tkeep <= c_s_axis_tkeep_d1;
                    c_m_axis_tvalid <= c_s_axis_tvalid_d1;
                    c_m_axis_tlast <= c_s_axis_tlast_d1;
                    state <= WAIT_LAST_S;
                end

                if(!c_s_axis_tvalid_d1)begin
                    state <= IDLE_C;
                end

            end
            WAIT_LAST_S:begin
                    // 如果不是自己的控制报文
                    c_m_axis_tdata <= c_s_axis_tdata_d1;
                    c_m_axis_tuser <= c_s_axis_tuser_d1;
                    c_m_axis_tkeep <= c_s_axis_tkeep_d1;
                    c_m_axis_tvalid <= c_s_axis_tvalid_d1;
                    c_m_axis_tlast <= c_s_axis_tlast_d1;
                    state <= WAIT_LAST_S;
                    if(c_s_axis_tlast_d1)begin
                        // 一个网络报文结束，返回判断
                        state <= IDLE_C;
                    end
            end
            HEAD0_S:begin
                // 处理报文头的第二拍
                state <= HEAD0_S;
                if(c_s_axis_tvalid_d1)begin
                    if(c_index == 0)begin
                        state <= WEIGHTS0_S;
                    end
                    if(c_index == 1)begin
                        state <= WEIGHTS1_S;
                    end
                    if(c_index == 2)begin
                        state <= WEIGHTS2_S;
                    end
                    if(c_index == 3)begin
                        state <= WEIGHTS3_S;
                    end
                    if(c_index == 4)begin
                        state <= BIAS_S;
                    end
                end
            end
            BIAS_S:begin
                state <= BIAS_S;
                bias_vector_valid <= 0;
                if(c_s_axis_tvalid_d1)begin
                    bias_vector[1 * VECTOR_WIDTH*DATA_WIDTH*STAGE_NUM-1:0]  <= 
                        (bias_vector[1 * VECTOR_WIDTH*DATA_WIDTH*STAGE_NUM-1:0] << (VECTOR_MUL_LEN*DATA_WIDTH))
                        + c_s_axis_tdata_swapped;
                end
                if(c_s_axis_tlast_d1)begin
                    bias_vector_valid <= 1;
                    state <= IDLE_C;
                end
            end
            WEIGHTS0_S:begin
                state <= WEIGHTS0_S;
                weights_vector_valid <= 0;
                if(c_s_axis_tvalid_d1)begin
                    weights_vector[(VECTOR_MUL_LEN)*VECTOR_WIDTH*DATA_WIDTH*(1)-1:(VECTOR_MUL_LEN)*VECTOR_WIDTH*DATA_WIDTH*(0)] <= 
                    (weights_vector[(VECTOR_MUL_LEN)*VECTOR_WIDTH*DATA_WIDTH*(1)-1:(VECTOR_MUL_LEN)*VECTOR_WIDTH*DATA_WIDTH*(0)] << (VECTOR_MUL_LEN*DATA_WIDTH))
                    + c_s_axis_tdata_swapped;
                end
                if(c_s_axis_tlast_d1)begin
                    state <= IDLE_C;
                    weights_vector_valid <= 1;
                end
            end
            WEIGHTS1_S:begin
                state <= WEIGHTS1_S;
                weights_vector_valid <= 0;
                if(c_s_axis_tvalid_d1)begin
                    weights_vector[(VECTOR_MUL_LEN)*VECTOR_WIDTH*DATA_WIDTH*(2)-1:(VECTOR_MUL_LEN)*VECTOR_WIDTH*DATA_WIDTH*(1)] <= 
                    (weights_vector[(VECTOR_MUL_LEN)*VECTOR_WIDTH*DATA_WIDTH*(2)-1:(VECTOR_MUL_LEN)*VECTOR_WIDTH*DATA_WIDTH*(1)] << (VECTOR_MUL_LEN*DATA_WIDTH))
                    + c_s_axis_tdata_swapped;
                end
                if(c_s_axis_tlast_d1)begin
                    state <= IDLE_C;
                    weights_vector_valid <= 1;
                end
            end
            WEIGHTS2_S:begin
                state <= WEIGHTS2_S;
                weights_vector_valid <= 0;
                if(c_s_axis_tvalid_d1)begin
                    weights_vector[(VECTOR_MUL_LEN)*VECTOR_WIDTH*DATA_WIDTH*(3)-1:(VECTOR_MUL_LEN)*VECTOR_WIDTH*DATA_WIDTH*(2)] <= 
                    (weights_vector[(VECTOR_MUL_LEN)*VECTOR_WIDTH*DATA_WIDTH*(3)-1:(VECTOR_MUL_LEN)*VECTOR_WIDTH*DATA_WIDTH*(2)] << (VECTOR_MUL_LEN*DATA_WIDTH))
                    + c_s_axis_tdata_swapped;
                end
                if(c_s_axis_tlast_d1)begin
                    state <= IDLE_C;
                    weights_vector_valid <= 1;
                end
            end
            WEIGHTS3_S:begin
                state <= WEIGHTS3_S;
                weights_vector_valid <= 0;
                if(c_s_axis_tvalid_d1)begin
                    weights_vector[(VECTOR_MUL_LEN)*VECTOR_WIDTH*DATA_WIDTH*(4)-1:(VECTOR_MUL_LEN)*VECTOR_WIDTH*DATA_WIDTH*(3)] <= 
                    (weights_vector[(VECTOR_MUL_LEN)*VECTOR_WIDTH*DATA_WIDTH*(4)-1:(VECTOR_MUL_LEN)*VECTOR_WIDTH*DATA_WIDTH*(3)] << (VECTOR_MUL_LEN*DATA_WIDTH))
                    + c_s_axis_tdata_swapped;
                end
                if(c_s_axis_tlast_d1)begin
                    state <= IDLE_C;
                    weights_vector_valid <= 1;
                end
            end
            WAIT_S:begin
                    c_m_axis_tdata <= c_s_axis_tdata_d1;
                    c_m_axis_tuser <= c_s_axis_tuser_d1;
                    c_m_axis_tkeep <= c_s_axis_tkeep_d1;
                    c_m_axis_tvalid <= c_s_axis_tvalid_d1;
                    c_m_axis_tlast <= c_s_axis_tlast_d1;
                // 等待其他传输包的完成
                if(c_s_axis_tlast_d1)begin
                    state <= IDLE_C;
                end
                else begin
                    state <= WAIT_S;
                end
            end

        endcase
    end
end

wire [VECTOR_MUL_LEN*DATA_WIDTH-1:0] reg1_debug;
wire [VECTOR_MUL_LEN*DATA_WIDTH-1:0] reg2_debug;
wire [VECTOR_MUL_LEN*DATA_WIDTH-1:0] reg3_debug;

assign reg1_debug = weights_vector[0+: VECTOR_MUL_LEN*DATA_WIDTH];
assign reg2_debug = weights_vector[VECTOR_MUL_LEN*DATA_WIDTH+: VECTOR_MUL_LEN*DATA_WIDTH];
assign reg3_debug = weights_vector[2*VECTOR_MUL_LEN*DATA_WIDTH+: VECTOR_MUL_LEN*DATA_WIDTH];

endmodule
