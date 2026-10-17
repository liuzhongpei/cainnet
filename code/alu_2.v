/****************************************************/
//	Module name: alu_1
//	Authority @ yangxiangrui (yangxiangrui11@nudt.edu.cn)
//	Last edited time: 2023/05/25
//	Function outline: 1st type ALU (no load/store) module in RMT
/****************************************************/

`timescale 1ns / 1ps

module alu_2 #(
    parameter STAGE_ID = 0,
    parameter ACTION_LEN = 32,
    parameter DATA_WIDTH = 32  //data width of the ALU
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


localparam IDLE=0, EMPTY_S=1, OUTPUT_S=2;

reg  [6:0]           action_type, action_type_r;

//regs for RAM access
reg                  store_en, store_en_r;
reg  [6:0]           store_addr, store_addr_r;
reg  [31:0]          store_din,	 store_din_r;

wire [31:0]          load_data;
wire [6:0]           load_addr;

reg [1:0]					state, state_next;
reg [DATA_WIDTH-1:0]		container_out_r;
reg							container_out_valid_next;


assign load_addr = action_in[26:20]+operand_1_in[6:0];
always @(*) begin
	state_next = state;
	
	action_type_r = action_type;
	container_out_r = container_out;
	container_out_valid_next = 0;
	
	store_en_r = store_en;
	store_addr_r = store_addr;
	store_din_r = store_din;

	case (state)
		IDLE: begin
			if (action_valid) begin
			    action_type_r = action_in[6:0];
				state_next = EMPTY_S;
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
            	                       container_out_r = operand_1_in >>> operand_2_in[4:0];
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
            	    7'b0100011:begin//store op(interact with RAM)
            	       container_out_r = operand_1_in;
                        store_en_r = 1;
                        store_addr_r ={action_in[26:25],action_in[11:7]};
                        store_din_r = operand_1_in;
            	    end
            	    7'b0000011:begin//load op(interact with RAM)
            	       // do nothing now
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
		EMPTY_S: begin
			// empty cycle
			state_next = OUTPUT_S;
		end
		OUTPUT_S: begin
			container_out_valid_next = 1;
			if(action_type == 7'b0000011) begin
                container_out_r = load_data;
            end
			state_next = IDLE;
			
			// clear out store signals
			store_en_r = 0;
			store_addr_r = 0;
			store_din_r = 0;
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
		action_type <= action_type_r;
		container_out_valid <= container_out_valid_next;
		container_out <= container_out_r;
		
		store_en <= store_en_r;
		store_addr <= store_addr_r;
		store_din <= store_din_r;
	end
end

//ram for key-value
//2 cycles to get value
// blk_mem_gen_0 # (
// 	.C_INIT_FILE_NAME	("./alu_2.mif"),
// 	.C_LOAD_INIT_FILE	(1)
// )
blk_mem_gen_0
data_ram_32w_128d
(
    //store-related
    .addra(store_addr),
    .clka(clk),
    .dina(store_din),
    .ena(1'b1),
    .wea(store_en),

    //load-related
    .addrb(load_addr),
    .clkb(clk),
    .doutb(load_data),
    .enb(1'b1)
);

endmodule
