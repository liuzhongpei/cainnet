`timescale 1ns / 1ps

module deparser #(
	//in corundum with 100g ports, data width is 512b
	parameter	C_S_AXIS_DATA_WIDTH = 256,
	parameter	C_S_AXIS_TUSER_WIDTH = 128,
	parameter	C_PKT_VEC_WIDTH = 8*8*16+4*8*12+2*8*4+20*5+256,//1024+384+64+356
    parameter   DEPARSER_ID = 3'b101
)
(
	input									clk,
	input									aresetn,

	input [C_S_AXIS_DATA_WIDTH-1:0]			pkt_fifo_tdata,
	input [C_S_AXIS_DATA_WIDTH/8-1:0]		pkt_fifo_tkeep,
	input [C_S_AXIS_TUSER_WIDTH-1:0]		pkt_fifo_tuser,
	// input								pkt_fifo_tvalid,
	input									pkt_fifo_tlast,
	input									pkt_fifo_empty,
	output reg							    pkt_fifo_rd_en,

	input [C_PKT_VEC_WIDTH-1:0]				phv_fifo_out,
	input									phv_fifo_empty,
	output reg								phv_fifo_rd_en,

	//output reg [C_S_AXIS_DATA_WIDTH-1:0]   id,
	output reg								depar_out_tlast,
	input									depar_out_tready,

    //control path	depar_out_tdata,
    output reg [C_S_AXIS_DATA_WIDTH-1:0]    depar_out_tdata,
	output reg [C_S_AXIS_DATA_WIDTH/8-1:0]	depar_out_tkeep,
	output reg [C_S_AXIS_TUSER_WIDTH-1:0]	depar_out_tuser,
	output reg                             depar_out_tvalid,
	output reg								depar_out_tval,
    input [C_S_AXIS_DATA_WIDTH-1:0]			c_s_axis_tdata,
	input [C_S_AXIS_TUSER_WIDTH-1:0]		c_s_axis_tuser,
	input [C_S_AXIS_DATA_WIDTH/8-1:0]		c_s_axis_tkeep,
	input									c_s_axis_tvalid,
	input									c_s_axis_tlast

);

wire  [11:0]   vlan_id;

wire [611:0]  bram_out;

// wire [6:0]    parse_action_ind [0:9];
// wire [15:0]   parse_action [0:9];		// we have 10 parse action
reg  [15:0]   parse_action[0:31];
reg  [7:0]    parse_action_ind [0:31];
wire [255:0]   metadata;

assign vlan_id = phv_fifo_out[129+:12];
assign metadata = phv_fifo_out[255:0];

always @(posedge clk) begin
    // vlan_id <= phv_fifo_out[129+:12];
    parse_action[31] <= bram_out[100+:16];
    parse_action[30] <= bram_out[116+:16];
    parse_action[29] <= bram_out[132+:16];
    parse_action[28] <= bram_out[148+:16];
    parse_action[27] <= bram_out[164+:16];
    parse_action[26] <= bram_out[180+:16];
    parse_action[25] <= bram_out[196+:16];
    parse_action[24] <= bram_out[212+:16];
    parse_action[23] <= bram_out[228+:16];
    parse_action[22] <= bram_out[244+:16];
    parse_action[21] <= bram_out[260+:16];
    parse_action[20] <= bram_out[276+:16];
    parse_action[19] <= bram_out[292+:16];
    parse_action[18] <= bram_out[308+:16];
    parse_action[17] <= bram_out[324+:16];
    parse_action[16] <= bram_out[340+:16];
    parse_action[15] <= bram_out[356+:16];
    parse_action[14] <= bram_out[372+:16];
    parse_action[13] <= bram_out[388+:16];
    parse_action[12] <= bram_out[404+:16];
    parse_action[11] <= bram_out[420+:16];
    parse_action[10] <= bram_out[436+:16];
    parse_action[9] <= bram_out[452+:16];
    parse_action[8] <= bram_out[468+:16];
    parse_action[7] <= bram_out[484+:16];
    parse_action[6] <= bram_out[500+:16];
    parse_action[5] <= bram_out[516+:16];
    parse_action[4] <= bram_out[532+:16];
    parse_action[3] <= bram_out[548+:16];
    parse_action[2] <= bram_out[564+:16];
    parse_action[1] <= bram_out[580+:16];
    parse_action[0] <= bram_out[596+:16];
    
    parse_action_ind[0] <= parse_action[0][14:7];
    parse_action_ind[1] <= parse_action[1][14:7];
    parse_action_ind[2] <= parse_action[2][14:7];
    parse_action_ind[3] <= parse_action[3][14:7];
    parse_action_ind[4] <= parse_action[4][14:7];
    parse_action_ind[5] <= parse_action[5][14:7];
    parse_action_ind[6] <= parse_action[6][14:7];
    parse_action_ind[7] <= parse_action[7][14:7];
    parse_action_ind[8] <= parse_action[8][14:7];
    parse_action_ind[9] <= parse_action[9][14:7];
    parse_action_ind[10] <= parse_action[10][14:7];
    parse_action_ind[11] <= parse_action[11][14:7];
    parse_action_ind[12] <= parse_action[12][14:7];
    parse_action_ind[13] <= parse_action[13][14:7];
    parse_action_ind[14] <= parse_action[14][14:7];
    parse_action_ind[15] <= parse_action[15][14:7];
    parse_action_ind[16] <= parse_action[16][14:7];
    parse_action_ind[17] <= parse_action[17][14:7];
    parse_action_ind[18] <= parse_action[18][14:7];
    parse_action_ind[19] <= parse_action[19][14:7];
    parse_action_ind[20] <= parse_action[20][14:7];
    parse_action_ind[21] <= parse_action[21][14:7];
    parse_action_ind[22] <= parse_action[22][14:7];
    parse_action_ind[23] <= parse_action[23][14:7];
    parse_action_ind[24] <= parse_action[24][14:7];
    parse_action_ind[25] <= parse_action[25][14:7];
    parse_action_ind[26] <= parse_action[26][14:7];
    parse_action_ind[27] <= parse_action[27][14:7];
    parse_action_ind[28] <= parse_action[28][14:7];
    parse_action_ind[29] <= parse_action[29][14:7];
    parse_action_ind[30] <= parse_action[30][14:7];
    parse_action_ind[31] <= parse_action[31][14:7];
end




/*********************************state***************************************/
localparam PHV_2B_START_POS = 20*5+256;
localparam PHV_4B_START_POS = 20*5+256+16*4;
localparam PHV_8B_START_POS = 20*5+256+16*4+32*12;

reg  [9:0]  deparse_state;

localparam  IDLE_S = 10'd0,
            BUF_HDR_0 = 10'd1,
            BUF_HDR_1 = 10'd2,
            BUF_HDR_2 = 10'd3,
            BUF_HDR_3 = 10'd4,
            WAIT_ONE = 10'd5,
            WAIT_SUB = 10'd6,
            REFORM_HDR = 10'd7,
            FLUSH_PKT_0 = 10'd8,
            FLUSH_PKT_1 = 10'd9,
            FLUSH_PKT_2 = 10'd10,
            FLUSH_PKT_3 = 10'd11,
            FLUSH_PKT = 10'd12,
            BUF_HDR_4 = 10'd13,
            BUF_HDR_5 = 10'd14,
            BUF_HDR_6 = 10'd15,
            BUF_HDR_7 = 10'd16,
            FLUSH_PKT_4 = 10'd17,
            FLUSH_PKT_5 = 10'd18,
            FLUSH_PKT_6 = 10'd19,
            FLUSH_PKT_7 = 10'd20;
            
localparam pkt_seg = 2048/C_S_AXIS_DATA_WIDTH;

reg [pkt_seg*C_S_AXIS_DATA_WIDTH-1:0]        deparse_tdata_stored_r;
reg [pkt_seg*C_S_AXIS_TUSER_WIDTH-1:0]	     deparse_tuser_stored_r;
reg [pkt_seg*(C_S_AXIS_DATA_WIDTH/8)-1:0]	 deparse_tkeep_stored_r;
reg [pkt_seg-1:0]							 deparse_tlast_stored_r;
reg [C_PKT_VEC_WIDTH-1:0]                    deparse_phv_stored_r;

integer i;

/**
divide and conquar (below)
*/

genvar index;

localparam C_PARSE_ACTION_LEN = 7;

reg [31:0]                    deparse_phv_reg_valid_in;
reg [31:0]                    sub_parse_action_valid_in;

//output from sub_deparser
wire [63:0]                  dp_val_BE[0:31];
wire [1:0]                   deparse_phv_select[0:31];
wire [31:0]                   valid_out;

//BE LE switching

wire [63:0]                 dp_val_LE[0:31];

assign dp_val_LE[0] = {dp_val_BE[0][7:0], dp_val_BE[0][15:8], dp_val_BE[0][23:16], dp_val_BE[0][31:24], dp_val_BE[0][39:32], dp_val_BE[0][47:40], dp_val_BE[0][55:48], dp_val_BE[0][63:56]};
assign dp_val_LE[1] = {dp_val_BE[1][7:0], dp_val_BE[1][15:8], dp_val_BE[1][23:16], dp_val_BE[1][31:24], dp_val_BE[1][39:32], dp_val_BE[1][47:40], dp_val_BE[1][55:48], dp_val_BE[1][63:56]};
assign dp_val_LE[2] = {dp_val_BE[2][7:0], dp_val_BE[2][15:8], dp_val_BE[2][23:16], dp_val_BE[2][31:24], dp_val_BE[2][39:32], dp_val_BE[2][47:40], dp_val_BE[2][55:48], dp_val_BE[2][63:56]};
assign dp_val_LE[3] = {dp_val_BE[3][7:0], dp_val_BE[3][15:8], dp_val_BE[3][23:16], dp_val_BE[3][31:24], dp_val_BE[3][39:32], dp_val_BE[3][47:40], dp_val_BE[3][55:48], dp_val_BE[3][63:56]};
assign dp_val_LE[4] = {dp_val_BE[4][7:0], dp_val_BE[4][15:8], dp_val_BE[4][23:16], dp_val_BE[4][31:24], dp_val_BE[4][39:32], dp_val_BE[4][47:40], dp_val_BE[4][55:48], dp_val_BE[4][63:56]};
assign dp_val_LE[5] = {dp_val_BE[5][7:0], dp_val_BE[5][15:8], dp_val_BE[5][23:16], dp_val_BE[5][31:24], dp_val_BE[5][39:32], dp_val_BE[5][47:40], dp_val_BE[5][55:48], dp_val_BE[5][63:56]};
assign dp_val_LE[6] = {dp_val_BE[6][7:0], dp_val_BE[6][15:8], dp_val_BE[6][23:16], dp_val_BE[6][31:24], dp_val_BE[6][39:32], dp_val_BE[6][47:40], dp_val_BE[6][55:48], dp_val_BE[6][63:56]};
assign dp_val_LE[7] = {dp_val_BE[7][7:0], dp_val_BE[7][15:8], dp_val_BE[7][23:16], dp_val_BE[7][31:24], dp_val_BE[7][39:32], dp_val_BE[7][47:40], dp_val_BE[7][55:48], dp_val_BE[7][63:56]};
assign dp_val_LE[8] = {dp_val_BE[8][7:0], dp_val_BE[8][15:8], dp_val_BE[8][23:16], dp_val_BE[8][31:24], dp_val_BE[8][39:32], dp_val_BE[8][47:40], dp_val_BE[8][55:48], dp_val_BE[8][63:56]};
assign dp_val_LE[9] = {dp_val_BE[9][7:0], dp_val_BE[9][15:8], dp_val_BE[9][23:16], dp_val_BE[9][31:24], dp_val_BE[9][39:32], dp_val_BE[9][47:40], dp_val_BE[9][55:48], dp_val_BE[9][63:56]};
assign dp_val_LE[10] = {dp_val_BE[10][7:0], dp_val_BE[10][15:8], dp_val_BE[10][23:16], dp_val_BE[10][31:24], dp_val_BE[10][39:32], dp_val_BE[10][47:40], dp_val_BE[10][55:48], dp_val_BE[10][63:56]};
assign dp_val_LE[11] = {dp_val_BE[11][7:0], dp_val_BE[11][15:8], dp_val_BE[11][23:16], dp_val_BE[11][31:24], dp_val_BE[11][39:32], dp_val_BE[11][47:40], dp_val_BE[11][55:48], dp_val_BE[11][63:56]};
assign dp_val_LE[12] = {dp_val_BE[12][7:0], dp_val_BE[12][15:8], dp_val_BE[12][23:16], dp_val_BE[12][31:24], dp_val_BE[12][39:32], dp_val_BE[12][47:40], dp_val_BE[12][55:48], dp_val_BE[12][63:56]};
assign dp_val_LE[13] = {dp_val_BE[13][7:0], dp_val_BE[13][15:8], dp_val_BE[13][23:16], dp_val_BE[13][31:24], dp_val_BE[13][39:32], dp_val_BE[13][47:40], dp_val_BE[13][55:48], dp_val_BE[13][63:56]};
assign dp_val_LE[14] = {dp_val_BE[14][7:0], dp_val_BE[14][15:8], dp_val_BE[14][23:16], dp_val_BE[14][31:24], dp_val_BE[14][39:32], dp_val_BE[14][47:40], dp_val_BE[14][55:48], dp_val_BE[14][63:56]};
assign dp_val_LE[15] = {dp_val_BE[15][7:0], dp_val_BE[15][15:8], dp_val_BE[15][23:16], dp_val_BE[15][31:24], dp_val_BE[15][39:32], dp_val_BE[15][47:40], dp_val_BE[15][55:48], dp_val_BE[15][63:56]};
assign dp_val_LE[16] = {dp_val_BE[16][7:0], dp_val_BE[16][15:8], dp_val_BE[16][23:16], dp_val_BE[16][31:24], dp_val_BE[16][39:32], dp_val_BE[16][47:40], dp_val_BE[16][55:48], dp_val_BE[16][63:56]};
assign dp_val_LE[17] = {dp_val_BE[17][7:0], dp_val_BE[17][15:8], dp_val_BE[17][23:16], dp_val_BE[17][31:24], dp_val_BE[17][39:32], dp_val_BE[17][47:40], dp_val_BE[17][55:48], dp_val_BE[17][63:56]};
assign dp_val_LE[18] = {dp_val_BE[18][7:0], dp_val_BE[18][15:8], dp_val_BE[18][23:16], dp_val_BE[18][31:24], dp_val_BE[18][39:32], dp_val_BE[18][47:40], dp_val_BE[18][55:48], dp_val_BE[18][63:56]};
assign dp_val_LE[19] = {dp_val_BE[19][7:0], dp_val_BE[19][15:8], dp_val_BE[19][23:16], dp_val_BE[19][31:24], dp_val_BE[19][39:32], dp_val_BE[19][47:40], dp_val_BE[19][55:48], dp_val_BE[19][63:56]};
assign dp_val_LE[20] = {dp_val_BE[20][7:0], dp_val_BE[20][15:8], dp_val_BE[20][23:16], dp_val_BE[20][31:24], dp_val_BE[20][39:32], dp_val_BE[20][47:40], dp_val_BE[20][55:48], dp_val_BE[20][63:56]};
assign dp_val_LE[21] = {dp_val_BE[21][7:0], dp_val_BE[21][15:8], dp_val_BE[21][23:16], dp_val_BE[21][31:24], dp_val_BE[21][39:32], dp_val_BE[21][47:40], dp_val_BE[21][55:48], dp_val_BE[21][63:56]};
assign dp_val_LE[22] = {dp_val_BE[22][7:0], dp_val_BE[22][15:8], dp_val_BE[22][23:16], dp_val_BE[22][31:24], dp_val_BE[22][39:32], dp_val_BE[22][47:40], dp_val_BE[22][55:48], dp_val_BE[22][63:56]};
assign dp_val_LE[23] = {dp_val_BE[23][7:0], dp_val_BE[23][15:8], dp_val_BE[23][23:16], dp_val_BE[23][31:24], dp_val_BE[23][39:32], dp_val_BE[23][47:40], dp_val_BE[23][55:48], dp_val_BE[23][63:56]};
assign dp_val_LE[24] = {dp_val_BE[24][7:0], dp_val_BE[24][15:8], dp_val_BE[24][23:16], dp_val_BE[24][31:24], dp_val_BE[24][39:32], dp_val_BE[24][47:40], dp_val_BE[24][55:48], dp_val_BE[24][63:56]};
assign dp_val_LE[25] = {dp_val_BE[25][7:0], dp_val_BE[25][15:8], dp_val_BE[25][23:16], dp_val_BE[25][31:24], dp_val_BE[25][39:32], dp_val_BE[25][47:40], dp_val_BE[25][55:48], dp_val_BE[25][63:56]};
assign dp_val_LE[26] = {dp_val_BE[26][7:0], dp_val_BE[26][15:8], dp_val_BE[26][23:16], dp_val_BE[26][31:24], dp_val_BE[26][39:32], dp_val_BE[26][47:40], dp_val_BE[26][55:48], dp_val_BE[26][63:56]};
assign dp_val_LE[27] = {dp_val_BE[27][7:0], dp_val_BE[27][15:8], dp_val_BE[27][23:16], dp_val_BE[27][31:24], dp_val_BE[27][39:32], dp_val_BE[27][47:40], dp_val_BE[27][55:48], dp_val_BE[27][63:56]};
assign dp_val_LE[28] = {dp_val_BE[28][7:0], dp_val_BE[28][15:8], dp_val_BE[28][23:16], dp_val_BE[28][31:24], dp_val_BE[28][39:32], dp_val_BE[28][47:40], dp_val_BE[28][55:48], dp_val_BE[28][63:56]};
assign dp_val_LE[29] = {dp_val_BE[29][7:0], dp_val_BE[29][15:8], dp_val_BE[29][23:16], dp_val_BE[29][31:24], dp_val_BE[29][39:32], dp_val_BE[29][47:40], dp_val_BE[29][55:48], dp_val_BE[29][63:56]};
assign dp_val_LE[30] = {dp_val_BE[30][7:0], dp_val_BE[30][15:8], dp_val_BE[30][23:16], dp_val_BE[30][31:24], dp_val_BE[30][39:32], dp_val_BE[30][47:40], dp_val_BE[30][55:48], dp_val_BE[30][63:56]};
assign dp_val_LE[31] = {dp_val_BE[31][7:0], dp_val_BE[31][15:8], dp_val_BE[31][23:16], dp_val_BE[31][31:24], dp_val_BE[31][39:32], dp_val_BE[31][47:40], dp_val_BE[31][55:48], dp_val_BE[31][63:56]};

generate
    if(C_S_AXIS_DATA_WIDTH == 512) begin

        always @(posedge clk or negedge aresetn) begin
            if(~aresetn) begin
                depar_out_tdata <= 0;
                depar_out_tkeep <= 0;
                depar_out_tuser <= 0;
                depar_out_tvalid <= 0;
                depar_out_tlast <= 0;

                pkt_fifo_rd_en <= 1'b0;
                phv_fifo_rd_en <= 1'b0;

                deparse_phv_reg_valid_in <= 32'b0;
                sub_parse_action_valid_in <= 32'b0;

                deparse_phv_stored_r <= 0;

                deparse_state <= IDLE_S;
            end
            else begin
                case(deparse_state)
                    IDLE_S: begin
                        //if there is work to do:
                        if(!phv_fifo_empty && !pkt_fifo_empty) begin
                            // deparse_phv_stored_r <= phv_fifo_out;

                            // deparse_tdata_stored_r[C_S_AXIS_DATA_WIDTH-1:0] <= pkt_fifo_tdata;
                            // deparse_tuser_stored_r[C_S_AXIS_TUSER_WIDTH-1:0] <= pkt_fifo_tuser;
                         // deparse_tkeep_stored_r[(C_S_AXIS_DATA_WIDTH/8)-1:0] <= pkt_fifo_tkeep;
                         // deparse_tlast_stored_r[0] <= pkt_fifo_tlast;

                            pkt_fifo_rd_en <= 1'b1;
                    
                            // if(pkt_fifo_tlast) begin
                            //     //TODO needs to wait for the RAM
                            //     deparse_state <= WAIT_ONE;
                         // end

                            // else begin
                            //     deparse_state <= BUF_HDR_0;
                            // end
                            deparse_state <= BUF_HDR_0;

                        end
                     else begin
                            // depar_out_tdata <= 0;
                            depar_out_tkeep <= 0;
                            depar_out_tuser <= 0;
                            depar_out_tvalid <= 0;
                            depar_out_tlast <= 0;

                            pkt_fifo_rd_en <= 1'b0;
                            phv_fifo_rd_en <= 1'b0;

                            deparse_phv_reg_valid_in <= 32'b0;
                            sub_parse_action_valid_in <= 32'b0;

                            deparse_state <= IDLE_S;
                        end
                    end
            
                    BUF_HDR_0: begin
                        deparse_phv_stored_r <= phv_fifo_out;
                        deparse_phv_reg_valid_in <= 32'b1111_1111_1111_1111_1111_1111_1111_1111;
                

                        deparse_tdata_stored_r[C_S_AXIS_DATA_WIDTH-1:0] <= pkt_fifo_tdata;
                        deparse_tuser_stored_r[C_S_AXIS_TUSER_WIDTH-1:0] <= metadata[127:0];
                        deparse_tkeep_stored_r[(C_S_AXIS_DATA_WIDTH/8)-1:0] <= pkt_fifo_tkeep;
                        deparse_tlast_stored_r[0] <= pkt_fifo_tlast;

                        pkt_fifo_rd_en <= 1'b1;
                    
                        if(pkt_fifo_tlast) begin
                            deparse_state <= WAIT_ONE;
                        end

                        else begin
                            deparse_state <= BUF_HDR_1;
                        end
                    end

                    BUF_HDR_1: begin
                        deparse_tdata_stored_r[2*C_S_AXIS_DATA_WIDTH-1:C_S_AXIS_DATA_WIDTH] <= pkt_fifo_tdata;
                        deparse_tuser_stored_r[2*C_S_AXIS_TUSER_WIDTH-1:C_S_AXIS_TUSER_WIDTH] <= metadata[255 -: 128];
                        deparse_tkeep_stored_r[2*(C_S_AXIS_DATA_WIDTH/8)-1:C_S_AXIS_DATA_WIDTH/8] <= pkt_fifo_tkeep;
                        deparse_tlast_stored_r[1] <= pkt_fifo_tlast;

                        pkt_fifo_rd_en <= 1'b1;
                        deparse_phv_reg_valid_in <= 32'b0;
                        sub_parse_action_valid_in <= 32'b0;
                
                        if(pkt_fifo_tlast) begin
                            deparse_state <= WAIT_ONE;
                        end
                        else begin
                            deparse_state <= BUF_HDR_2;
                        end

                    end
                    BUF_HDR_2: begin
                        deparse_tdata_stored_r[3*C_S_AXIS_DATA_WIDTH-1:2*C_S_AXIS_DATA_WIDTH] <= pkt_fifo_tdata;
                        deparse_tuser_stored_r[3*C_S_AXIS_TUSER_WIDTH-1:2*C_S_AXIS_TUSER_WIDTH] <= pkt_fifo_tuser;
                        deparse_tkeep_stored_r[3*(C_S_AXIS_DATA_WIDTH/8)-1:2*C_S_AXIS_DATA_WIDTH/8] <= pkt_fifo_tkeep;
                        deparse_tlast_stored_r[2] <= pkt_fifo_tlast;

                        pkt_fifo_rd_en <= 1'b1;
                        deparse_phv_reg_valid_in <= 32'b0;
                        sub_parse_action_valid_in <= 32'b0;
                
                        if(pkt_fifo_tlast) begin
                            deparse_state <= WAIT_ONE;
                        end
                        else begin
                            deparse_state <= BUF_HDR_3;
                        end

                    end
                    BUF_HDR_3: begin
                        deparse_tdata_stored_r[4*C_S_AXIS_DATA_WIDTH-1:3*C_S_AXIS_DATA_WIDTH] <= pkt_fifo_tdata;
                        deparse_tuser_stored_r[4*C_S_AXIS_TUSER_WIDTH-1:3*C_S_AXIS_TUSER_WIDTH] <= pkt_fifo_tuser;
                        deparse_tkeep_stored_r[4*(C_S_AXIS_DATA_WIDTH/8)-1:3*C_S_AXIS_DATA_WIDTH/8] <= pkt_fifo_tkeep;
                        deparse_tlast_stored_r[3] <= pkt_fifo_tlast;

                        pkt_fifo_rd_en <= 1'b0;
                        //TODO push the inputs to sub_deparser
                        deparse_phv_reg_valid_in <= 32'b0;
                        sub_parse_action_valid_in <= 32'b1111_1111_1111_1111_1111_1111_1111_1111;

                        deparse_state <= WAIT_SUB;

                    end

            //wait one more cycle for RAM read
                    WAIT_ONE: begin
                        pkt_fifo_rd_en <= 1'b0;
                        //TODO push the inputs to sub_deparser
                        deparse_phv_reg_valid_in <= 32'b0;
                        sub_parse_action_valid_in <= 32'b1111_1111_1111_1111_1111_1111_1111_1111;


                        deparse_state <= WAIT_SUB;
                    end

                    WAIT_SUB: begin
                        pkt_fifo_rd_en <= 1'b0;
                        //TODO push the inputs to sub_deparser
                        deparse_phv_reg_valid_in <= 32'b0;
                        sub_parse_action_valid_in <= 32'b0;

                        deparse_state <= REFORM_HDR;
                    end

                    //this is the slot when we get RAM output
                    //the cycle when parse_action is enabled
                    REFORM_HDR: begin
                        pkt_fifo_rd_en <= 1'b0;
                        phv_fifo_rd_en <= 1'b1;

                        sub_parse_action_valid_in <= 32'b0;
                        //retrieve the data
                        if(parse_action[0][0]) begin
                                case(deparse_phv_select[0]) 
                            
                                    2'b01: deparse_tdata_stored_r[parse_action_ind[0]*8 +: 16] <= dp_val_BE[0][15:0];
                                    2'b10: deparse_tdata_stored_r[parse_action_ind[0]*8 +: 32] <= dp_val_BE[0][31:0];
                                    2'b11: deparse_tdata_stored_r[parse_action_ind[0]*8 +: 64] <= dp_val_BE[0][63:0];
                                endcase
                        end

                        if(parse_action[1][0]) begin
                                case(deparse_phv_select[1]) 
                            
                                    2'b01: deparse_tdata_stored_r[parse_action_ind[1]*8 +: 16] <= dp_val_BE[1][15:0];
                                    2'b10: deparse_tdata_stored_r[parse_action_ind[1]*8 +: 32] <= dp_val_BE[1][31:0];
                                    2'b11: deparse_tdata_stored_r[parse_action_ind[1]*8 +: 64] <= dp_val_BE[1][63:0];
                                endcase
                        end

                        if(parse_action[2][0]) begin
                                case(deparse_phv_select[2]) 
                            
                                    2'b01: deparse_tdata_stored_r[parse_action_ind[2]*8 +: 16] <= dp_val_BE[2][15:0];
                                    2'b10: deparse_tdata_stored_r[parse_action_ind[2]*8 +: 32] <= dp_val_BE[2][31:0];
                                    2'b11: deparse_tdata_stored_r[parse_action_ind[2]*8 +: 64] <= dp_val_BE[2][63:0];
                                endcase
                        end

                        if(parse_action[3][0]) begin
                                case(deparse_phv_select[3]) 
                            
                                    2'b01: deparse_tdata_stored_r[parse_action_ind[3]*8 +: 16] <= dp_val_BE[3][15:0];
                                    2'b10: deparse_tdata_stored_r[parse_action_ind[3]*8 +: 32] <= dp_val_BE[3][31:0];
                                    2'b11: deparse_tdata_stored_r[parse_action_ind[3]*8 +: 64] <= dp_val_BE[3][63:0];
                                endcase
                        end

                        if(parse_action[4][0]) begin
                                case(deparse_phv_select[4]) 
                            
                                    2'b01: deparse_tdata_stored_r[parse_action_ind[4]*8 +: 16] <= dp_val_BE[4][15:0];
                                    2'b10: deparse_tdata_stored_r[parse_action_ind[4]*8 +: 32] <= dp_val_BE[4][31:0];
                                    2'b11: deparse_tdata_stored_r[parse_action_ind[4]*8 +: 64] <= dp_val_BE[4][63:0];
                                endcase
                        end

                        if(parse_action[5][0]) begin
                                case(deparse_phv_select[5]) 
                            
                                    2'b01: deparse_tdata_stored_r[parse_action_ind[5]*8 +: 16] <= dp_val_BE[5][15:0];
                                    2'b10: deparse_tdata_stored_r[parse_action_ind[5]*8 +: 32] <= dp_val_BE[5][31:0];
                                    2'b11: deparse_tdata_stored_r[parse_action_ind[5]*8 +: 64] <= dp_val_BE[5][63:0];
                                endcase

                        end

                        if(parse_action[6][0]) begin
                                case(deparse_phv_select[6]) 
                            
                                    2'b01: deparse_tdata_stored_r[parse_action_ind[6]*8 +: 16] <= dp_val_BE[6][15:0];
                                    2'b10: deparse_tdata_stored_r[parse_action_ind[6]*8 +: 32] <= dp_val_BE[6][31:0];
                                    2'b11: deparse_tdata_stored_r[parse_action_ind[6]*8 +: 64] <= dp_val_BE[6][63:0];
                                endcase
                        end

                        if(parse_action[7][0]) begin
                                case(deparse_phv_select[7]) 
                            
                                    2'b01: deparse_tdata_stored_r[parse_action_ind[7]*8 +: 16] <= dp_val_BE[7][15:0];
                                    2'b10: deparse_tdata_stored_r[parse_action_ind[7]*8 +: 32] <= dp_val_BE[7][31:0];
                                    2'b11: deparse_tdata_stored_r[parse_action_ind[7]*8 +: 64] <= dp_val_BE[7][63:0];
                                endcase
                    
                        end

                        if(parse_action[8][0]) begin
                                case(deparse_phv_select[8]) 
                            
                                    2'b01: deparse_tdata_stored_r[parse_action_ind[8]*8 +: 16] <= dp_val_BE[8][15:0];
                                    2'b10: deparse_tdata_stored_r[parse_action_ind[8]*8 +: 32] <= dp_val_BE[8][31:0];
                                    2'b11: deparse_tdata_stored_r[parse_action_ind[8]*8 +: 64] <= dp_val_BE[8][63:0];
                                endcase
                        end

                        if(parse_action[9][0]) begin
                                case(deparse_phv_select[9]) 
                            
                                    2'b01: deparse_tdata_stored_r[parse_action_ind[9]*8 +: 16] <= dp_val_BE[9][15:0];
                                    2'b10: deparse_tdata_stored_r[parse_action_ind[9]*8 +: 32] <= dp_val_BE[9][31:0];
                                    2'b11: deparse_tdata_stored_r[parse_action_ind[9]*8 +: 64] <= dp_val_BE[9][63:0];
                                endcase
                        end
                        if(parse_action[10][0]) begin
                                case(deparse_phv_select[10]) 
                            
                                    2'b01: deparse_tdata_stored_r[parse_action_ind[10]*8 +: 16] <= dp_val_BE[10][15:0];
                                    2'b10: deparse_tdata_stored_r[parse_action_ind[10]*8 +: 32] <= dp_val_BE[10][31:0];
                                    2'b11: deparse_tdata_stored_r[parse_action_ind[10]*8 +: 64] <= dp_val_BE[10][63:0];
                                endcase
                        end
                        if(parse_action[11][0]) begin
                                case(deparse_phv_select[11]) 
                            
                                    2'b01: deparse_tdata_stored_r[parse_action_ind[11]*8 +: 16] <= dp_val_BE[11][15:0];
                                    2'b10: deparse_tdata_stored_r[parse_action_ind[11]*8 +: 32] <= dp_val_BE[11][31:0];
                                    2'b11: deparse_tdata_stored_r[parse_action_ind[11]*8 +: 64] <= dp_val_BE[11][63:0];
                                endcase
                        end
                        if(parse_action[12][0]) begin
                                case(deparse_phv_select[12]) 
                            
                                    2'b01: deparse_tdata_stored_r[parse_action_ind[12]*8 +: 16] <= dp_val_BE[12][15:0];
                                    2'b10: deparse_tdata_stored_r[parse_action_ind[12]*8 +: 32] <= dp_val_BE[12][31:0];
                                    2'b11: deparse_tdata_stored_r[parse_action_ind[12]*8 +: 64] <= dp_val_BE[12][63:0];
                                endcase
                        end
                        if(parse_action[13][0]) begin
                                case(deparse_phv_select[13]) 
                            
                                    2'b01: deparse_tdata_stored_r[parse_action_ind[13]*8 +: 16] <= dp_val_BE[13][15:0];
                                    2'b10: deparse_tdata_stored_r[parse_action_ind[13]*8 +: 32] <= dp_val_BE[13][31:0];
                                    2'b11: deparse_tdata_stored_r[parse_action_ind[13]*8 +: 64] <= dp_val_BE[13][63:0];
                                endcase
                        end
                        if(parse_action[14][0]) begin
                                case(deparse_phv_select[14]) 
                            
                                    2'b01: deparse_tdata_stored_r[parse_action_ind[14]*8 +: 16] <= dp_val_BE[14][15:0];
                                    2'b10: deparse_tdata_stored_r[parse_action_ind[14]*8 +: 32] <= dp_val_BE[14][31:0];
                                    2'b11: deparse_tdata_stored_r[parse_action_ind[14]*8 +: 64] <= dp_val_BE[14][63:0];
                                endcase
                        end
                        if(parse_action[15][0]) begin
                                case(deparse_phv_select[15]) 
                            
                                    2'b01: deparse_tdata_stored_r[parse_action_ind[15]*8 +: 16] <= dp_val_BE[15][15:0];
                                    2'b10: deparse_tdata_stored_r[parse_action_ind[15]*8 +: 32] <= dp_val_BE[15][31:0];
                                    2'b11: deparse_tdata_stored_r[parse_action_ind[15]*8 +: 64] <= dp_val_BE[15][63:0];
                                endcase
                        end
                        if(parse_action[16][0]) begin
                                case(deparse_phv_select[16]) 
                            
                                    2'b01: deparse_tdata_stored_r[parse_action_ind[16]*8 +: 16] <= dp_val_BE[16][15:0];
                                    2'b10: deparse_tdata_stored_r[parse_action_ind[16]*8 +: 32] <= dp_val_BE[16][31:0];
                                    2'b11: deparse_tdata_stored_r[parse_action_ind[16]*8 +: 64] <= dp_val_BE[16][63:0];
                                endcase
                        end
                        if(parse_action[17][0]) begin
                                case(deparse_phv_select[17]) 
                            
                                    2'b01: deparse_tdata_stored_r[parse_action_ind[17]*8 +: 16] <= dp_val_BE[17][15:0];
                                    2'b10: deparse_tdata_stored_r[parse_action_ind[17]*8 +: 32] <= dp_val_BE[17][31:0];
                                    2'b11: deparse_tdata_stored_r[parse_action_ind[17]*8 +: 64] <= dp_val_BE[17][63:0];
                                endcase
                        end
                        if(parse_action[18][0]) begin
                                case(deparse_phv_select[18]) 
                            
                                    2'b01: deparse_tdata_stored_r[parse_action_ind[18]*8 +: 16] <= dp_val_BE[18][15:0];
                                    2'b10: deparse_tdata_stored_r[parse_action_ind[18]*8 +: 32] <= dp_val_BE[18][31:0];
                                    2'b11: deparse_tdata_stored_r[parse_action_ind[18]*8 +: 64] <= dp_val_BE[18][63:0];
                                endcase
                        end
                        if(parse_action[19][0]) begin
                                case(deparse_phv_select[19]) 
                            
                                    2'b01: deparse_tdata_stored_r[parse_action_ind[19]*8 +: 16] <= dp_val_BE[19][15:0];
                                    2'b10: deparse_tdata_stored_r[parse_action_ind[19]*8 +: 32] <= dp_val_BE[19][31:0];
                                    2'b11: deparse_tdata_stored_r[parse_action_ind[19]*8 +: 64] <= dp_val_BE[19][63:0];
                                endcase
                        end
                        if(parse_action[20][0]) begin
                                case(deparse_phv_select[20]) 
                            
                                    2'b01: deparse_tdata_stored_r[parse_action_ind[20]*8 +: 16] <= dp_val_BE[20][15:0];
                                    2'b10: deparse_tdata_stored_r[parse_action_ind[20]*8 +: 32] <= dp_val_BE[20][31:0];
                                    2'b11: deparse_tdata_stored_r[parse_action_ind[20]*8 +: 64] <= dp_val_BE[20][63:0];
                                endcase
                        end
                        if(parse_action[21][0]) begin
                                case(deparse_phv_select[21]) 
                            
                                    2'b01: deparse_tdata_stored_r[parse_action_ind[21]*8 +: 16] <= dp_val_BE[21][15:0];
                                    2'b10: deparse_tdata_stored_r[parse_action_ind[21]*8 +: 32] <= dp_val_BE[21][31:0];
                                    2'b11: deparse_tdata_stored_r[parse_action_ind[21]*8 +: 64] <= dp_val_BE[21][63:0];
                                endcase
                        end
                        if(parse_action[22][0]) begin
                                case(deparse_phv_select[22]) 
                            
                                    2'b01: deparse_tdata_stored_r[parse_action_ind[22]*8 +: 16] <= dp_val_BE[22][15:0];
                                    2'b10: deparse_tdata_stored_r[parse_action_ind[22]*8 +: 32] <= dp_val_BE[22][31:0];
                                    2'b11: deparse_tdata_stored_r[parse_action_ind[22]*8 +: 64] <= dp_val_BE[22][63:0];
                                endcase
                        end
                        if(parse_action[23][0]) begin
                                case(deparse_phv_select[23]) 
                            
                                    2'b01: deparse_tdata_stored_r[parse_action_ind[23]*8 +: 16] <= dp_val_BE[23][15:0];
                                    2'b10: deparse_tdata_stored_r[parse_action_ind[23]*8 +: 32] <= dp_val_BE[23][31:0];
                                    2'b11: deparse_tdata_stored_r[parse_action_ind[23]*8 +: 64] <= dp_val_BE[23][63:0];
                                endcase
                        end
                        if(parse_action[24][0]) begin
                                case(deparse_phv_select[24]) 
                            
                                    2'b01: deparse_tdata_stored_r[parse_action_ind[24]*8 +: 16] <= dp_val_BE[24][15:0];
                                    2'b10: deparse_tdata_stored_r[parse_action_ind[24]*8 +: 32] <= dp_val_BE[24][31:0];
                                    2'b11: deparse_tdata_stored_r[parse_action_ind[24]*8 +: 64] <= dp_val_BE[24][63:0];
                                endcase
                        end
                        if(parse_action[25][0]) begin
                                case(deparse_phv_select[25]) 
                            
                                    2'b01: deparse_tdata_stored_r[parse_action_ind[25]*8 +: 16] <= dp_val_BE[25][15:0];
                                    2'b10: deparse_tdata_stored_r[parse_action_ind[25]*8 +: 32] <= dp_val_BE[25][31:0];
                                    2'b11: deparse_tdata_stored_r[parse_action_ind[25]*8 +: 64] <= dp_val_BE[25][63:0];
                                endcase
                        end
                        if(parse_action[26][0]) begin
                                case(deparse_phv_select[26]) 
                            
                                    2'b01: deparse_tdata_stored_r[parse_action_ind[26]*8 +: 16] <= dp_val_BE[26][15:0];
                                    2'b10: deparse_tdata_stored_r[parse_action_ind[26]*8 +: 32] <= dp_val_BE[26][31:0];
                                    2'b11: deparse_tdata_stored_r[parse_action_ind[26]*8 +: 64] <= dp_val_BE[26][63:0];
                                endcase
                        end
                        if(parse_action[27][0]) begin
                                case(deparse_phv_select[27]) 
                            
                                    2'b01: deparse_tdata_stored_r[parse_action_ind[27]*8 +: 16] <= dp_val_BE[27][15:0];
                                    2'b10: deparse_tdata_stored_r[parse_action_ind[27]*8 +: 32] <= dp_val_BE[27][31:0];
                                    2'b11: deparse_tdata_stored_r[parse_action_ind[27]*8 +: 64] <= dp_val_BE[27][63:0];
                                endcase
                        end
                        if(parse_action[28][0]) begin
                                case(deparse_phv_select[28]) 
                            
                                    2'b01: deparse_tdata_stored_r[parse_action_ind[28]*8 +: 16] <= dp_val_BE[28][15:0];
                                    2'b10: deparse_tdata_stored_r[parse_action_ind[28]*8 +: 32] <= dp_val_BE[28][31:0];
                                    2'b11: deparse_tdata_stored_r[parse_action_ind[28]*8 +: 64] <= dp_val_BE[28][63:0];
                                endcase
                        end
                        if(parse_action[29][0]) begin
                                case(deparse_phv_select[29]) 
                            
                                    2'b01: deparse_tdata_stored_r[parse_action_ind[29]*8 +: 16] <= dp_val_BE[29][15:0];
                                    2'b10: deparse_tdata_stored_r[parse_action_ind[29]*8 +: 32] <= dp_val_BE[29][31:0];
                                    2'b11: deparse_tdata_stored_r[parse_action_ind[29]*8 +: 64] <= dp_val_BE[29][63:0];
                                endcase
                        end
                        if(parse_action[30][0]) begin
                                case(deparse_phv_select[30]) 
                            
                                    2'b01: deparse_tdata_stored_r[parse_action_ind[30]*8 +: 16] <= dp_val_BE[30][15:0];
                                    2'b10: deparse_tdata_stored_r[parse_action_ind[30]*8 +: 32] <= dp_val_BE[30][31:0];
                                    2'b11: deparse_tdata_stored_r[parse_action_ind[30]*8 +: 64] <= dp_val_BE[30][63:0];
                                endcase
                        end
                        if(parse_action[31][0]) begin
                                case(deparse_phv_select[31]) 
                            
                                    2'b01: deparse_tdata_stored_r[parse_action_ind[31]*8 +: 16] <= dp_val_BE[31][15:0];
                                    2'b10: deparse_tdata_stored_r[parse_action_ind[31]*8 +: 32] <= dp_val_BE[31][31:0];
                                    2'b11: deparse_tdata_stored_r[parse_action_ind[31]*8 +: 64] <= dp_val_BE[31][63:0];
                                endcase
                        end

                        deparse_state <= FLUSH_PKT_0;
                    end

                    FLUSH_PKT_0: begin
                        phv_fifo_rd_en <= 1'b0;

                        depar_out_tdata <= deparse_tdata_stored_r[C_S_AXIS_DATA_WIDTH-1:0];
                        depar_out_tuser <= deparse_tuser_stored_r[C_S_AXIS_TUSER_WIDTH-1:0];
                        depar_out_tkeep <= deparse_tkeep_stored_r[C_S_AXIS_DATA_WIDTH/8-1:0];
			            depar_out_tlast <= deparse_tlast_stored_r[0];
			            depar_out_tvalid = 1'b1;

                        if(depar_out_tready) begin
                            if(deparse_tlast_stored_r[0]) begin
                                deparse_state <= IDLE_S;
                            end
                            else begin
                                deparse_state <= FLUSH_PKT_1;
                            end
                        end
                    end

                    FLUSH_PKT_1: begin
                        depar_out_tdata <= deparse_tdata_stored_r[(C_S_AXIS_DATA_WIDTH*1)+:C_S_AXIS_DATA_WIDTH];
                        depar_out_tuser <= deparse_tuser_stored_r[(C_S_AXIS_TUSER_WIDTH*1)+:C_S_AXIS_TUSER_WIDTH];
                        depar_out_tkeep <= deparse_tkeep_stored_r[(C_S_AXIS_DATA_WIDTH/8*1)+:(C_S_AXIS_DATA_WIDTH/8)];
			            depar_out_tlast <= deparse_tlast_stored_r[1];
			            depar_out_tvalid = 1'b1;

                        if(depar_out_tready) begin
                            if(deparse_tlast_stored_r[1]) begin
                                deparse_state <= IDLE_S;
                            end
                            else begin
                                deparse_state <= FLUSH_PKT_2;
                            end
                        end
                    end
                    FLUSH_PKT_2: begin
                        depar_out_tdata <= deparse_tdata_stored_r[(C_S_AXIS_DATA_WIDTH*2)+:C_S_AXIS_DATA_WIDTH];
                        depar_out_tuser <= deparse_tuser_stored_r[(C_S_AXIS_TUSER_WIDTH*2)+:C_S_AXIS_TUSER_WIDTH];
                        depar_out_tkeep <= deparse_tkeep_stored_r[(C_S_AXIS_DATA_WIDTH/8*2)+:(C_S_AXIS_DATA_WIDTH/8)];
			            depar_out_tlast <= deparse_tlast_stored_r[2];
			            depar_out_tvalid = 1'b1;

                        if(depar_out_tready) begin
                            if(deparse_tlast_stored_r[2]) begin
                                deparse_state <= IDLE_S;
                            end
                            else begin
                                deparse_state <= FLUSH_PKT_3;
                            end
                        end
                    end
                    FLUSH_PKT_3: begin
                        depar_out_tdata <= deparse_tdata_stored_r[(C_S_AXIS_DATA_WIDTH*3)+:C_S_AXIS_DATA_WIDTH];
                        depar_out_tuser <= deparse_tuser_stored_r[(C_S_AXIS_TUSER_WIDTH*3)+:C_S_AXIS_TUSER_WIDTH];
                        depar_out_tkeep <= deparse_tkeep_stored_r[(C_S_AXIS_DATA_WIDTH/8*3)+:(C_S_AXIS_DATA_WIDTH/8)];
			            depar_out_tlast <= deparse_tlast_stored_r[3];
			            depar_out_tvalid = 1'b1;

                        if(depar_out_tready) begin
                            if(deparse_tlast_stored_r[3]) begin
                                deparse_state <= IDLE_S;
                            end
                            else begin
                                pkt_fifo_rd_en <= 1'b1;
                                deparse_state <= FLUSH_PKT;
                            end
                        end
                    end

                    FLUSH_PKT: begin
                        depar_out_tdata <= pkt_fifo_tdata;
                        depar_out_tuser <= pkt_fifo_tuser;
                        depar_out_tkeep <= pkt_fifo_tkeep;
			            depar_out_tlast <= pkt_fifo_tlast;
			            depar_out_tvalid = 1;
                        if(!pkt_fifo_empty && depar_out_tready) begin

                            if(pkt_fifo_tlast) begin
                                deparse_state <= IDLE_S;
                            end
                            else begin
                                deparse_state <= FLUSH_PKT;
                            end
                        end

                        else begin
                            deparse_state <= IDLE_S;
                        end
                    end

                endcase
            end
        end
    end
    else begin
        always @(posedge clk or negedge aresetn) begin
            if(~aresetn) begin
                depar_out_tdata <= 0;
                depar_out_tkeep <= 0;
                depar_out_tuser <= 0;
                depar_out_tvalid <= 0;
                depar_out_tlast <= 0;

                pkt_fifo_rd_en <= 1'b0;
                phv_fifo_rd_en <= 1'b0;

                deparse_phv_reg_valid_in <= 32'b0;
                sub_parse_action_valid_in <= 32'b0;

                deparse_phv_stored_r <= 0;

                deparse_state <= IDLE_S;
            end
            else begin
                case(deparse_state)
                    IDLE_S: begin
                        //if there is work to do:
                        if(!phv_fifo_empty && !pkt_fifo_empty) begin
                            // deparse_phv_stored_r <= phv_fifo_out;

                            // deparse_tdata_stored_r[C_S_AXIS_DATA_WIDTH-1:0] <= pkt_fifo_tdata;
                            // deparse_tuser_stored_r[C_S_AXIS_TUSER_WIDTH-1:0] <= pkt_fifo_tuser;
                         // deparse_tkeep_stored_r[(C_S_AXIS_DATA_WIDTH/8)-1:0] <= pkt_fifo_tkeep;
                         // deparse_tlast_stored_r[0] <= pkt_fifo_tlast;

                            pkt_fifo_rd_en <= 1'b1;
                    
                            // if(pkt_fifo_tlast) begin
                            //     //TODO needs to wait for the RAM
                            //     deparse_state <= WAIT_ONE;
                         // end

                            // else begin
                            //     deparse_state <= BUF_HDR_0;
                            // end
                            deparse_state <= BUF_HDR_0;

                        end
                     else begin
                            // depar_out_tdata <= 0;
                            depar_out_tkeep <= 0;
                            depar_out_tuser <= 0;
                            depar_out_tvalid <= 0;
                            depar_out_tlast <= 0;

                            pkt_fifo_rd_en <= 1'b0;
                            phv_fifo_rd_en <= 1'b0;

                            deparse_phv_reg_valid_in <= 32'b0;
                            sub_parse_action_valid_in <= 32'b0;

                            deparse_state <= IDLE_S;
                        end
                    end
            
                    BUF_HDR_0: begin
                        deparse_phv_stored_r <= phv_fifo_out;
                        deparse_phv_reg_valid_in <= 32'b1111_1111_1111_1111_1111_1111_1111_1111;
                

                        deparse_tdata_stored_r[C_S_AXIS_DATA_WIDTH-1:0] <= pkt_fifo_tdata;
                        deparse_tuser_stored_r[C_S_AXIS_TUSER_WIDTH-1:0] <= metadata[127:0];
                        deparse_tkeep_stored_r[(C_S_AXIS_DATA_WIDTH/8)-1:0] <= pkt_fifo_tkeep;
                        deparse_tlast_stored_r[0] <= pkt_fifo_tlast;

                        pkt_fifo_rd_en <= 1'b1;
                    
                        if(pkt_fifo_tlast) begin
                            deparse_state <= WAIT_ONE;
                        end

                        else begin
                            deparse_state <= BUF_HDR_1;
                        end
                    end

                    BUF_HDR_1: begin
                        deparse_tdata_stored_r[2*C_S_AXIS_DATA_WIDTH-1:C_S_AXIS_DATA_WIDTH] <= pkt_fifo_tdata;
                        deparse_tuser_stored_r[2*C_S_AXIS_TUSER_WIDTH-1:C_S_AXIS_TUSER_WIDTH] <= metadata[255 -: 128];
                        deparse_tkeep_stored_r[2*(C_S_AXIS_DATA_WIDTH/8)-1:C_S_AXIS_DATA_WIDTH/8] <= pkt_fifo_tkeep;
                        deparse_tlast_stored_r[1] <= pkt_fifo_tlast;

                        pkt_fifo_rd_en <= 1'b1;
                        deparse_phv_reg_valid_in <= 32'b0;
                        sub_parse_action_valid_in <= 32'b0;
                
                        if(pkt_fifo_tlast) begin
                            deparse_state <= WAIT_ONE;
                        end
                        else begin
                            deparse_state <= BUF_HDR_2;
                        end

                    end
                    BUF_HDR_2: begin
                        deparse_tdata_stored_r[3*C_S_AXIS_DATA_WIDTH-1:2*C_S_AXIS_DATA_WIDTH] <= pkt_fifo_tdata;
                        deparse_tuser_stored_r[3*C_S_AXIS_TUSER_WIDTH-1:2*C_S_AXIS_TUSER_WIDTH] <= pkt_fifo_tuser;
                        deparse_tkeep_stored_r[3*(C_S_AXIS_DATA_WIDTH/8)-1:2*C_S_AXIS_DATA_WIDTH/8] <= pkt_fifo_tkeep;
                        deparse_tlast_stored_r[2] <= pkt_fifo_tlast;

                        pkt_fifo_rd_en <= 1'b1;
                        deparse_phv_reg_valid_in <= 32'b0;
                        sub_parse_action_valid_in <= 32'b0;
                
                        if(pkt_fifo_tlast) begin
                            deparse_state <= WAIT_ONE;
                        end
                        else begin
                            deparse_state <= BUF_HDR_3;
                        end

                    end
                    BUF_HDR_3: begin
                        deparse_tdata_stored_r[4*C_S_AXIS_DATA_WIDTH-1:3*C_S_AXIS_DATA_WIDTH] <= pkt_fifo_tdata;
                        deparse_tuser_stored_r[4*C_S_AXIS_TUSER_WIDTH-1:3*C_S_AXIS_TUSER_WIDTH] <= pkt_fifo_tuser;
                        deparse_tkeep_stored_r[4*(C_S_AXIS_DATA_WIDTH/8)-1:3*C_S_AXIS_DATA_WIDTH/8] <= pkt_fifo_tkeep;
                        deparse_tlast_stored_r[3] <= pkt_fifo_tlast;

                        pkt_fifo_rd_en <= 1'b1;
                        deparse_phv_reg_valid_in <= 32'b0;
                        sub_parse_action_valid_in <= 32'b0;
                
                        if(pkt_fifo_tlast) begin
                            deparse_state <= WAIT_ONE;
                        end
                        else begin
                            deparse_state <= BUF_HDR_4;
                        end

                    end
                    BUF_HDR_4: begin
                        deparse_tdata_stored_r[5*C_S_AXIS_DATA_WIDTH-1:4*C_S_AXIS_DATA_WIDTH] <= pkt_fifo_tdata;
                        deparse_tuser_stored_r[5*C_S_AXIS_TUSER_WIDTH-1:4*C_S_AXIS_TUSER_WIDTH] <= pkt_fifo_tuser;
                        deparse_tkeep_stored_r[5*(C_S_AXIS_DATA_WIDTH/8)-1:4*C_S_AXIS_DATA_WIDTH/8] <= pkt_fifo_tkeep;
                        deparse_tlast_stored_r[4] <= pkt_fifo_tlast;

                        pkt_fifo_rd_en <= 1'b1;
                        deparse_phv_reg_valid_in <= 32'b0;
                        sub_parse_action_valid_in <= 32'b0;
                
                        if(pkt_fifo_tlast) begin
                            deparse_state <= WAIT_ONE;
                        end
                        else begin
                            deparse_state <= BUF_HDR_5;
                        end

                    end
                    BUF_HDR_5: begin
                        deparse_tdata_stored_r[6*C_S_AXIS_DATA_WIDTH-1:5*C_S_AXIS_DATA_WIDTH] <= pkt_fifo_tdata;
                        deparse_tuser_stored_r[6*C_S_AXIS_TUSER_WIDTH-1:5*C_S_AXIS_TUSER_WIDTH] <= pkt_fifo_tuser;
                        deparse_tkeep_stored_r[6*(C_S_AXIS_DATA_WIDTH/8)-1:5*C_S_AXIS_DATA_WIDTH/8] <= pkt_fifo_tkeep;
                        deparse_tlast_stored_r[5] <= pkt_fifo_tlast;

                        pkt_fifo_rd_en <= 1'b1;
                        deparse_phv_reg_valid_in <= 32'b0;
                        sub_parse_action_valid_in <= 32'b0;
                
                        if(pkt_fifo_tlast) begin
                            deparse_state <= WAIT_ONE;
                        end
                        else begin
                            deparse_state <= BUF_HDR_6;
                        end

                    end
                    BUF_HDR_6: begin
                        deparse_tdata_stored_r[7*C_S_AXIS_DATA_WIDTH-1:6*C_S_AXIS_DATA_WIDTH] <= pkt_fifo_tdata;
                        deparse_tuser_stored_r[7*C_S_AXIS_TUSER_WIDTH-1:6*C_S_AXIS_TUSER_WIDTH] <= pkt_fifo_tuser;
                        deparse_tkeep_stored_r[7*(C_S_AXIS_DATA_WIDTH/8)-1:6*C_S_AXIS_DATA_WIDTH/8] <= pkt_fifo_tkeep;
                        deparse_tlast_stored_r[6] <= pkt_fifo_tlast;

                        pkt_fifo_rd_en <= 1'b1;
                        deparse_phv_reg_valid_in <= 32'b0;
                        sub_parse_action_valid_in <= 32'b0;
                
                        if(pkt_fifo_tlast) begin
                            deparse_state <= WAIT_ONE;
                        end
                        else begin
                            deparse_state <= BUF_HDR_7;
                        end

                    end
                    BUF_HDR_7: begin
                        deparse_tdata_stored_r[8*C_S_AXIS_DATA_WIDTH-1:7*C_S_AXIS_DATA_WIDTH] <= pkt_fifo_tdata;
                        deparse_tuser_stored_r[8*C_S_AXIS_TUSER_WIDTH-1:7*C_S_AXIS_TUSER_WIDTH] <= pkt_fifo_tuser;
                        deparse_tkeep_stored_r[8*(C_S_AXIS_DATA_WIDTH/8)-1:7*C_S_AXIS_DATA_WIDTH/8] <= pkt_fifo_tkeep;
                        deparse_tlast_stored_r[7] <= pkt_fifo_tlast;

                        pkt_fifo_rd_en <= 1'b0;
                        //TODO push the inputs to sub_deparser
                        deparse_phv_reg_valid_in <= 32'b0;
                        sub_parse_action_valid_in <= 32'b1111_1111_1111_1111_1111_1111_1111_1111;

                        deparse_state <= WAIT_SUB;

                    end

            //wait one more cycle for RAM read
                    WAIT_ONE: begin
                        pkt_fifo_rd_en <= 1'b0;
                        //TODO push the inputs to sub_deparser
                        deparse_phv_reg_valid_in <= 32'b0;
                        sub_parse_action_valid_in <= 32'b1111_1111_1111_1111_1111_1111_1111_1111;


                        deparse_state <= WAIT_SUB;
                    end

                    WAIT_SUB: begin
                        pkt_fifo_rd_en <= 1'b0;
                        //TODO push the inputs to sub_deparser
                        deparse_phv_reg_valid_in <= 32'b0;
                        sub_parse_action_valid_in <= 32'b0;

                        deparse_state <= REFORM_HDR;
                    end

                    //this is the slot when we get RAM output
                    //the cycle when parse_action is enabled
                    REFORM_HDR: begin
                        pkt_fifo_rd_en <= 1'b0;
                        phv_fifo_rd_en <= 1'b1;

                        sub_parse_action_valid_in <= 32'b0;
                        //retrieve the data
                        if(parse_action[0][0]) begin
                                case(deparse_phv_select[0]) 
                            
                                    2'b01: deparse_tdata_stored_r[parse_action_ind[0]*8 +: 16] <= dp_val_BE[0][15:0];
                                    2'b10: deparse_tdata_stored_r[parse_action_ind[0]*8 +: 32] <= dp_val_BE[0][31:0];
                                    2'b11: deparse_tdata_stored_r[parse_action_ind[0]*8 +: 64] <= dp_val_BE[0][63:0];
                                endcase
                        end

                        if(parse_action[1][0]) begin
                                case(deparse_phv_select[1]) 
                            
                                    2'b01: deparse_tdata_stored_r[parse_action_ind[1]*8 +: 16] <= dp_val_BE[1][15:0];
                                    2'b10: deparse_tdata_stored_r[parse_action_ind[1]*8 +: 32] <= dp_val_BE[1][31:0];
                                    2'b11: deparse_tdata_stored_r[parse_action_ind[1]*8 +: 64] <= dp_val_BE[1][63:0];
                                endcase
                        end

                        if(parse_action[2][0]) begin
                                case(deparse_phv_select[2]) 
                            
                                    2'b01: deparse_tdata_stored_r[parse_action_ind[2]*8 +: 16] <= dp_val_BE[2][15:0];
                                    2'b10: deparse_tdata_stored_r[parse_action_ind[2]*8 +: 32] <= dp_val_BE[2][31:0];
                                    2'b11: deparse_tdata_stored_r[parse_action_ind[2]*8 +: 64] <= dp_val_BE[2][63:0];
                                endcase
                        end

                        if(parse_action[3][0]) begin
                                case(deparse_phv_select[3]) 
                            
                                    2'b01: deparse_tdata_stored_r[parse_action_ind[3]*8 +: 16] <= dp_val_BE[3][15:0];
                                    2'b10: deparse_tdata_stored_r[parse_action_ind[3]*8 +: 32] <= dp_val_BE[3][31:0];
                                    2'b11: deparse_tdata_stored_r[parse_action_ind[3]*8 +: 64] <= dp_val_BE[3][63:0];
                                endcase
                        end

                        if(parse_action[4][0]) begin
                                case(deparse_phv_select[4]) 
                            
                                    2'b01: deparse_tdata_stored_r[parse_action_ind[4]*8 +: 16] <= dp_val_BE[4][15:0];
                                    2'b10: deparse_tdata_stored_r[parse_action_ind[4]*8 +: 32] <= dp_val_BE[4][31:0];
                                    2'b11: deparse_tdata_stored_r[parse_action_ind[4]*8 +: 64] <= dp_val_BE[4][63:0];
                                endcase
                        end

                        if(parse_action[5][0]) begin
                                case(deparse_phv_select[5]) 
                            
                                    2'b01: deparse_tdata_stored_r[parse_action_ind[5]*8 +: 16] <= dp_val_BE[5][15:0];
                                    2'b10: deparse_tdata_stored_r[parse_action_ind[5]*8 +: 32] <= dp_val_BE[5][31:0];
                                    2'b11: deparse_tdata_stored_r[parse_action_ind[5]*8 +: 64] <= dp_val_BE[5][63:0];
                                endcase

                        end

                        if(parse_action[6][0]) begin
                                case(deparse_phv_select[6]) 
                            
                                    2'b01: deparse_tdata_stored_r[parse_action_ind[6]*8 +: 16] <= dp_val_BE[6][15:0];
                                    2'b10: deparse_tdata_stored_r[parse_action_ind[6]*8 +: 32] <= dp_val_BE[6][31:0];
                                    2'b11: deparse_tdata_stored_r[parse_action_ind[6]*8 +: 64] <= dp_val_BE[6][63:0];
                                endcase
                        end

                        if(parse_action[7][0]) begin
                                case(deparse_phv_select[7]) 
                            
                                    2'b01: deparse_tdata_stored_r[parse_action_ind[7]*8 +: 16] <= dp_val_BE[7][15:0];
                                    2'b10: deparse_tdata_stored_r[parse_action_ind[7]*8 +: 32] <= dp_val_BE[7][31:0];
                                    2'b11: deparse_tdata_stored_r[parse_action_ind[7]*8 +: 64] <= dp_val_BE[7][63:0];
                                endcase
                    
                        end

                        if(parse_action[8][0]) begin
                                case(deparse_phv_select[8]) 
                            
                                    2'b01: deparse_tdata_stored_r[parse_action_ind[8]*8 +: 16] <= dp_val_BE[8][15:0];
                                    2'b10: deparse_tdata_stored_r[parse_action_ind[8]*8 +: 32] <= dp_val_BE[8][31:0];
                                    2'b11: deparse_tdata_stored_r[parse_action_ind[8]*8 +: 64] <= dp_val_BE[8][63:0];
                                endcase
                        end

                        if(parse_action[9][0]) begin
                                case(deparse_phv_select[9]) 
                            
                                    2'b01: deparse_tdata_stored_r[parse_action_ind[9]*8 +: 16] <= dp_val_BE[9][15:0];
                                    2'b10: deparse_tdata_stored_r[parse_action_ind[9]*8 +: 32] <= dp_val_BE[9][31:0];
                                    2'b11: deparse_tdata_stored_r[parse_action_ind[9]*8 +: 64] <= dp_val_BE[9][63:0];
                                endcase
                        end
                        if(parse_action[10][0]) begin
                                case(deparse_phv_select[10]) 
                            
                                    2'b01: deparse_tdata_stored_r[parse_action_ind[10]*8 +: 16] <= dp_val_BE[10][15:0];
                                    2'b10: deparse_tdata_stored_r[parse_action_ind[10]*8 +: 32] <= dp_val_BE[10][31:0];
                                    2'b11: deparse_tdata_stored_r[parse_action_ind[10]*8 +: 64] <= dp_val_BE[10][63:0];
                                endcase
                        end
                        if(parse_action[11][0]) begin
                                case(deparse_phv_select[11]) 
                            
                                    2'b01: deparse_tdata_stored_r[parse_action_ind[11]*8 +: 16] <= dp_val_BE[11][15:0];
                                    2'b10: deparse_tdata_stored_r[parse_action_ind[11]*8 +: 32] <= dp_val_BE[11][31:0];
                                    2'b11: deparse_tdata_stored_r[parse_action_ind[11]*8 +: 64] <= dp_val_BE[11][63:0];
                                endcase
                        end
                        if(parse_action[12][0]) begin
                                case(deparse_phv_select[12]) 
                            
                                    2'b01: deparse_tdata_stored_r[parse_action_ind[12]*8 +: 16] <= dp_val_BE[12][15:0];
                                    2'b10: deparse_tdata_stored_r[parse_action_ind[12]*8 +: 32] <= dp_val_BE[12][31:0];
                                    2'b11: deparse_tdata_stored_r[parse_action_ind[12]*8 +: 64] <= dp_val_BE[12][63:0];
                                endcase
                        end
                        if(parse_action[13][0]) begin
                                case(deparse_phv_select[13]) 
                            
                                    2'b01: deparse_tdata_stored_r[parse_action_ind[13]*8 +: 16] <= dp_val_BE[13][15:0];
                                    2'b10: deparse_tdata_stored_r[parse_action_ind[13]*8 +: 32] <= dp_val_BE[13][31:0];
                                    2'b11: deparse_tdata_stored_r[parse_action_ind[13]*8 +: 64] <= dp_val_BE[13][63:0];
                                endcase
                        end
                        if(parse_action[14][0]) begin
                                case(deparse_phv_select[14]) 
                            
                                    2'b01: deparse_tdata_stored_r[parse_action_ind[14]*8 +: 16] <= dp_val_BE[14][15:0];
                                    2'b10: deparse_tdata_stored_r[parse_action_ind[14]*8 +: 32] <= dp_val_BE[14][31:0];
                                    2'b11: deparse_tdata_stored_r[parse_action_ind[14]*8 +: 64] <= dp_val_BE[14][63:0];
                                endcase
                        end
                        if(parse_action[15][0]) begin
                                case(deparse_phv_select[15]) 
                            
                                    2'b01: deparse_tdata_stored_r[parse_action_ind[15]*8 +: 16] <= dp_val_BE[15][15:0];
                                    2'b10: deparse_tdata_stored_r[parse_action_ind[15]*8 +: 32] <= dp_val_BE[15][31:0];
                                    2'b11: deparse_tdata_stored_r[parse_action_ind[15]*8 +: 64] <= dp_val_BE[15][63:0];
                                endcase
                        end
                        if(parse_action[16][0]) begin
                                case(deparse_phv_select[16]) 
                            
                                    2'b01: deparse_tdata_stored_r[parse_action_ind[16]*8 +: 16] <= dp_val_BE[16][15:0];
                                    2'b10: deparse_tdata_stored_r[parse_action_ind[16]*8 +: 32] <= dp_val_BE[16][31:0];
                                    2'b11: deparse_tdata_stored_r[parse_action_ind[16]*8 +: 64] <= dp_val_BE[16][63:0];
                                endcase
                        end
                        if(parse_action[17][0]) begin
                                case(deparse_phv_select[17]) 
                            
                                    2'b01: deparse_tdata_stored_r[parse_action_ind[17]*8 +: 16] <= dp_val_BE[17][15:0];
                                    2'b10: deparse_tdata_stored_r[parse_action_ind[17]*8 +: 32] <= dp_val_BE[17][31:0];
                                    2'b11: deparse_tdata_stored_r[parse_action_ind[17]*8 +: 64] <= dp_val_BE[17][63:0];
                                endcase
                        end
                        if(parse_action[18][0]) begin
                                case(deparse_phv_select[18]) 
                            
                                    2'b01: deparse_tdata_stored_r[parse_action_ind[18]*8 +: 16] <= dp_val_BE[18][15:0];
                                    2'b10: deparse_tdata_stored_r[parse_action_ind[18]*8 +: 32] <= dp_val_BE[18][31:0];
                                    2'b11: deparse_tdata_stored_r[parse_action_ind[18]*8 +: 64] <= dp_val_BE[18][63:0];
                                endcase
                        end
                        if(parse_action[19][0]) begin
                                case(deparse_phv_select[19]) 
                            
                                    2'b01: deparse_tdata_stored_r[parse_action_ind[19]*8 +: 16] <= dp_val_BE[19][15:0];
                                    2'b10: deparse_tdata_stored_r[parse_action_ind[19]*8 +: 32] <= dp_val_BE[19][31:0];
                                    2'b11: deparse_tdata_stored_r[parse_action_ind[19]*8 +: 64] <= dp_val_BE[19][63:0];
                                endcase
                        end
                        if(parse_action[20][0]) begin
                                case(deparse_phv_select[20]) 
                            
                                    2'b01: deparse_tdata_stored_r[parse_action_ind[20]*8 +: 16] <= dp_val_BE[20][15:0];
                                    2'b10: deparse_tdata_stored_r[parse_action_ind[20]*8 +: 32] <= dp_val_BE[20][31:0];
                                    2'b11: deparse_tdata_stored_r[parse_action_ind[20]*8 +: 64] <= dp_val_BE[20][63:0];
                                endcase
                        end
                        if(parse_action[21][0]) begin
                                case(deparse_phv_select[21]) 
                            
                                    2'b01: deparse_tdata_stored_r[parse_action_ind[21]*8 +: 16] <= dp_val_BE[21][15:0];
                                    2'b10: deparse_tdata_stored_r[parse_action_ind[21]*8 +: 32] <= dp_val_BE[21][31:0];
                                    2'b11: deparse_tdata_stored_r[parse_action_ind[21]*8 +: 64] <= dp_val_BE[21][63:0];
                                endcase
                        end
                        if(parse_action[22][0]) begin
                                case(deparse_phv_select[22]) 
                            
                                    2'b01: deparse_tdata_stored_r[parse_action_ind[22]*8 +: 16] <= dp_val_BE[22][15:0];
                                    2'b10: deparse_tdata_stored_r[parse_action_ind[22]*8 +: 32] <= dp_val_BE[22][31:0];
                                    2'b11: deparse_tdata_stored_r[parse_action_ind[22]*8 +: 64] <= dp_val_BE[22][63:0];
                                endcase
                        end
                        if(parse_action[23][0]) begin
                                case(deparse_phv_select[23]) 
                            
                                    2'b01: deparse_tdata_stored_r[parse_action_ind[23]*8 +: 16] <= dp_val_BE[23][15:0];
                                    2'b10: deparse_tdata_stored_r[parse_action_ind[23]*8 +: 32] <= dp_val_BE[23][31:0];
                                    2'b11: deparse_tdata_stored_r[parse_action_ind[23]*8 +: 64] <= dp_val_BE[23][63:0];
                                endcase
                        end
                        if(parse_action[24][0]) begin
                                case(deparse_phv_select[24]) 
                            
                                    2'b01: deparse_tdata_stored_r[parse_action_ind[24]*8 +: 16] <= dp_val_BE[24][15:0];
                                    2'b10: deparse_tdata_stored_r[parse_action_ind[24]*8 +: 32] <= dp_val_BE[24][31:0];
                                    2'b11: deparse_tdata_stored_r[parse_action_ind[24]*8 +: 64] <= dp_val_BE[24][63:0];
                                endcase
                        end
                        if(parse_action[25][0]) begin
                                case(deparse_phv_select[25]) 
                            
                                    2'b01: deparse_tdata_stored_r[parse_action_ind[25]*8 +: 16] <= dp_val_BE[25][15:0];
                                    2'b10: deparse_tdata_stored_r[parse_action_ind[25]*8 +: 32] <= dp_val_BE[25][31:0];
                                    2'b11: deparse_tdata_stored_r[parse_action_ind[25]*8 +: 64] <= dp_val_BE[25][63:0];
                                endcase
                        end
                        if(parse_action[26][0]) begin
                                case(deparse_phv_select[26]) 
                            
                                    2'b01: deparse_tdata_stored_r[parse_action_ind[26]*8 +: 16] <= dp_val_BE[26][15:0];
                                    2'b10: deparse_tdata_stored_r[parse_action_ind[26]*8 +: 32] <= dp_val_BE[26][31:0];
                                    2'b11: deparse_tdata_stored_r[parse_action_ind[26]*8 +: 64] <= dp_val_BE[26][63:0];
                                endcase
                        end
                        if(parse_action[27][0]) begin
                                case(deparse_phv_select[27]) 
                            
                                    2'b01: deparse_tdata_stored_r[parse_action_ind[27]*8 +: 16] <= dp_val_BE[27][15:0];
                                    2'b10: deparse_tdata_stored_r[parse_action_ind[27]*8 +: 32] <= dp_val_BE[27][31:0];
                                    2'b11: deparse_tdata_stored_r[parse_action_ind[27]*8 +: 64] <= dp_val_BE[27][63:0];
                                endcase
                        end
                        if(parse_action[28][0]) begin
                                case(deparse_phv_select[28]) 
                            
                                    2'b01: deparse_tdata_stored_r[parse_action_ind[28]*8 +: 16] <= dp_val_BE[28][15:0];
                                    2'b10: deparse_tdata_stored_r[parse_action_ind[28]*8 +: 32] <= dp_val_BE[28][31:0];
                                    2'b11: deparse_tdata_stored_r[parse_action_ind[28]*8 +: 64] <= dp_val_BE[28][63:0];
                                endcase
                        end
                        if(parse_action[29][0]) begin
                                case(deparse_phv_select[29]) 
                            
                                    2'b01: deparse_tdata_stored_r[parse_action_ind[29]*8 +: 16] <= dp_val_BE[29][15:0];
                                    2'b10: deparse_tdata_stored_r[parse_action_ind[29]*8 +: 32] <= dp_val_BE[29][31:0];
                                    2'b11: deparse_tdata_stored_r[parse_action_ind[29]*8 +: 64] <= dp_val_BE[29][63:0];
                                endcase
                        end
                        if(parse_action[30][0]) begin
                                case(deparse_phv_select[30]) 
                            
                                    2'b01: deparse_tdata_stored_r[parse_action_ind[30]*8 +: 16] <= dp_val_BE[30][15:0];
                                    2'b10: deparse_tdata_stored_r[parse_action_ind[30]*8 +: 32] <= dp_val_BE[30][31:0];
                                    2'b11: deparse_tdata_stored_r[parse_action_ind[30]*8 +: 64] <= dp_val_BE[30][63:0];
                                endcase
                        end
                        if(parse_action[31][0]) begin
                                case(deparse_phv_select[31]) 
                            
                                    2'b01: deparse_tdata_stored_r[parse_action_ind[31]*8 +: 16] <= dp_val_BE[31][15:0];
                                    2'b10: deparse_tdata_stored_r[parse_action_ind[31]*8 +: 32] <= dp_val_BE[31][31:0];
                                    2'b11: deparse_tdata_stored_r[parse_action_ind[31]*8 +: 64] <= dp_val_BE[31][63:0];
                                endcase
                        end

                        deparse_state <= FLUSH_PKT_0;
                    end

                    FLUSH_PKT_0: begin
                        phv_fifo_rd_en <= 1'b0;

                        depar_out_tdata <= deparse_tdata_stored_r[C_S_AXIS_DATA_WIDTH-1:0];
                        depar_out_tuser <= deparse_tuser_stored_r[C_S_AXIS_TUSER_WIDTH-1:0];
                        depar_out_tkeep <= deparse_tkeep_stored_r[C_S_AXIS_DATA_WIDTH/8-1:0];
			            depar_out_tlast <= deparse_tlast_stored_r[0];
			            depar_out_tvalid = 1'b1;

                        if(depar_out_tready) begin
                            if(deparse_tlast_stored_r[0]) begin
                                deparse_state <= IDLE_S;
                            end
                            else begin
                                deparse_state <= FLUSH_PKT_1;
                            end
                        end
                    end

                    FLUSH_PKT_1: begin
                        depar_out_tdata <= deparse_tdata_stored_r[(C_S_AXIS_DATA_WIDTH*1)+:C_S_AXIS_DATA_WIDTH];
                        depar_out_tuser <= deparse_tuser_stored_r[(C_S_AXIS_TUSER_WIDTH*1)+:C_S_AXIS_TUSER_WIDTH];
                        depar_out_tkeep <= deparse_tkeep_stored_r[(C_S_AXIS_DATA_WIDTH/8*1)+:(C_S_AXIS_DATA_WIDTH/8)];
			            depar_out_tlast <= deparse_tlast_stored_r[1];
			            depar_out_tvalid = 1'b1;

                        if(depar_out_tready) begin
                            if(deparse_tlast_stored_r[1]) begin
                                deparse_state <= IDLE_S;
                            end
                            else begin
                                deparse_state <= FLUSH_PKT_2;
                            end
                        end
                    end
                    FLUSH_PKT_2: begin
                        depar_out_tdata <= deparse_tdata_stored_r[(C_S_AXIS_DATA_WIDTH*2)+:C_S_AXIS_DATA_WIDTH];
                        depar_out_tuser <= deparse_tuser_stored_r[(C_S_AXIS_TUSER_WIDTH*2)+:C_S_AXIS_TUSER_WIDTH];
                        depar_out_tkeep <= deparse_tkeep_stored_r[(C_S_AXIS_DATA_WIDTH/8*2)+:(C_S_AXIS_DATA_WIDTH/8)];
			            depar_out_tlast <= deparse_tlast_stored_r[2];
			            depar_out_tvalid = 1'b1;

                        if(depar_out_tready) begin
                            if(deparse_tlast_stored_r[2]) begin
                                deparse_state <= IDLE_S;
                            end
                            else begin
                                deparse_state <= FLUSH_PKT_3;
                            end
                        end
                    end
                    FLUSH_PKT_3: begin
                        depar_out_tdata <= deparse_tdata_stored_r[(C_S_AXIS_DATA_WIDTH*3)+:C_S_AXIS_DATA_WIDTH];
                        depar_out_tuser <= deparse_tuser_stored_r[(C_S_AXIS_TUSER_WIDTH*3)+:C_S_AXIS_TUSER_WIDTH];
                        depar_out_tkeep <= deparse_tkeep_stored_r[(C_S_AXIS_DATA_WIDTH/8*3)+:(C_S_AXIS_DATA_WIDTH/8)];
			            depar_out_tlast <= deparse_tlast_stored_r[3];
			            depar_out_tvalid = 1'b1;

                        if(depar_out_tready) begin
                            if(deparse_tlast_stored_r[3]) begin
                                deparse_state <= IDLE_S;
                            end
                            else begin
                                deparse_state <= FLUSH_PKT_4;
                            end
                        end
                    end
                    FLUSH_PKT_4: begin
                        depar_out_tdata <= deparse_tdata_stored_r[(C_S_AXIS_DATA_WIDTH*4)+:C_S_AXIS_DATA_WIDTH];
                        depar_out_tuser <= deparse_tuser_stored_r[(C_S_AXIS_TUSER_WIDTH*4)+:C_S_AXIS_TUSER_WIDTH];
                        depar_out_tkeep <= deparse_tkeep_stored_r[(C_S_AXIS_DATA_WIDTH/8*4)+:(C_S_AXIS_DATA_WIDTH/8)];
			            depar_out_tlast <= deparse_tlast_stored_r[4];
			            depar_out_tvalid = 1'b1;

                        if(depar_out_tready) begin
                            if(deparse_tlast_stored_r[4]) begin
                                deparse_state <= IDLE_S;
                            end
                            else begin
                                deparse_state <= FLUSH_PKT_5;
                            end
                        end
                    end
                    FLUSH_PKT_5: begin
                        depar_out_tdata <= deparse_tdata_stored_r[(C_S_AXIS_DATA_WIDTH*5)+:C_S_AXIS_DATA_WIDTH];
                        depar_out_tuser <= deparse_tuser_stored_r[(C_S_AXIS_TUSER_WIDTH*5)+:C_S_AXIS_TUSER_WIDTH];
                        depar_out_tkeep <= deparse_tkeep_stored_r[(C_S_AXIS_DATA_WIDTH/8*5)+:(C_S_AXIS_DATA_WIDTH/8)];
			            depar_out_tlast <= deparse_tlast_stored_r[5];
			            depar_out_tvalid = 1'b1;

                        if(depar_out_tready) begin
                            if(deparse_tlast_stored_r[5]) begin
                                deparse_state <= IDLE_S;
                            end
                            else begin
                                deparse_state <= FLUSH_PKT_6;
                            end
                        end
                    end
                    FLUSH_PKT_6: begin
                        depar_out_tdata <= deparse_tdata_stored_r[(C_S_AXIS_DATA_WIDTH*6)+:C_S_AXIS_DATA_WIDTH];
                        depar_out_tuser <= deparse_tuser_stored_r[(C_S_AXIS_TUSER_WIDTH*6)+:C_S_AXIS_TUSER_WIDTH];
                        depar_out_tkeep <= deparse_tkeep_stored_r[(C_S_AXIS_DATA_WIDTH/8*6)+:(C_S_AXIS_DATA_WIDTH/8)];
			            depar_out_tlast <= deparse_tlast_stored_r[6];
			            depar_out_tvalid = 1'b1;

                        if(depar_out_tready) begin
                            if(deparse_tlast_stored_r[6]) begin
                                deparse_state <= IDLE_S;
                            end
                            else begin
                                deparse_state <= FLUSH_PKT_7;
                            end
                        end
                    end
                    FLUSH_PKT_7: begin
                        depar_out_tdata <= deparse_tdata_stored_r[(C_S_AXIS_DATA_WIDTH*7)+:C_S_AXIS_DATA_WIDTH];
                        depar_out_tuser <= deparse_tuser_stored_r[(C_S_AXIS_TUSER_WIDTH*7)+:C_S_AXIS_TUSER_WIDTH];
                        depar_out_tkeep <= deparse_tkeep_stored_r[(C_S_AXIS_DATA_WIDTH/8*7)+:(C_S_AXIS_DATA_WIDTH/8)];
			            depar_out_tlast <= deparse_tlast_stored_r[7];
			            depar_out_tvalid = 1'b1;

                        if(depar_out_tready) begin
                            if(deparse_tlast_stored_r[7]) begin
                                deparse_state <= IDLE_S;
                            end
                            else begin
                                pkt_fifo_rd_en <= 1'b1;
                                deparse_state <= FLUSH_PKT;
                            end
                        end
                    end

                    FLUSH_PKT: begin
                        depar_out_tdata <= pkt_fifo_tdata;
                        depar_out_tuser <= pkt_fifo_tuser;
                        depar_out_tkeep <= pkt_fifo_tkeep;
			            depar_out_tlast <= pkt_fifo_tlast;
			            depar_out_tvalid = 1;
                        if(!pkt_fifo_empty && depar_out_tready) begin

                            if(pkt_fifo_tlast) begin
                                deparse_state <= IDLE_S;
                            end
                            else begin
                                deparse_state <= FLUSH_PKT;
                            end
                        end

                        else begin
                            deparse_state <= IDLE_S;
                        end
                    end

                endcase
            end
        end
    end
endgenerate




generate 
    for(index=0; index<32; index = index+1)
        begin: sub_op
            sub_deparser #(
            	//in corundum with 100g ports, data width is 512b
            	.C_S_AXIS_DATA_WIDTH(C_S_AXIS_DATA_WIDTH),
            	.C_S_AXIS_TUSER_WIDTH(),
            	.C_PKT_VEC_WIDTH(),
                .C_PARSE_ACTION_LEN(C_PARSE_ACTION_LEN)
            )sub_deparser
            (
            	.clk(clk),
            	.aresetn(aresetn),
                .deparse_phv_reg_in(deparse_phv_stored_r[1827:356]),
                .deparse_phv_reg_valid_in(deparse_phv_reg_valid_in[index]),
                .parse_action(parse_action[index]),
                .parse_action_valid_in(sub_parse_action_valid_in[index]),
                .deparse_phv_reg_out(dp_val_BE[index]),
                .deparse_phv_select(deparse_phv_select[index]),
                .valid_out(valid_out[index])
            );
        end
endgenerate




/****control path for 512b*****/
wire [7:0]          mod_id; //module ID
wire [15:0]         control_flag; //dst udp port num
reg  [7:0]          c_index; //table index(addr)
reg                 c_wr_en; //enable table write(wen)
reg  [611:0]        entry_reg;

reg [C_S_AXIS_DATA_WIDTH-1:0]       c_m_axis_tdata;
reg [C_S_AXIS_TUSER_WIDTH-1:0]      c_m_axis_tuser;
reg [C_S_AXIS_DATA_WIDTH/8-1:0]     c_m_axis_tkeep;
reg                                 c_m_axis_tvalid;
reg                                 c_m_axis_tlast;

reg  [2:0]          c_state;

/****for 256b exclusively*****/
reg [C_S_AXIS_DATA_WIDTH-1:0]       c_m_axis_tdata_r;
reg [C_S_AXIS_TUSER_WIDTH-1:0]      c_m_axis_tuser_r;
reg [C_S_AXIS_DATA_WIDTH/8-1:0]     c_m_axis_tkeep_r;
reg                                 c_m_axis_tvalid_r;
reg                                 c_m_axis_tlast_r;
reg                                 contious_flag;

localparam IDLE_C       = 3'd1,
           PARSE_C      = 3'd2,
           WRITE_WAIT   = 3'd3,
           WRITE_C      = 3'd4,
           WRITE_WAIT_1 = 3'd5,
           WRITE_WAIT_2 = 3'd6,
           FLUSH_REST_C = 3'd7;


generate
    if(C_S_AXIS_DATA_WIDTH == 512) begin
        assign mod_id = c_s_axis_tdata[368+:8];
        assign control_flag = c_s_axis_tdata[335:320];

        //LE to BE switching
        wire[C_S_AXIS_DATA_WIDTH-1:0] c_s_axis_tdata_swapped;
        assign c_s_axis_tdata_swapped = {	c_s_axis_tdata[0+:8],
									        c_s_axis_tdata[8+:8],
									        c_s_axis_tdata[16+:8],
									        c_s_axis_tdata[24+:8],
									        c_s_axis_tdata[32+:8],
									        c_s_axis_tdata[40+:8],
									        c_s_axis_tdata[48+:8],
									        c_s_axis_tdata[56+:8],
									        c_s_axis_tdata[64+:8],
									        c_s_axis_tdata[72+:8],
									        c_s_axis_tdata[80+:8],
									        c_s_axis_tdata[88+:8],
									        c_s_axis_tdata[96+:8],
									        c_s_axis_tdata[104+:8],
									        c_s_axis_tdata[112+:8],
									        c_s_axis_tdata[120+:8],
									        c_s_axis_tdata[128+:8],
									        c_s_axis_tdata[136+:8],
									        c_s_axis_tdata[144+:8],
									        c_s_axis_tdata[152+:8],
									        c_s_axis_tdata[160+:8],
									        c_s_axis_tdata[168+:8],
									        c_s_axis_tdata[176+:8],
									        c_s_axis_tdata[184+:8],
									        c_s_axis_tdata[192+:8],
									        c_s_axis_tdata[200+:8],
									        c_s_axis_tdata[208+:8],
									        c_s_axis_tdata[216+:8],
									        c_s_axis_tdata[224+:8],
									        c_s_axis_tdata[232+:8],
									        c_s_axis_tdata[240+:8],
									        c_s_axis_tdata[248+:8],
                                            c_s_axis_tdata[256+:8],
                                            c_s_axis_tdata[264+:8],
                                            c_s_axis_tdata[272+:8],
                                            c_s_axis_tdata[280+:8],
                                            c_s_axis_tdata[288+:8],
                                            c_s_axis_tdata[296+:8],
                                            c_s_axis_tdata[304+:8],
                                            c_s_axis_tdata[312+:8],
                                            c_s_axis_tdata[320+:8],
                                            c_s_axis_tdata[328+:8],
                                            c_s_axis_tdata[336+:8],
                                            c_s_axis_tdata[344+:8],
                                            c_s_axis_tdata[352+:8],
                                            c_s_axis_tdata[360+:8],
                                            c_s_axis_tdata[368+:8],
                                            c_s_axis_tdata[376+:8],
                                            c_s_axis_tdata[384+:8],
                                            c_s_axis_tdata[392+:8],
                                            c_s_axis_tdata[400+:8],
                                            c_s_axis_tdata[408+:8],
                                            c_s_axis_tdata[416+:8],
                                            c_s_axis_tdata[424+:8],
                                            c_s_axis_tdata[432+:8],
                                            c_s_axis_tdata[440+:8],
                                            c_s_axis_tdata[448+:8],
                                            c_s_axis_tdata[456+:8],
                                            c_s_axis_tdata[464+:8],
                                            c_s_axis_tdata[472+:8],
                                            c_s_axis_tdata[480+:8],
                                            c_s_axis_tdata[488+:8],
                                            c_s_axis_tdata[496+:8],
                                            c_s_axis_tdata[504+:8]
                                        };

        always @(posedge clk or negedge aresetn) begin
            if(~aresetn) begin
                c_wr_en <= 1'b0;
                c_index <= 4'b0;

                c_m_axis_tdata <= 0;
                c_m_axis_tuser <= 0;
                c_m_axis_tkeep <= 0;
                c_m_axis_tvalid <= 0;
                c_m_axis_tlast <= 0;
                entry_reg <= 0;
                
                contious_flag <= 0;

                c_state <= IDLE_C;
            end
            else begin
                case(c_state)
                    IDLE_C: begin
                        if(c_s_axis_tvalid && mod_id[2:0] == DEPARSER_ID && control_flag == 16'hf2f1)begin
                            c_wr_en <= 1'b0;
                            c_index <= c_s_axis_tdata[384+:8];

                            c_m_axis_tdata <= 0;
                            c_m_axis_tuser <= 0;
                            c_m_axis_tkeep <= 0;
                            c_m_axis_tvalid <= 0;
                            c_m_axis_tlast <= 0;
                            
                            contious_flag <= 0;
                            c_state <= WRITE_WAIT;

                        end
                        else begin
                            c_wr_en <= 1'b0;
                            c_index <= 4'b0; 

                            c_m_axis_tdata <= c_s_axis_tdata;
                            c_m_axis_tuser <= c_s_axis_tuser;
                            c_m_axis_tkeep <= c_s_axis_tkeep;
                            c_m_axis_tvalid <= c_s_axis_tvalid;
                            c_m_axis_tlast <= c_s_axis_tlast;
                            
                            contious_flag <= contious_flag;

                            c_state <= IDLE_C;
                        end
                    end
                    WRITE_WAIT:begin
                        if(~c_s_axis_tlast && c_s_axis_tvalid)begin
                            if(contious_flag)
                                c_index <= c_index+4'b1;
                            else c_index <= c_index;
                            entry_reg[611 -: 512] <= c_s_axis_tdata;
                            c_wr_en <= 0;
                            c_state <= WRITE_C;
                        end
                        else begin
                            entry_reg <= 612'b0;
                            c_state <= IDLE_C;
                        end
                    end
                    //support full table flush
                    WRITE_C: begin
                        if(c_s_axis_tvalid) begin
                            entry_reg[99 -:100] <= c_s_axis_tdata[511 -:100];
                            c_wr_en <= 1'b1;
                            c_index <= c_index;
                            if(c_s_axis_tlast) c_state = IDLE_C;
                            else begin
                                c_state <= WRITE_WAIT;
                                contious_flag <= 1;
                            end
                        end
                        else begin
                            entry_reg <= 612'b0;
                            c_state <= IDLE_C;
                        end
                    end
                endcase

            end
        end



        // =============================================================== //
        // parse_act_ram_ip #(
        // 	.C_INIT_FILE_NAME	("./parse_act_ram_init_file.mif"),
        // 	.C_LOAD_INIT_FILE	(1)
        // )
        deparse_act_ram_ip
        deparse_act_ram
        (
	       // write port
	       .clka		(clk),
	       .addra		(c_index[3:0]),
	       .dina		(entry_reg),    /////////////////////////////////////////////260�� 32*16+100
	       .ena		(1'b1),
	       .wea		(c_wr_en),

	       //
	       .clkb		(clk),
	       .addrb		(vlan_id[7:4]), // TODO: note that we may change due to little or big endian
	       .doutb		(bram_out),
	       .enb		(1'b1) // always set to 1
        );
    end
    
    //NOTE: data width is 256b
    else begin
        assign mod_id = c_s_axis_tdata[112+:8];
        assign control_flag = c_s_axis_tdata[64+:16];

        //LE to BE switching
        wire[C_S_AXIS_DATA_WIDTH-1:0] c_s_axis_tdata_swapped;
        assign c_s_axis_tdata_swapped = {	c_s_axis_tdata[0+:8],
									        c_s_axis_tdata[8+:8],
									        c_s_axis_tdata[16+:8],
									        c_s_axis_tdata[24+:8],
									        c_s_axis_tdata[32+:8],
									        c_s_axis_tdata[40+:8],
									        c_s_axis_tdata[48+:8],
									        c_s_axis_tdata[56+:8],
									        c_s_axis_tdata[64+:8],
									        c_s_axis_tdata[72+:8],
									        c_s_axis_tdata[80+:8],
									        c_s_axis_tdata[88+:8],
									        c_s_axis_tdata[96+:8],
									        c_s_axis_tdata[104+:8],
									        c_s_axis_tdata[112+:8],
									        c_s_axis_tdata[120+:8],
									        c_s_axis_tdata[128+:8],
									        c_s_axis_tdata[136+:8],
									        c_s_axis_tdata[144+:8],
									        c_s_axis_tdata[152+:8],
									        c_s_axis_tdata[160+:8],
									        c_s_axis_tdata[168+:8],
									        c_s_axis_tdata[176+:8],
									        c_s_axis_tdata[184+:8],
									        c_s_axis_tdata[192+:8],
									        c_s_axis_tdata[200+:8],
									        c_s_axis_tdata[208+:8],
									        c_s_axis_tdata[216+:8],
									        c_s_axis_tdata[224+:8],
									        c_s_axis_tdata[232+:8],
									        c_s_axis_tdata[240+:8],
									        c_s_axis_tdata[248+:8]          
                                        };

        always @(posedge clk or negedge aresetn) begin
            if(~aresetn) begin
                c_wr_en <= 1'b0;
                c_index <= 8'b0;

                c_m_axis_tdata <= 0;
                c_m_axis_tuser <= 0;
                c_m_axis_tkeep <= 0;
                c_m_axis_tvalid <= 0;
                c_m_axis_tlast <= 0;
                entry_reg <= 0;
                
                contious_flag <= 0;

                c_state <= IDLE_C;
            end
            else begin
                case(c_state)
                    IDLE_C: begin
                        c_m_axis_tdata <= c_m_axis_tdata_r;
                        c_m_axis_tuser <= c_m_axis_tuser_r;
                        c_m_axis_tkeep <= c_m_axis_tkeep_r;
                        c_m_axis_tvalid <= c_m_axis_tvalid_r;
                        c_m_axis_tlast <= c_m_axis_tlast_r;
                        if(c_s_axis_tvalid) begin
                            c_m_axis_tdata_r <= c_s_axis_tdata;
                            c_m_axis_tuser_r <= c_s_axis_tuser;
                            c_m_axis_tkeep_r <= c_s_axis_tkeep;
                            c_m_axis_tvalid_r <= c_s_axis_tvalid;
                            c_m_axis_tlast_r <= c_s_axis_tlast;

                            c_state <= PARSE_C;
                        end
                        else begin
                            c_wr_en <= 1'b0;
                            c_index <= 8'b0; 
                            c_m_axis_tvalid_r <= 1'b0;
                            c_m_axis_tlast_r <= 1'b0;
                            contious_flag <= 1'b0;
                            c_state <= IDLE_C;
                        end
                    end
                    PARSE_C: begin
                        if(mod_id[2:0] == DEPARSER_ID && control_flag == 16'hf2f1 && c_s_axis_tvalid) begin
                            c_m_axis_tdata <= 0;
                            c_m_axis_tuser <= 0;
                            c_m_axis_tkeep <= 0;
                            c_m_axis_tvalid <= 0;
                            c_m_axis_tlast <= 0;
                            contious_flag <= 0;
                            if (c_s_axis_tvalid)begin
                                c_index <= c_s_axis_tdata[128 +: 8];
                                c_wr_en <= 1'b0;
                                c_state = WRITE_WAIT_1;
                            end
                            else begin
                                c_state <= PARSE_C;
                            end
                        end
                        //if I don't know if I should send it, then I should hold it.
                        else if(!c_s_axis_tvalid) begin
                            c_m_axis_tdata <= c_m_axis_tdata;
                            c_m_axis_tuser <= c_m_axis_tuser;
                            c_m_axis_tkeep <= c_m_axis_tkeep;
                            c_m_axis_tvalid <= 0;
                            c_m_axis_tlast <= 0;
                            contious_flag <= 0;

                            c_m_axis_tdata_r <= c_m_axis_tdata_r;
                            c_m_axis_tuser_r <= c_m_axis_tuser_r;
                            c_m_axis_tkeep_r <= c_m_axis_tkeep_r;
                            c_m_axis_tvalid_r <= c_m_axis_tvalid_r;
                            c_m_axis_tlast_r <= c_m_axis_tlast_r;
                        end

                        else begin
                            c_m_axis_tdata <= c_m_axis_tdata_r;
                            c_m_axis_tuser <= c_m_axis_tuser_r;
                            c_m_axis_tkeep <= c_m_axis_tkeep_r;
                            c_m_axis_tvalid <= c_m_axis_tvalid_r;
                            c_m_axis_tlast <= c_m_axis_tlast_r;

                            c_m_axis_tdata_r <= c_s_axis_tdata;
                            c_m_axis_tuser_r <= c_s_axis_tuser;
                            c_m_axis_tkeep_r <= c_s_axis_tkeep;
                            c_m_axis_tvalid_r <= c_s_axis_tvalid;
                            c_m_axis_tlast_r <= c_s_axis_tlast;
                            
                            if(c_s_axis_tvalid && c_s_axis_tlast) c_state <= IDLE_C;
							else c_state <= FLUSH_REST_C;
                        end
                    end
					FLUSH_REST_C: begin
						c_m_axis_tdata <= c_m_axis_tdata_r;
						c_m_axis_tuser <= c_m_axis_tuser_r;
						c_m_axis_tkeep <= c_m_axis_tkeep_r; 
						c_m_axis_tvalid <= c_m_axis_tvalid_r; 
						c_m_axis_tlast <= c_m_axis_tlast_r;

                       	c_m_axis_tdata_r <= c_s_axis_tdata;
                       	c_m_axis_tuser_r <= c_s_axis_tuser;
                       	c_m_axis_tkeep_r <= c_s_axis_tkeep;
                       	c_m_axis_tvalid_r <= c_s_axis_tvalid;
                       	c_m_axis_tlast_r <= c_s_axis_tlast;
                            
                        if(c_s_axis_tvalid && c_s_axis_tlast) 
							c_state <= IDLE_C;
						else  c_state <= FLUSH_REST_C;
					end
                    WRITE_WAIT_1:begin
                        if(~c_s_axis_tlast && c_s_axis_tvalid)begin
                            entry_reg[611 -: 256] <= c_s_axis_tdata;
                            c_wr_en <= 0;
                            if(contious_flag) c_index <= c_index + 1; 
                            else c_index <= c_index;
                            c_state <= WRITE_WAIT_2;
                        end
                        else begin
                            entry_reg <= 612'b0;
                            c_state <= IDLE_C;
                        end
                    end
                    WRITE_WAIT_2:begin
                        if(~c_s_axis_tlast && c_s_axis_tvalid)begin
                            entry_reg[355 -: 256] <= c_s_axis_tdata;
                            c_wr_en <= 0;
                            c_index <= c_index;
                            c_state <= WRITE_C;
                            contious_flag <= 0;
                        end
                        else begin
                            entry_reg <= 612'b0;
                            c_state <= IDLE_C;
                        end
                    end
                    WRITE_C:begin
                        if(c_s_axis_tvalid) begin
                            entry_reg[99 -: 100] <= c_s_axis_tdata[255 -:100];
                            c_wr_en <= 1'b1;
                            c_index <= c_index;
                            if(c_s_axis_tlast) c_state = IDLE_C;
                            else begin
                                contious_flag <= 1'b1;
                                c_state <= WRITE_WAIT_1;
                            end
                        end
                        else begin //
                            c_state <= WRITE_WAIT_1;
                        end
                    end
                endcase

            end
        end



        // =============================================================== //
        // parse_act_ram_ip #(
        // 	.C_INIT_FILE_NAME	("./parse_act_ram_init_file.mif"),
        // 	.C_LOAD_INIT_FILE	(1)
        // )
        deparse_act_ram_ip
        deparse_act_ram
        (
	       // write port
	       .clka		(clk),
	       .addra		(c_index[3:0]),
	       .dina		(entry_reg),    /////////////////////////////////////////////260�� 32*16+100
	       .ena		(1'b1),
	       .wea		(c_wr_en),

	       //
	       .clkb		(clk),
	       .addrb		(vlan_id[7:4]), // TODO: note that we may change due to little or big endian
	       .doutb		(bram_out),
	       .enb		(1'b1) // always set to 1
        );
    end


endgenerate
endmodule