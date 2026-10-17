
`timescale 1ns / 1ps

module sub_parser #(
    //for 100g MAC, the AXIS width is 512b
	parameter PARSE_ACT_RAM_WIDTH = 167,
    parameter C_PARSE_ACTION_LEN = 16,
    parameter HDR_FIELD_LEN = 2048,
    parameter VAL_LEN = 64
    )(
    input									axis_clk,
	input									aresetn,

	// input slvae axi stream
	input [HDR_FIELD_LEN-1:0]               pkt_hdr_field,
    input                                   pkt_hdr_field_valid,

    input  [C_PARSE_ACTION_LEN-1:0]         parse_action,
    input                                   parse_action_valid_in,

	// output
	output reg   							val_valid_out,
	output reg [VAL_LEN-1:0]     		    val_out,
    output reg [1:0]                        val_out_select,
    output reg [3:0]                        val_seq_select
);


reg [HDR_FIELD_LEN-1:0] pkt_hdr_field_reg;

always @(posedge axis_clk or negedge aresetn) begin
    if(~aresetn) begin
        val_valid_out <= 0;
        val_out <= 0;
        val_out_select <= 0;
        pkt_hdr_field_reg <= 0;
        val_seq_select <= 0;
    end

    else begin
        case(pkt_hdr_field_valid && parse_action_valid_in)
            1'b1: begin
                val_valid_out <= 1'b1;
                val_seq_select <= parse_action[4:1];	//Ë÷ÒýÎ»ÖÃ
                case({parse_action[6:5],parse_action[0]})
                    3'b011: begin
                        val_out_select <= 2'b01;
                        val_out[15:0] <= pkt_hdr_field[(parse_action[14:7])*8 +:16];
//                        case(parse_action[3:1])
//                            0 : begin
//				    			val_out[15:0] <= pkt_hdr_field[(parse_action[14:7])*8 +:16];
//				    		end
//				    		1 : begin
//				    			val_out[15:0] <= pkt_hdr_field[(parse_action[14:7])*8 +:16];
//				    		end
//				    		2 : begin
//				    			val_out[15:0] <= pkt_hdr_field[(parse_action[14:7])*8 +:16];
//				    		end
//				    		3 : begin
//				    			val_out[15:0] <= pkt_hdr_field[(parse_action[14:7])*8 +:16];
//				    		end
//				    		4 : begin
//				    			val_out[15:0] <= pkt_hdr_field[(parse_action[14:7])*8 +:16];
//				    		end
//				    		5 : begin
//				    			val_out[15:0] <= pkt_hdr_field[(parse_action[12:6])*8 +:16];
//				    		end
//				    		6 : begin
//				    			val_out[15:0]<= pkt_hdr_field[(parse_action[12:6])*8 +:16];
//				    		end
//				    		7 : begin
//				    			val_out[15:0] <= pkt_hdr_field[(parse_action[12:6])*8 +:16];
//				    		end
//                        endcase
                    end
                    3'b101: begin
                        val_out_select <= 2'b10;
                        val_out[31:0] <= pkt_hdr_field[(parse_action[14:7])*8 +:32];
//                        case(parse_action[3:1])
//                            0 : begin
//				    			val_out[31:0] <= pkt_hdr_field[(parse_action[12:6])*8 +:32];
//				    		end
//				    		1 : begin
//				    			val_out[31:0] <= pkt_hdr_field[(parse_action[12:6])*8 +:32];
//				    		end
//				    		2 : begin
//				    			val_out[31:0] <= pkt_hdr_field[(parse_action[12:6])*8 +:32];
//				    		end
//				    		3 : begin
//				    			val_out[31:0] <= pkt_hdr_field[(parse_action[12:6])*8 +:32];
//				    		end
//				    		4 : begin
//				    			val_out[31:0] <= pkt_hdr_field[(parse_action[12:6])*8 +:32];
//				    		end
//				    		5 : begin
//				    			val_out[31:0] <= pkt_hdr_field[(parse_action[12:6])*8 +:32];
//				    		end
//				    		6 : begin
//				    			val_out[31:0]<= pkt_hdr_field[(parse_action[12:6])*8 +:32];
//				    		end
//				    		7 : begin
//				    			val_out[31:0] <= pkt_hdr_field[(parse_action[12:6])*8 +:32];
//				    		end
//                        endcase
                    end
                    3'b111: begin
                        val_out_select <= 2'b11;
                        val_out <= pkt_hdr_field[(parse_action[14:7])*8 +:64];
//                        case(parse_action[3:1])
//                            0 : begin
//				    			val_out <= pkt_hdr_field[(parse_action[12:6])*8 +:48];
//				    		end
//				    		1 : begin
//				    			val_out <= pkt_hdr_field[(parse_action[12:6])*8 +:48];
//				    		end
//				    		2 : begin
//				    			val_out <= pkt_hdr_field[(parse_action[12:6])*8 +:48];
//				    		end
//				    		3 : begin
//				    			val_out <= pkt_hdr_field[(parse_action[12:6])*8 +:48];
//				    		end
//				    		4 : begin
//				    			val_out <= pkt_hdr_field[(parse_action[12:6])*8 +:48];
//				    		end
//				    		5 : begin
//				    			val_out <= pkt_hdr_field[(parse_action[12:6])*8 +:48];
//				    		end
//				    		6 : begin
//				    			val_out <= pkt_hdr_field[(parse_action[12:6])*8 +:48];
//				    		end
//				    		7 : begin
//				    			val_out <= pkt_hdr_field[(parse_action[12:6])*8 +:48];
//				    		end
//                        endcase
                    end
                endcase
            end
            default: begin
                val_valid_out <= 1'b0;
            end
        endcase
    end
end


endmodule