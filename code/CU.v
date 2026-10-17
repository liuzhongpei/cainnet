
`timescale 1ns / 1ps

module CU #(
    parameter C_S_AXIS_DATA_WIDTH = 512,
    parameter C_S_AXIS_TUSER_WIDTH = 128,

    parameter PHV_LEN = 64*16+32*12+16*4+5*20+256,

    parameter VECTOR_MUL_LEN=32,
    parameter VECTOR_WIDTH = 32,// 向量的宽度，每个阶段需要输出多少个数
    parameter DATA_WIDTH = 8,// 每个数据的位宽
    parameter STAGE_NUM = 4// 拥有参数的级数
)
(
    input                        clk,
    input                        aresetn,

    input  [8*8*4-1:0]           phv_ML_in,
    input                        phv_ML_in_valid,
    output [8*8*4-1:0]           phv_ML_out,
    output                       phv_ML_out_valid,


    //Weights manager
    input [(VECTOR_MUL_LEN)*VECTOR_WIDTH*DATA_WIDTH-1:0]  cu_weight,
    input                                               weights_vector_valid,

    input [1 * VECTOR_WIDTH*DATA_WIDTH-1:0] bias_vector,
    input          bias_vector_valid

);

genvar MA_index;
genvar adder_index;

wire [VECTOR_WIDTH*DATA_WIDTH-1:0] mul2adder;
wire [VECTOR_WIDTH*DATA_WIDTH-1:0] adder2relu;
wire [VECTOR_WIDTH*DATA_WIDTH-1:0] relu_out;
wire [VECTOR_WIDTH-1:0] mul2adder_valid;
wire [VECTOR_WIDTH-1:0] adder2relu_valid;
wire [VECTOR_WIDTH-1:0] relu_out_valid;

generate
    for (MA_index = 1;MA_index<=32 ;MA_index=MA_index+1 ) begin:MA_num
    vector_mul vector_mul_i (
    .clk                     ( clk                                                            ),
    .rst_n                   ( aresetn                                                        ),
    .data_vector_valid       ( phv_ML_in_valid                                                ),
    .data_vector             ( phv_ML_in[8*8*4-1 : 0]                                         ),
    .weight_vector_valid     ( weights_vector_valid                                           ),
    .weight_vector           ( cu_weight[MA_index*(VECTOR_MUL_LEN)*DATA_WIDTH-1 -:VECTOR_MUL_LEN*DATA_WIDTH]),

    .result_valid            ( mul2adder_valid[MA_index-1]                                    ),
    .result                  ( mul2adder[DATA_WIDTH*MA_index-1 -:DATA_WIDTH]                  )
    );
    Adder Adder_i (
    .clk                     ( clk                                                            ),
    .rst_n                   ( aresetn                                                        ),
    .data1_vector_valid      ( bias_vector_valid                                           ),
    .data1_vector            ( bias_vector[(MA_index)*(DATA_WIDTH)-1 -:DATA_WIDTH]            ),
    .data2_vector_valid      ( mul2adder_valid[MA_index-1]                                    ),
    .data2_vector            ( mul2adder[DATA_WIDTH*MA_index-1 -:DATA_WIDTH]                  ),

    .result_valid            ( adder2relu_valid[MA_index-1]                                   ),
    .result                  ( adder2relu[DATA_WIDTH*MA_index-1 -:DATA_WIDTH]                 )
    );
    Relu Relu_i (
    .clk                     ( clk                                                            ),
    .rst_n                   ( aresetn                                                        ),
    .data1_vector_valid      ( adder2relu_valid[MA_index-1]                                   ),
    .data1_vector            ( adder2relu[DATA_WIDTH*MA_index-1 -:DATA_WIDTH]                 ),
    
    .result_valid            ( relu_out_valid[MA_index-1]                                     ),
    .result                  ( relu_out[DATA_WIDTH*MA_index-1 -:DATA_WIDTH]                   )
    );
    end
   
endgenerate
assign phv_ML_out=relu_out;
assign phv_ML_out_valid=relu_out_valid;
endmodule
