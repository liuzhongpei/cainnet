//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: YangLing
// 
// Create Date: 2023/06/15
// Design Name: 
// Module Name: vector_mul
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// // 这个模块不需要接收控制报文的参数。
// // 接收的参数只有权重参数和PHV数据
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module vector_mul #(
    parameter VECTOR_MUL_LEN = 32,
    // 向量的宽度
    parameter DATA_WIDTH = 8
    // 每个数据的位宽
) 
(
    input                                     clk,
    input                                     rst_n,
      
    input                                     data_vector_valid,
    input [VECTOR_MUL_LEN*DATA_WIDTH-1 : 0]   data_vector,

    input                                     weight_vector_valid,
    input [VECTOR_MUL_LEN*DATA_WIDTH-1 : 0]   weight_vector,

    output                                    result_valid,
    output [DATA_WIDTH - 1 : 0]               result

);

reg  [VECTOR_MUL_LEN*DATA_WIDTH-1 : 0]      data_vector_reg0;
reg  [VECTOR_MUL_LEN-1 : 0]                 data_vector_valid_reg0;

reg  [VECTOR_MUL_LEN-1 : 0]                 data_vector_valid_reg1;
wire [VECTOR_MUL_LEN*2*DATA_WIDTH - 1 : 0]  temp_mul;
wire [VECTOR_MUL_LEN*DATA_WIDTH - 1 : 0]    temp_mul_reg1;

reg  [VECTOR_MUL_LEN-1 : 0]                 data_vector_valid_reg2;
    
    
reg  [VECTOR_MUL_LEN-1 : 0]                 data_vector_valid_reg3;
reg  [VECTOR_MUL_LEN-1 : 0]                 data_vector_valid_reg4;
    

genvar vector_index;
genvar adderTree_index;
genvar stage_index;
generate
for(vector_index=1; vector_index <= VECTOR_MUL_LEN; vector_index =vector_index +1)begin: stage0and1
    // 缓冲一拍
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)begin
            data_vector_valid_reg0[vector_index-1] <= 0;
            data_vector_reg0[vector_index*DATA_WIDTH-1 -: DATA_WIDTH] <= 0;
        end
        else begin
            data_vector_valid_reg0[vector_index-1] <= data_vector_valid;
            data_vector_reg0[vector_index*DATA_WIDTH-1 -: DATA_WIDTH] <= data_vector[vector_index*DATA_WIDTH-1 -: DATA_WIDTH];
        end
    end

Mul_8_gen Mul_8_gen_i (
  .CLK(clk),  // input wire CLK
  .A(data_vector_reg0    [vector_index*DATA_WIDTH-1 -: DATA_WIDTH]),      // input wire [7 : 0] A
  .B(weight_vector       [vector_index*DATA_WIDTH-1 -: DATA_WIDTH]),      // input wire [7 : 0] B
  .P(temp_mul_reg1[vector_index*DATA_WIDTH-1 -: DATA_WIDTH])      // output wire [7 : 0] P
);

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        data_vector_valid_reg1[vector_index-1] <= 0;
    end
    else begin
        data_vector_valid_reg1[vector_index-1] <= data_vector_valid_reg0;
    end
end

// // 以下是无符号乘法
// assign temp_mul[vector_index*2*DATA_WIDTH -1 -: 2*DATA_WIDTH] = 
//         {{DATA_WIDTH{1'b0}}, data_vector_reg0    [vector_index*DATA_WIDTH-1 -: DATA_WIDTH]} * 
//         {{DATA_WIDTH{1'b0}}, weight_vector       [vector_index*DATA_WIDTH-1 -: DATA_WIDTH]};

// // 第一阶段进行乘法操作
//     always @(posedge clk or negedge rst_n) begin
//         if(!rst_n)begin
//             data_vector_valid_reg1[vector_index-1] <= 0;
//             temp_mul_reg1[vector_index*DATA_WIDTH-1 -: DATA_WIDTH] <= 0;
//         end
//         else begin
//             data_vector_valid_reg1[vector_index-1] <= data_vector_valid_reg0;
//             temp_mul_reg1[vector_index*DATA_WIDTH-1 -: DATA_WIDTH] <= 
//             (|temp_mul[vector_index*2*DATA_WIDTH -1 -: DATA_WIDTH])?
//             {DATA_WIDTH{1'b1}}:temp_mul[vector_index*2*DATA_WIDTH - DATA_WIDTH -1 -: DATA_WIDTH];
//         end
//     end

