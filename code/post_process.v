
`timescale 1ns / 1ps

module stage #(
    parameter C_S_AXIS_DATA_WIDTH = 256,
    parameter C_S_AXIS_TUSER_WIDTH = 128,
    parameter STAGE_ID = 0,  //valid: 0-4
    parameter PHV_LEN = 64*16+32*12+16*4+5*20+256,
    parameter KEY_LEN = 64*2+32*2+16*2+5,
    parameter ACT_LEN = 32,
    parameter KEY_OFF = 4*2+4*2+2*2,
    parameter VECTOR_MUL_LEN = 32+1, // 向量的长度，额外需要一个偏移量的参数
    parameter VECTOR_WIDTH = 32,// 向量的宽度，每个阶段需要输出多少个数
    parameter DATA_WIDTH = 8// 每个数据的位宽
    
)
(
    input                        axis_clk,
    input                        aresetn,

    input  [PHV_LEN-1:0]         phv_in,
    input                        phv_in_valid,
    output [PHV_LEN-1:0]         phv_out,
    output                       phv_out_valid,


    //control path
    input [C_S_AXIS_DATA_WIDTH-1:0]			c_s_axis_tdata,
	input [C_S_AXIS_TUSER_WIDTH-1:0]		c_s_axis_tuser,
	input [C_S_AXIS_DATA_WIDTH/8-1:0]		c_s_axis_tkeep,
	input									c_s_axis_tvalid,
	input									c_s_axis_tlast,

    output [C_S_AXIS_DATA_WIDTH-1:0]		c_m_axis_tdata,
	output [C_S_AXIS_TUSER_WIDTH-1:0]		c_m_axis_tuser,
	output [C_S_AXIS_DATA_WIDTH/8-1:0]		c_m_axis_tkeep,
	output									c_m_axis_tvalid,
	output									c_m_axis_tlast



);

localparam IDLE   = 4'd0,
           WAIT_C  = 4'd1,
           WAIT_D  = 4'd2;

reg [1:0] state,state_next;

always @(posedge clk or negedge aresetn) begin
    if(~aresetn) begin
        phv_out<=0;
        phv_out_valid<=0;
        c_m_axis_tdata<=0;
        c_m_axis_tuser<=0;
        c_m_axis_tkeep<=0;
        c_m_axis_tvalid<=0;
        c_m_axis_tlast<=0;
    end
    else begin
        
    end

end


endmodule
