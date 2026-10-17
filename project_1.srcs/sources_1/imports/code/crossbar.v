/****************************************************/
//	Module name: crossbar.v
//	Authority @ yangxiangrui (yangxiangrui11@nudt.edu.cn)
//	Last edited time: 2023/05/27
//	Function outline: crossbar used exclusively for RMT
/****************************************************/

`timescale 1ns / 1ps
module crossbar #(
    parameter STAGE_ID = 0,
    parameter PHV_LEN = 64*16+32*12+16*4+5*20+256,//8B容器
    parameter ACT_LEN = 32,//已经修改
    parameter width_2B = 16,
    parameter width_4B = 32,
    parameter width_8B = 64
)
(
    input clk,
    input rst_n,

    //input from PHV
    input [PHV_LEN-1:0]         phv_in,
    input                       phv_in_valid,

    //input from action
    input [ACT_LEN*33-1:0]      action_in,//32+1个指令
    input                       action_in_valid,

    //output to the ALU
    output reg                    alu_in_valid,
    output reg [width_8B*16-1:0]   alu_in_8B_1,
    output reg [width_8B*16-1:0]   alu_in_8B_2,
    output reg [width_4B*12-1:0]   alu_in_4B_1,
    output reg [width_4B*12-1:0]   alu_in_4B_2,
    output reg [width_2B*4-1:0]   alu_in_2B_1,
    output reg [width_2B*4-1:0]   alu_in_2B_2,
    output reg [355:0]            phv_remain_data,

    //I have to delay action_in for ALUs for 1 cycle
    output reg [ACT_LEN*33-1:0]   action_out,
    output reg                    action_valid_out
);

/********intermediate variables declared here********/
integer i;


wire [width_8B-1:0]      cont_8B [0:15];
wire [width_4B-1:0]      cont_4B [0:11];
wire [width_2B-1:0]      cont_2B [0:3];

wire [ACT_LEN-1:0]       sub_action [32:0];//32+1


/********intermediate variables declared here********/
assign cont_8B[15] = phv_in[PHV_LEN-1             -: width_8B];
assign cont_8B[14] = phv_in[PHV_LEN-1-   width_8B -: width_8B];
assign cont_8B[13] = phv_in[PHV_LEN-1- 2*width_8B -: width_8B];
assign cont_8B[12] = phv_in[PHV_LEN-1- 3*width_8B -: width_8B];
assign cont_8B[11] = phv_in[PHV_LEN-1- 4*width_8B -: width_8B];
assign cont_8B[10] = phv_in[PHV_LEN-1- 5*width_8B -: width_8B];
assign cont_8B[9] = phv_in[PHV_LEN-1- 6*width_8B -: width_8B];
assign cont_8B[8] = phv_in[PHV_LEN-1- 7*width_8B -: width_8B];
assign cont_8B[7] = phv_in[PHV_LEN-1- 8*width_8B -: width_8B];
assign cont_8B[6] = phv_in[PHV_LEN-1- 9*width_8B -: width_8B];
assign cont_8B[5] = phv_in[PHV_LEN-1-10*width_8B -: width_8B];
assign cont_8B[4] = phv_in[PHV_LEN-1-11*width_8B -: width_8B];
assign cont_8B[3] = phv_in[PHV_LEN-1-12*width_8B -: width_8B];
assign cont_8B[2] = phv_in[PHV_LEN-1-13*width_8B -: width_8B];
assign cont_8B[1] = phv_in[PHV_LEN-1-14*width_8B -: width_8B];
assign cont_8B[0] = phv_in[PHV_LEN-1-15*width_8B -: width_8B];

assign cont_4B[11] = phv_in[PHV_LEN-1-16*width_8B           -: width_4B];
assign cont_4B[10] = phv_in[PHV_LEN-1-16*width_8B-width_4B  -: width_4B];
assign cont_4B[9] = phv_in[PHV_LEN-1-16*width_8B-2*width_4B -: width_4B];
assign cont_4B[8] = phv_in[PHV_LEN-1-16*width_8B-3*width_4B -: width_4B];
assign cont_4B[7] = phv_in[PHV_LEN-1-16*width_8B-4*width_4B -: width_4B];
assign cont_4B[6] = phv_in[PHV_LEN-1-16*width_8B-5*width_4B -: width_4B];
assign cont_4B[5] = phv_in[PHV_LEN-1-16*width_8B-6*width_4B -: width_4B];
assign cont_4B[4] = phv_in[PHV_LEN-1-16*width_8B-7*width_4B -: width_4B];
assign cont_4B[3] = phv_in[PHV_LEN-1-16*width_8B-8*width_4B -: width_4B];
assign cont_4B[2] = phv_in[PHV_LEN-1-16*width_8B-9*width_4B -: width_4B];
assign cont_4B[1] = phv_in[PHV_LEN-1-16*width_8B-10*width_4B -: width_4B];
assign cont_4B[0] = phv_in[PHV_LEN-1-16*width_8B-11*width_4B -: width_4B];


assign cont_2B[3] = phv_in[PHV_LEN-1-16*width_8B-12*width_4B            -: width_2B];
assign cont_2B[2] = phv_in[PHV_LEN-1-16*width_8B-12*width_4B-  width_2B -: width_2B];
assign cont_2B[1] = phv_in[PHV_LEN-1-16*width_8B-12*width_4B-2*width_2B -: width_2B];
assign cont_2B[0] = phv_in[PHV_LEN-1-16*width_8B-12*width_4B-3*width_2B -: width_2B];

// Tao: get action for each PHV container               					
assign sub_action[32] = action_in[ACT_LEN*33-1           -:ACT_LEN];        // 1st action
assign sub_action[31] = action_in[ACT_LEN*33-1 -  ACT_LEN-:ACT_LEN];		// 2nd action
assign sub_action[30] = action_in[ACT_LEN*33-1 -2*ACT_LEN-:ACT_LEN];		// 3rd action
assign sub_action[29] = action_in[ACT_LEN*33-1 -3*ACT_LEN-:ACT_LEN];
assign sub_action[28] = action_in[ACT_LEN*33-1 -4*ACT_LEN-:ACT_LEN];
assign sub_action[27] = action_in[ACT_LEN*33-1 -5*ACT_LEN-:ACT_LEN];
assign sub_action[26] = action_in[ACT_LEN*33-1 -6*ACT_LEN-:ACT_LEN];
assign sub_action[25] = action_in[ACT_LEN*33-1 -7*ACT_LEN-:ACT_LEN];

assign sub_action[24] = action_in[ACT_LEN*33-1 -8*ACT_LEN-:ACT_LEN];
assign sub_action[23] = action_in[ACT_LEN*33-1 -9*ACT_LEN-:ACT_LEN];
assign sub_action[22] = action_in[ACT_LEN*33-1 -10*ACT_LEN-:ACT_LEN];
assign sub_action[21] = action_in[ACT_LEN*33-1 -11*ACT_LEN-:ACT_LEN];
assign sub_action[20] = action_in[ACT_LEN*33-1 -12*ACT_LEN-:ACT_LEN];
assign sub_action[19] = action_in[ACT_LEN*33-1 -13*ACT_LEN-:ACT_LEN];
assign sub_action[18] = action_in[ACT_LEN*33-1 -14*ACT_LEN-:ACT_LEN];
assign sub_action[17] = action_in[ACT_LEN*33-1 -15*ACT_LEN-:ACT_LEN];

assign sub_action[16] = action_in[ACT_LEN*33-1 -16*ACT_LEN-:ACT_LEN];
assign sub_action[15] = action_in[ACT_LEN*33-1 -17*ACT_LEN-:ACT_LEN];
assign sub_action[14] = action_in[ACT_LEN*33-1 -18*ACT_LEN-:ACT_LEN];
assign sub_action[13] = action_in[ACT_LEN*33-1 -19*ACT_LEN-:ACT_LEN];
assign sub_action[12] = action_in[ACT_LEN*33-1 -20*ACT_LEN-:ACT_LEN];
assign sub_action[11] = action_in[ACT_LEN*33-1 -21*ACT_LEN-:ACT_LEN];
assign sub_action[10] = action_in[ACT_LEN*33-1 -22*ACT_LEN-:ACT_LEN];
assign sub_action[9] = action_in[ACT_LEN*33-1 -23*ACT_LEN-:ACT_LEN];

assign sub_action[8] = action_in[ACT_LEN*33-1 -24*ACT_LEN-:ACT_LEN];
assign sub_action[7] = action_in[ACT_LEN*33-1 -25*ACT_LEN-:ACT_LEN];
assign sub_action[6] = action_in[ACT_LEN*33-1 -26*ACT_LEN-:ACT_LEN];
assign sub_action[5] = action_in[ACT_LEN*33-1 -27*ACT_LEN-:ACT_LEN];
assign sub_action[4] = action_in[ACT_LEN*33-1 -28*ACT_LEN-:ACT_LEN];
assign sub_action[3] = action_in[ACT_LEN*33-1 -29*ACT_LEN-:ACT_LEN];
assign sub_action[2] = action_in[ACT_LEN*33-1 -30*ACT_LEN-:ACT_LEN];
assign sub_action[1] = action_in[ACT_LEN*33-1 -31*ACT_LEN-:ACT_LEN];
assign sub_action[0] = action_in[ACT_LEN*33-1 -32*ACT_LEN-:ACT_LEN];

//assign inputs for ALUs 

always @(posedge clk) begin
    action_out <= action_in;
    action_valid_out <= action_in_valid;
end

always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        // phv_reg <= 1124'b0;
        // action_full_reg <= 625'b0;
        // phv_valid_reg <= 1'b0;
        // action_valid_reg <= 1'b0;
        //reset outputs
        alu_in_valid <= 1'b0;
        phv_remain_data <= 356'b0;//存储元数据
        //reset all the outputs
        alu_in_8B_1 <= 1024'b0;
        alu_in_8B_2 <= 1024'b0;
        alu_in_4B_1 <= 384'b0;
        alu_in_4B_2 <= 384'b0;
        alu_in_2B_1 <= 64'b0;
        alu_in_2B_2 <= 64'b0;
        
    end
    
    else begin
        if(phv_in_valid == 1'b1) begin
            alu_in_valid <= 1'b1;
            //assign values one by one (of course need to consider act format)
            for(i=15; i>=0; i=i-1) begin
                case(sub_action[16+i+1][6:0])
                    //be noted that 2 ops need to be the same width
                    7'b0110011: begin
                        if(sub_action[16+i+1][19:15]>5'b01111) begin
                            alu_in_8B_1[(i+1)*width_8B-1 -: width_8B] <= cont_8B[sub_action[16+i+1][19:15]-16];
                        end
                        else begin
                            alu_in_8B_1[(i+1)*width_8B-1 -: width_8B] <= cont_8B[i];
                        end
                        if(sub_action[16+i+1][24:20]>5'b01111) begin
                            alu_in_8B_2[(i+1)*width_8B-1 -: width_8B] <= cont_8B[sub_action[16+i+1][24:20]-16];
                        end
                        else begin
                            alu_in_8B_2[(i+1)*width_8B-1 -: width_8B] <= cont_8B[i];
                        end
                    end
                    //extracted from action field (imm)
                    7'b0010011: 
                    begin
                        case(sub_action[16+i+1][14:12])
                            3'b000,3'b010,3'b100,3'b110,3'b111,3'b001,3'b011:begin
                                if(sub_action[16+i+1][19:15] > 5'b01111) begin
                                    alu_in_8B_1[(i+1)*width_8B-1 -: width_8B] <= cont_8B[sub_action[16+i+1][19:15]-16];
                                end
                                else begin
                                    alu_in_8B_1[(i+1)*width_8B-1 -: width_8B] <= cont_8B[i];
                                end
                                alu_in_8B_2[(i+1)*width_8B-1 -: width_8B] <= {52'b0,sub_action[16+i+1][31:20]};
                            end
                            3'b001,3'b101:begin
                                if(sub_action[16+i+1][19:15] > 5'b01111) begin
                                    alu_in_8B_1[(i+1)*width_8B-1 -: width_8B] <= cont_8B[sub_action[16+i+1][19:15]-16];
                                end
                                else begin
                                    alu_in_8B_1[(i+1)*width_8B-1 -: width_8B] <= cont_8B[i];
                                end
                                alu_in_8B_2[(i+1)*width_8B-1 -: width_8B] <= {59'b0,sub_action[16+i+1][24:20]};
                            end
                            default:begin
                                alu_in_8B_1[(i+1)*width_8B-1 -: width_8B] <= cont_8B[i];
                                alu_in_8B_2[(i+1)*width_8B-1 -: width_8B] <= cont_8B[i];
                            end 
                        endcase
                    end
                    7'b0001011:begin
                        alu_in_8B_1[(i+1)*width_8B-1 -: width_8B] <= {43'b0,sub_action[16+i+1][31],sub_action[16+i+1][19:12],sub_action[16+i+1][20],sub_action[16+i+1][30:21],1'b0};        //???
                        alu_in_8B_2[(i+1)*width_8B-1 -: width_8B] <= cont_8B[i];
                    end
                    //if there is no action to take, output the original value
                    default: begin
                        //alu_1 should be set to the phv value
                        alu_in_8B_1[(i+1)*width_8B-1 -: width_8B] <= cont_8B[i];
                        alu_in_8B_2[(i+1)*width_8B-1 -: width_8B] <= cont_8B[i];
                    end
                endcase
            end
            
            
            
            //4B is a bit of differernt from 2B and 6B
            for(i=11; i>=0; i=i-1) begin
                case(sub_action[4+i+1][6:0])
                    //be noted that 2 ops need to be the same width
                    7'b0110011: begin
                        if(sub_action[4+i+1][19:15] > 5'b00011 && sub_action[4+i+1][19:15]<5'b10000) begin
                            alu_in_4B_1[(i+1)*width_4B-1 -: width_4B] <= cont_4B[sub_action[4+i+1][19:15]-4];
                        end
                        else begin
                            alu_in_4B_1[(i+1)*width_4B-1 -: width_4B] <= cont_4B[i];
                        end
                        if(sub_action[4+i+1][24:20] > 5'b00011 && sub_action[4+i+1][24:20]<5'b10000) begin
                            alu_in_4B_2[(i+1)*width_4B-1 -: width_4B] <= cont_4B[sub_action[4+i+1][24:20]-4];
                        end
                        else begin
                            alu_in_4B_2[(i+1)*width_4B-1 -: width_4B] <=cont_4B[i];
                        end
                    end
                    7'b0010011: begin
                        case(sub_action[4+i+1][14:12])
                            3'b000,3'b010,3'b100,3'b110,3'b111,3'b001,3'b011:begin
                                if(sub_action[4+i+1][19:15] > 5'b00011 && sub_action[4+i+1][19:15]<5'b10000) begin
                                    alu_in_4B_1[(i+1)*width_4B-1 -: width_4B] <= cont_4B[sub_action[4+i+1][19:15]-4];
                                end
                                else begin
                                    alu_in_4B_1[(i+1)*width_4B-1 -: width_4B] <=cont_4B[i];
                                end
                                alu_in_4B_2[(i+1)*width_4B-1 -: width_4B] <= {20'b0,sub_action[4+i+1][31:20]};
                            end
                            3'b001,3'b101:begin
                                if(sub_action[4+i+1][19:15] > 5'b00011 && sub_action[4+i+1][19:15]<5'b10000) begin
                                    alu_in_4B_1[(i+1)*width_4B-1 -: width_4B] <= cont_4B[sub_action[4+i+1][19:15]-4];
                                end
                                else begin
                                    alu_in_4B_1[(i+1)*width_4B-1 -: width_4B] <= cont_4B[i];
                                end
                                alu_in_4B_2[(i+1)*width_4B-1 -: width_4B] <= {27'b0,sub_action[4+i+1][24:20]};
                            end
                            default:begin
                                alu_in_4B_1[(i+1)*width_4B-1 -: width_4B] <= cont_4B[i];
                                alu_in_4B_2[(i+1)*width_4B-1 -: width_4B] <= cont_4B[i];
                            end 
                        endcase
                    end
                    7'b0000011: begin//load
                        if(sub_action[4+i+1][19:15] > 5'b00011 && sub_action[4+i+1][19:15]<5'b10000) begin
                            alu_in_4B_1[(i+1)*width_4B-1 -: width_4B] <= cont_4B[sub_action[4+i+1][19:15]-4];
                        end
                        else begin
                            alu_in_4B_1[(i+1)*width_4B-1 -: width_4B] <= cont_4B[i];
                        end
                        alu_in_4B_2[(i+1)*width_4B-1 -: width_4B] <= {20'b0,sub_action[4+i+1][31:20]};
                    end
                    7'b0100011: begin//store
                        if(sub_action[4+i+1][19:15] > 5'b00011 && sub_action[4+i+1][19:15]<5'b10000) begin
                            alu_in_4B_1[(i+1)*width_4B-1 -: width_4B] <= cont_4B[sub_action[4+i+1][19:15]-4];
                        end
                        else begin
                            alu_in_4B_1[(i+1)*width_4B-1 -: width_4B] <= cont_4B[i];
                        end
                        alu_in_4B_2[(i+1)*width_4B-1 -: width_4B] <= {20'b0,sub_action[4+i+1][31:25],sub_action[4+i+1][11:7]};
                    end
                    7'b0001011:begin
                        alu_in_4B_1[(i+1)*width_4B-1 -: width_4B] <= {11'b0,sub_action[4+i+1][31],sub_action[4+i+1][19:12],sub_action[4+i+1][20],sub_action[4+i+1][30:21],1'b0};        //???
                        alu_in_4B_2[(i+1)*width_4B-1 -: width_4B] <=cont_4B[i];
                    end
                    //if there is no action to take, output the original value
                    default: begin
                        //alu_1 should be set to the phv value
                        alu_in_4B_1[(i+1)*width_4B-1 -: width_4B] <= cont_4B[i];
                        alu_in_4B_2[(i+1)*width_4B-1 -: width_4B] <= cont_4B[i];
                    end
                endcase
            end
           
            
            
            for(i=3; i>=0; i=i-1) begin
                case(sub_action[i+1][6:0])
                    //be noted that 2 ops need to be the same width
                    7'b0110011: begin
                        if(sub_action[i+1][19:15]<5'b00100) begin
                            alu_in_2B_1[(i+1)*width_2B-1 -: width_2B] <= cont_2B[sub_action[i+1][19:15]];
                        end
                        else begin
                            alu_in_2B_1[(i+1)*width_2B-1 -: width_2B] <= cont_2B[i];
                        end
                        if(sub_action[i+1][24:20]<5'b00100) begin
                            alu_in_2B_2[(i+1)*width_2B-1 -: width_2B] <= cont_2B[sub_action[i+1][24:20]];
                        end
                        else begin
                            alu_in_2B_2[(i+1)*width_2B-1 -: width_2B] <= cont_2B[i];
                        end
                    end
                    //extracted from action field (imm)
                    7'b0010011: 
                    begin
                        case(sub_action[i+1][14:12])
                            3'b000,3'b010,3'b100,3'b110,3'b111,3'b001,3'b011:begin
                                if(sub_action[i+1][19:15]<5'b00100) begin
                                    alu_in_2B_1[(i+1)*width_2B-1 -: width_2B] <= cont_2B[sub_action[i+1][19:15]];
                                end
                                else begin
                                    alu_in_2B_1[(i+1)*width_2B-1 -: width_2B] <= cont_2B[i];
                                end
                                alu_in_2B_2[(i+1)*width_2B-1 -: width_2B] <= {4'b0,sub_action[i+1][31:20]};
                            end
                            3'b001,3'b101:begin
                                if(sub_action[i+1][19:15]<5'b00100) begin
                                    alu_in_2B_1[(i+1)*width_2B-1 -: width_2B] <= cont_2B[sub_action[i+1][19:15]];
                                end
                                else begin
                                    alu_in_2B_1[(i+1)*width_2B-1 -: width_2B] <= cont_2B[i];
                                end
                                alu_in_2B_2[(i+1)*width_2B-1 -: width_2B] <= {11'b0,sub_action[i+1][24:20]};
                            end
                            default:begin
                                alu_in_2B_1[(i+1)*width_2B-1 -: width_2B] <= cont_2B[i];
                                alu_in_2B_2[(i+1)*width_2B-1 -: width_2B] <= cont_2B[i];
                            end 
                        endcase
                    end
                    7'b0001011:begin    //在2B容器中，由于指令中立即数有20位，所以先把20位立即数排序，然后取了低16位，即imm[16:12|20|30:21]
                        alu_in_2B_1[(i+1)*width_2B-1 -: width_2B] <= {sub_action[i+1][16:12],sub_action[i+1][20],sub_action[i+1][30:21]};        //???
                        alu_in_2B_2[(i+1)*width_2B-1 -: width_2B] <= cont_2B[i];
                    end
                    //if there is no action to take, output the original value
                    default: begin
                        //alu_1 should be set to the phv value
                        alu_in_2B_1[(i+1)*width_2B-1 -: width_2B] <= cont_2B[i];
                        alu_in_2B_2[(i+1)*width_2B-1 -: width_2B] <= cont_2B[i];
                    end
                endcase
            end
            
            //the left is metadata & conditional ins, no need to modify
            phv_remain_data <= phv_in[355:0];
        end 

        else begin
            alu_in_valid <= 1'b0;
        end
    end
end

endmodule