end
endgenerate



// 第2-：阶段进行加法树的Reduce操作，每周期完成一级流水加法
// $clog2(VECTOR_MUL_LEN)  // 代表了后续流水线的级数
generate
case ($clog2(VECTOR_MUL_LEN))
    5: begin

// Stage 2
wire [(VECTOR_MUL_LEN/2)*DATA_WIDTH - 1 : 0] temp_adder_results_2;
wire [(VECTOR_MUL_LEN/2) - 1 : 0] temp_adder_results_2_valid;

for (adderTree_index = 0; adderTree_index < (VECTOR_MUL_LEN/2); adderTree_index = adderTree_index +1)begin: stage2
    Adder Adder_i(.clk(clk), .rst_n(rst_n), 
    .data1_vector_valid(data_vector_valid_reg1),
    .data2_vector_valid(data_vector_valid_reg1),
    .result_valid(temp_adder_results_2_valid[adderTree_index]),
    .data1_vector(temp_mul_reg1[2*adderTree_index*DATA_WIDTH +: DATA_WIDTH]), 
    .data2_vector(temp_mul_reg1[2*adderTree_index*DATA_WIDTH + DATA_WIDTH +: DATA_WIDTH]), 
    .result(temp_adder_results_2[adderTree_index*DATA_WIDTH +: DATA_WIDTH])
    );
end

// Stage 3
wire [(VECTOR_MUL_LEN/4)*DATA_WIDTH - 1 : 0] temp_adder_results_3;
wire [(VECTOR_MUL_LEN/4) - 1 : 0] temp_adder_results_3_valid;

for (adderTree_index = 0; adderTree_index < (VECTOR_MUL_LEN/4); adderTree_index = adderTree_index +1)begin: stage3
    Adder Adder_i(.clk(clk), .rst_n(rst_n), 
    .data1_vector_valid(temp_adder_results_2_valid[0]),
    .data2_vector_valid(temp_adder_results_2_valid[0]),
    .result_valid(temp_adder_results_3_valid[adderTree_index]),
    .data1_vector(temp_adder_results_2[2*adderTree_index*DATA_WIDTH +: DATA_WIDTH]), 
    .data2_vector(temp_adder_results_2[2*adderTree_index*DATA_WIDTH + DATA_WIDTH +: DATA_WIDTH]), 
    .result(temp_adder_results_3[adderTree_index*DATA_WIDTH +: DATA_WIDTH])
    );
end

// Stage 4
wire [(VECTOR_MUL_LEN/8)*DATA_WIDTH - 1 : 0] temp_adder_results_4;
wire [(VECTOR_MUL_LEN/8) - 1 : 0] temp_adder_results_4_valid;

for (adderTree_index = 0; adderTree_index < (VECTOR_MUL_LEN/8); adderTree_index = adderTree_index +1)begin: stage4
    Adder Adder_i(.clk(clk), .rst_n(rst_n), 
    .data1_vector_valid(temp_adder_results_3_valid[0]),
    .data2_vector_valid(temp_adder_results_3_valid[0]),
    .result_valid(temp_adder_results_4_valid[adderTree_index]),
    .data1_vector(temp_adder_results_3[2*adderTree_index*DATA_WIDTH +: DATA_WIDTH]), 
    .data2_vector(temp_adder_results_3[2*adderTree_index*DATA_WIDTH + DATA_WIDTH +: DATA_WIDTH]), 
    .result(temp_adder_results_4[adderTree_index*DATA_WIDTH +: DATA_WIDTH])
    );
end

