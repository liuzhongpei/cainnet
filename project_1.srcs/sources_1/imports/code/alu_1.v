/****************************************************/
//	Module name: alu_1
//	Authority @ yangxiangrui (yangxiangrui11@nudt.edu.cn)
//	Last edited time: 2023/05/25
//	Function outline: 1st type ALU (no load/store) module in RMT
/****************************************************/

`timescale 1ns / 1ps

module alu_1 #(
    parameter STAGE_ID = 0,
    parameter ACTION_LEN = 32,
    parameter DATA_WIDTH = 64  //data width of the ALU
)
(
    input clk,
    input rst_n,

    //input from sub_action
    input [ACTION_LEN-1:0]            action_in,
    input                             action_valid,
    input signed [DATA_WIDTH-1:0]            operand_1_in,
    input signed [DATA_WIDTH-1:0]            operand_2_in,

    //output to form PHV
    output reg [DATA_WIDTH-1:0]       container_out,
    output reg                        container_out_valid

);

/*
4 operations to support:

1,2. add/sub:   0001/0010
              extract 2 operands from pkt header, add(sub) and write back.

3,4. addi/subi: 0011/0100
              extract op1 from pkt header, op2 from action, add(sub) and write back.
*/


localparam IDLE=0, OP_1=1, OP_2=2;

reg [1:0]					state, state_next;
reg [DATA_WIDTH-1:0]		container_out_r;
reg							container_out_valid_next;

always @(*) begin
	state_next = state;
	container_out_r = container_out;
	container_out_valid_next = 0;

	case (state)
		IDLE: begin
			if (action_valid) begin
				state_next = OP_1;
				case(action_in[6:0])
            	    7'b0010011: begin//立即数指令
            	       case(action_in[14:12])
            	           3'b000:begin
            	               container_out_r = operand_1_in + operand_2_in;
            	           end
            	           3'b100:begin
            	               container_out_r = operand_1_in ^ operand_2_in;
            	           end
            	           3'b110:begin
            	               container_out_r = operand_1_in | operand_2_in;
            	           end
            	           3'b111:begin
            	               container_out_r = operand_1_in & operand_2_in;
            	           end
            	           3'b001:begin
            	               container_out_r = operand_1_in << operand_2_in[4:0];
            	           end
            	           3'b011:begin
            	               container_out_r = operand_1_in * operand_2_in;
            	           end
            	           3'b101:begin
            	               case(action_in[31:25])
            	                   7'b0000000:begin
            	                       container_out_r = operand_1_in >> operand_2_in[4:0];
            	                   end
            	                   7'b0100000:begin
            	                       container_out_r = operand_1_in>>> operand_2_in[4:0];
            	                   end
            	                   default:begin
            	                       container_out_r = operand_1_in;
            	                   end
            	               endcase
            	           end
            	           default:begin
            	               container_out_r = operand_1_in;
            	           end
            	       endcase
            	    end
            	    7'b0110011: begin//双操作数指令
            	       case({action_in[31:25],action_in[14:12]})
            	           10'b0000000_000:begin
            	               container_out_r = operand_1_in + operand_2_in;
            	           end
            	           10'b0100000_000:begin
            	               container_out_r = operand_1_in - operand_2_in;
            	           end
            	           10'b0000000_100:begin
            	               container_out_r = operand_1_in ^ operand_2_in;
            	           end
            	           10'b0000000_110:begin
            	               container_out_r = operand_1_in | operand_2_in;
            	           end
            	           10'b0000000_111:begin
            	               container_out_r = operand_1_in & operand_2_in;
            	           end
            	           10'b0000001_000:begin
            	               container_out_r = operand_1_in * operand_2_in;
            	           end
            	           10'b0000000_001:begin
            	               container_out_r = operand_1_in << operand_2_in;
            	           end
            	           10'b0000000_101:begin
            	               container_out_r = operand_1_in >> operand_2_in;
            	           end
            	           10'b0100000_101:begin
            	               container_out_r = operand_1_in >>> operand_2_in;
            	           end
            	            default:begin
            	                container_out_r = operand_1_in;
            	           end
            	       endcase
            	    end
            	    7'b0001011:begin//set
            	       container_out_r = operand_1_in;
            	    end
            	    //if its an empty (default) action
            	    default: begin
            	        container_out_r = operand_1_in;
            	    end
            	endcase
			end
		end
		OP_1: begin
			// empty cycle
			state_next = OP_2;
		end
		OP_2: begin
			container_out_valid_next = 1;
			state_next = IDLE;
		end
	endcase
end

always @(posedge clk) begin
	if (~rst_n) begin
		container_out <= 0;
		container_out_valid <= 0;
		state <= IDLE;
	end
	else begin
		state <= state_next;
		container_out_valid <= container_out_valid_next;
		container_out <= container_out_r;
	end
end


endmodule