// Stage 5
wire [(VECTOR_MUL_LEN/16)*DATA_WIDTH - 1 : 0] temp_adder_results_5;
wire [(VECTOR_MUL_LEN/16) - 1 : 0] temp_adder_results_5_valid;

for (adderTree_index = 0; adderTree_index < (VECTOR_MUL_LEN/16); adderTree_index = adderTree_index +1)begin: stage5
    Adder Adder_i(.clk(clk), .rst_n(rst_n), 
    .data1_vector_valid(temp_adder_results_4_valid[0]),
    .data2_vector_valid(temp_adder_results_4_valid[0]),
    .result_valid(temp_adder_results_5_valid[adderTree_index]),
    .data1_vector(temp_adder_results_4[2*adderTree_index*DATA_WIDTH +: DATA_WIDTH]), 
    .data2_vector(temp_adder_results_4[2*adderTree_index*DATA_WIDTH + DATA_WIDTH +: DATA_WIDTH]), 
    .result(temp_adder_results_5[adderTree_index*DATA_WIDTH +: DATA_WIDTH])
    );
end

// Stage 6
wire [(VECTOR_MUL_LEN/32)*DATA_WIDTH - 1 : 0] temp_adder_results_6;
wire [(VECTOR_MUL_LEN/32) - 1 : 0] temp_adder_results_6_valid;

for (adderTree_index = 0; adderTree_index < (VECTOR_MUL_LEN/32); adderTree_index = adderTree_index +1)begin: stage6
    Adder Adder_i(.clk(clk), .rst_n(rst_n), 
    .data1_vector_valid(temp_adder_results_5_valid[0]),
    .data2_vector_valid(temp_adder_results_5_valid[0]),
    .result_valid(temp_adder_results_6_valid[adderTree_index]),
    .data1_vector(temp_adder_results_5[2*adderTree_index*DATA_WIDTH +: DATA_WIDTH]), 
    .data2_vector(temp_adder_results_5[2*adderTree_index*DATA_WIDTH + DATA_WIDTH +: DATA_WIDTH]), 
    .result(temp_adder_results_6[adderTree_index*DATA_WIDTH +: DATA_WIDTH])
    );
end

assign result       = temp_adder_results_6;
assign result_valid = temp_adder_results_6_valid;


end
    default: begin
        
    end
endcase
    
    
endgenerate



endmodule

module Adder #(
    parameter DATA_WIDTH = 8
) (
    input                       clk,
    input                       rst_n,
    input  [DATA_WIDTH-1 : 0]   data1_vector,
    input                       data1_vector_valid,
    input  [DATA_WIDTH-1 : 0]   data2_vector,
    input                       data2_vector_valid,
    output [DATA_WIDTH-1 : 0]   result,
    output reg                  result_valid
);

// wire [DATA_WIDTH : 0] result_temp;
// assign result_temp = {1'b0, data1_vector} + {1'b0, data2_vector};

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        // result <= {DATA_WIDTH{1'b0}};
        result_valid <= 1'b0;
    end
    else begin
        // result <= result_temp[DATA_WIDTH - 1]?{DATA_WIDTH{1'b1}}:result_temp[DATA_WIDTH - 1 : 0];
        result_valid <= data1_vector_valid & data2_vector_valid;
    end
end

Adder_8_gen Adder_8_gen_i (
  .A(data1_vector),      // input wire [7 : 0] A
  .B(data2_vector),      // input wire [7 : 0] B
  .CLK(clk),  // input wire CLK
  .S(result)      // output wire [7 : 0] S
);

endmodule


module Relu #(
    parameter DATA_WIDTH = 8
) (
    input                             clk,
    input                             rst_n,

    input        [DATA_WIDTH-1 : 0]   data1_vector,
    input                             data1_vector_valid,

    output reg   [DATA_WIDTH - 1 : 0] result,
    output reg                        result_valid
);

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        result_valid <= 0;
        result <= {DATA_WIDTH{1'b0}};
    end
    else begin
        result_valid <= data1_vector_valid;
        result <= data1_vector[DATA_WIDTH-1]?{DATA_WIDTH{1'b0}}:data1_vector;
    end
end
    
endmodule