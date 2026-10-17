`timescale 1ns / 1ps

`define SWAP_BYTE_ORDER(idx) \
	assign val_8B_BE[idx] = {	val_8B[idx][0+:8], \
									val_8B[idx][8+:8], \
									val_8B[idx][16+:8], \
									val_8B[idx][24+:8], \
									val_8B[idx][32+:8], \
									val_8B[idx][40+:8], \
                                    val_8B[idx][48+:8], \
                                    val_8B[idx][56+:8]}; \
	assign val_4B_BE[idx] = {	val_4B[idx][0+:8], \
									val_4B[idx][8+:8], \
									val_4B[idx][16+:8], \
									val_4B[idx][24+:8]}; \
	assign val_2B_BE[idx] = {	val_2B[idx][0+:8], \
									val_2B[idx][8+:8]}; \

module parser #(
	parameter C_S_AXIS_DATA_WIDTH = 256,
	parameter C_S_AXIS_TUSER_WIDTH = 128,
	parameter PKT_HDR_LEN = 8*16*8+4*12*8+2*4*8+20*5+256, // check with the doc
	parameter PARSE_ACT_RAM_WIDTH = 167,
    parameter PARSER_ID = 0
    )(
    input									axis_clk,
	input									aresetn,

	// input slvae axi stream
	input [C_S_AXIS_DATA_WIDTH-1:0]			s_axis_tdata,
	input [C_S_AXIS_TUSER_WIDTH-1:0]		s_axis_tuser,
	input [C_S_AXIS_DATA_WIDTH/8-1:0]		s_axis_tkeep,
	input									s_axis_tvalid,
	input									s_axis_tlast,

	// output
	output   								phv_valid_out,
	output      [PKT_HDR_LEN-1:0]			phv_out,

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

// intermediate variables declared here

//phv_out signals before putting out.
reg phv_valid_out_reg;

assign phv_valid_out = phv_valid_out_reg;


//Parse Action RAM
wire [419:0] bram_out;

wire [15:0]  parse_action [0:19];
reg  [19:0]  condi_action [0:4];
reg  [19:0]  condi_action_d[0:4];

reg [63:0] val_8B [0:15];
reg [31:0] val_4B [0:15];
reg [15:0] val_2B [0:15];

wire [63:0] val_8B_BE [0:15];
wire [31:0] val_4B_BE [0:15];
wire [15:0] val_2B_BE [0:15];

//BE LE switching
`SWAP_BYTE_ORDER(0)
`SWAP_BYTE_ORDER(1)
`SWAP_BYTE_ORDER(2)
`SWAP_BYTE_ORDER(3)
`SWAP_BYTE_ORDER(4)
`SWAP_BYTE_ORDER(5)
`SWAP_BYTE_ORDER(6)
`SWAP_BYTE_ORDER(7)
`SWAP_BYTE_ORDER(8)
`SWAP_BYTE_ORDER(9)
`SWAP_BYTE_ORDER(10)
`SWAP_BYTE_ORDER(11)
`SWAP_BYTE_ORDER(12)
`SWAP_BYTE_ORDER(13)
`SWAP_BYTE_ORDER(14)
`SWAP_BYTE_ORDER(15)

integer idx;
localparam SEG_NUM = 1024/C_S_AXIS_DATA_WIDTH;
//reg [C_S_AXIS_DATA_WIDTH-1:0]  pkt_seg [0:(1024/C_S_AXIS_DATA_WIDTH-1)];

// reg [SEG_NUM-1:0] pkt_seg_cnt;
reg [3:0]    pkt_seg_cnt; //cnt is 4'd6 if its invalid
reg          s_axis_tvalid_before;
reg          phv_ready;



//8x8B+8x4B+4x2B+100b+256b
reg [1023:0] pkt_hdr_field;
reg [255:0] metadata;


/**
divide and conquar (below)
*/

genvar gen_i;

localparam C_PARSE_ACTION_LEN = 13;

//NOTE: the number of container is switched to 12.
reg [19:0]                    pkt_hdr_field_valid;
reg [19:0]                    parse_action_valid_in;

wire [63:0]                  val_out[0:19];
wire [1:0]                   val_out_select[0:19];
wire [3:0]                   val_seq_select[0:19];
wire [19:0]                   val_valid_out;


//TODO: need 8x8B, 8x4B, 4x2B, 100b, 256b

//get vlan_id from 1st segment.
reg [11:0] vlan_id;

//assign parse_action[19] = bram_out[419 -: 16];
//assign parse_action[18] = bram_out[403 -: 16];
//assign parse_action[17] = bram_out[387 -: 16];
//assign parse_action[16] = bram_out[371 -: 16];
//assign parse_action[15] = bram_out[355 -: 16];
//assign parse_action[14] = bram_out[339 -: 16];
//assign parse_action[13] = bram_out[323 -: 16];
//assign parse_action[12] = bram_out[307 -: 16];
//assign parse_action[11] = bram_out[291 -: 16];
//assign parse_action[10] = bram_out[275 -: 16];
//assign parse_action[9]  = bram_out[259 -: 16];
//assign parse_action[8]  = bram_out[243 -: 16];
//assign parse_action[7]  = bram_out[227 -: 16];
//assign parse_action[6]  = bram_out[211 -: 16];
//assign parse_action[5]  = bram_out[195 -: 16];
//assign parse_action[4]  = bram_out[179 -: 16];
//assign parse_action[3]  = bram_out[163 -: 16];
//assign parse_action[2]  = bram_out[147 -: 16];
//assign parse_action[1]  = bram_out[131 -: 16];
//assign parse_action[0]  = bram_out[115 -: 16];

assign parse_action[19] = bram_out[100+:16]; //ǰ32����ָ��ȡ��λ��
assign parse_action[18] = bram_out[116+:16];
assign parse_action[17] = bram_out[132+:16];
assign parse_action[16] = bram_out[148+:16];
assign parse_action[15] = bram_out[164+:16];
assign parse_action[14] = bram_out[180+:16];
assign parse_action[13] = bram_out[196+:16];
assign parse_action[12] = bram_out[212+:16];
assign parse_action[11] = bram_out[228+:16];
assign parse_action[10] = bram_out[244+:16];
assign parse_action[9] = bram_out[260+:16];
assign parse_action[8] = bram_out[276+:16];
assign parse_action[7] = bram_out[292+:16];
assign parse_action[6] = bram_out[308+:16];
assign parse_action[5] = bram_out[324+:16];
assign parse_action[4] = bram_out[340+:16];
assign parse_action[3] = bram_out[356+:16];
assign parse_action[2] = bram_out[372+:16];
assign parse_action[1] = bram_out[388+:16];
assign parse_action[0] = bram_out[404+:16];


always @(posedge axis_clk) begin
    condi_action_d[0] <= bram_out[0+:20];
    condi_action_d[1] <= bram_out[20+:20];
    condi_action_d[2] <= bram_out[40+:20];
    condi_action_d[3] <= bram_out[60+:20];
    condi_action_d[4] <= bram_out[80+:20];
    condi_action[0] <= condi_action_d[0];
    condi_action[1] <= condi_action_d[1];
    condi_action[2] <= condi_action_d[2];
    condi_action[3] <= condi_action_d[3];
    condi_action[4] <= condi_action_d[4];
end


/**** here we parse everything (8 containers & 5 conditions) ****/

always @(posedge axis_clk) begin
    s_axis_tvalid_before <= s_axis_tvalid;
end

//a counter to determine if this value needs to be recorded
always @(posedge axis_clk) begin
    //1st segment
    if(s_axis_tvalid && ~s_axis_tvalid_before) begin
        pkt_seg_cnt <= 4'd0;
    end
    //left but not 1st segment (within SEG_NUM)
    else if(s_axis_tvalid) begin
        pkt_seg_cnt <= pkt_seg_cnt + 4'b1;
    end
    else begin
        pkt_seg_cnt <= 0; //pkt_seg_cnt is set to 0 two cycles after the last segment (tlast)
    end
end

//record the pkts into pkt_hdr_field
always @(posedge axis_clk or negedge aresetn) begin
    if(~aresetn) begin
        pkt_hdr_field <= 1024'b0;
        metadata <= 256'b0;
        phv_ready <= 1'b0;
    end
    else begin
        //the 1st segment of the packet
        if(s_axis_tvalid && ~s_axis_tvalid_before) begin
            phv_ready <= 1'b0;
            vlan_id <= s_axis_tdata[129+:12];
            pkt_hdr_field <= {768'b0, s_axis_tdata};
            metadata <= {128'b0, s_axis_tuser};  
        end
        else if(pkt_seg_cnt < SEG_NUM-1 && s_axis_tvalid) begin
            pkt_hdr_field[(pkt_seg_cnt+4'b1)*C_S_AXIS_DATA_WIDTH +: C_S_AXIS_DATA_WIDTH] <= s_axis_tdata;   
            //here we can start extract values from PHV
            if(pkt_seg_cnt == SEG_NUM-2 || (s_axis_tlast && s_axis_tvalid)) begin
                phv_ready <= 1'b1;
            end
            else begin
                phv_ready <= phv_ready;
            end
            if(pkt_seg_cnt == 1) begin
                //metadata[255-:128] <= s_axis_tuser;
                metadata[255-:128] <={s_axis_tuser[127:13],vlan_id,s_axis_tuser[0]} ;
            end
            else begin
                metadata <= metadata;
            end
        end
        else begin
            pkt_hdr_field <= pkt_hdr_field;
        end
    end
end


//here we extract the 1024b from packet (depend on data_width)
reg [2:0] parse_state;

localparam IDLE_S    = 3'd0,
           WAIT_S    = 3'd1,
           PARSE1_S  = 3'd2,
           PARSE2_S  = 3'd3;

//fire up the FSM
always @(posedge axis_clk or negedge aresetn) begin
    if(~aresetn) begin
        phv_valid_out_reg <= 1'b0;
        //phv_out <= 1024'b0;
        for(idx=0; idx<20; idx = idx+1) begin
            parse_action_valid_in[idx] <= 1'b0;
            pkt_hdr_field_valid[idx] <= 1'b0;
        end
        parse_state <= IDLE_S;
    end
    else begin
        case(parse_state)
            IDLE_S: begin
                if(s_axis_tvalid && ~s_axis_tvalid_before) begin
                    parse_state <= WAIT_S;
                end
                phv_valid_out_reg <= 1'b0;
                for(idx = 0; idx < 8; idx = idx+1) begin 
                    val_2B[idx] <= 16'b0;
                    val_4B[idx] <= 32'b0;
                    val_8B[idx] <= 64'b0;
                end

                for(idx=0; idx<20; idx = idx+1) begin
                    parse_action_valid_in[idx] <= 1'b0;
                    pkt_hdr_field_valid[idx] <= 1'b0;
                end
            end

            WAIT_S: begin
                
                if(phv_ready) begin
                    //packet header is ready prepared, fire up sub_parser
                    parse_state <= PARSE1_S;
                end
                else begin
                    parse_state <= WAIT_S;
                end
            end 

            PARSE1_S: begin
                for(idx=0; idx<20; idx = idx+1) begin
                    parse_action_valid_in[idx] <= 1'b1;
                    pkt_hdr_field_valid[idx] <= 1'b1;
                end
                    if(val_valid_out)
                        parse_state <= PARSE2_S;
                    else
                        parse_state <= PARSE1_S;
            end

            PARSE2_S: begin
                case(val_out_select[0])
                    2'b01: val_2B[val_seq_select[0]] <= val_out[0][15:0];
                    2'b10: val_4B[val_seq_select[0]] <= val_out[0][31:0];
                    2'b11: val_8B[val_seq_select[0]] <= val_out[0][63:0];
                endcase
                case(val_out_select[1])
                    2'b01: val_2B[val_seq_select[1]] <= val_out[1][15:0];
                    2'b10: val_4B[val_seq_select[1]] <= val_out[1][31:0];
                    2'b11: val_8B[val_seq_select[1]] <= val_out[1][63:0];
                endcase
                case(val_out_select[2])
                    2'b01: val_2B[val_seq_select[2]] <= val_out[2][15:0];
                    2'b10: val_4B[val_seq_select[2]] <= val_out[2][31:0];
                    2'b11: val_8B[val_seq_select[2]] <= val_out[2][63:0];
                endcase
                case(val_out_select[3])
                    2'b01: val_2B[val_seq_select[3]] <= val_out[3][15:0];
                    2'b10: val_4B[val_seq_select[3]] <= val_out[3][31:0];
                    2'b11: val_8B[val_seq_select[3]] <= val_out[3][63:0];
                endcase
                case(val_out_select[4])
                    2'b01: val_2B[val_seq_select[4]] <= val_out[4][15:0];
                    2'b10: val_4B[val_seq_select[4]] <= val_out[4][31:0];
                    2'b11: val_8B[val_seq_select[4]] <= val_out[4][63:0];
                endcase
                case(val_out_select[5])
                    2'b01: val_2B[val_seq_select[5]] <= val_out[5][15:0];
                    2'b10: val_4B[val_seq_select[5]] <= val_out[5][31:0];
                    2'b11: val_8B[val_seq_select[5]] <= val_out[5][63:0];
                endcase
                case(val_out_select[6])
                    2'b01: val_2B[val_seq_select[6]] <= val_out[6][15:0];
                    2'b10: val_4B[val_seq_select[6]] <= val_out[6][31:0];
                    2'b11: val_8B[val_seq_select[6]] <= val_out[6][63:0];
                endcase
                case(val_out_select[7])
                    2'b01: val_2B[val_seq_select[7]] <= val_out[7][15:0];
                    2'b10: val_4B[val_seq_select[7]] <= val_out[7][31:0];
                    2'b11: val_8B[val_seq_select[7]] <= val_out[7][63:0];
                endcase
                case(val_out_select[8])
                    2'b01: val_2B[val_seq_select[8]] <= val_out[8][15:0];
                    2'b10: val_4B[val_seq_select[8]] <= val_out[8][31:0];
                    2'b11: val_8B[val_seq_select[8]] <= val_out[8][63:0];
                endcase
                case(val_out_select[9])
                    2'b01: val_2B[val_seq_select[9]] <= val_out[9][15:0];
                    2'b10: val_4B[val_seq_select[9]] <= val_out[9][31:0];
                    2'b11: val_8B[val_seq_select[9]] <= val_out[9][63:0];
                endcase
                case(val_out_select[10])
                    2'b01: val_2B[val_seq_select[10]] <= val_out[10][15:0];
                    2'b10: val_4B[val_seq_select[10]] <= val_out[10][31:0];
                    2'b11: val_8B[val_seq_select[10]] <= val_out[10][63:0];
                endcase
                case(val_out_select[11])
                    2'b01: val_2B[val_seq_select[11]] <= val_out[11][15:0];
                    2'b10: val_4B[val_seq_select[11]] <= val_out[11][31:0];
                    2'b11: val_8B[val_seq_select[11]] <= val_out[11][63:0];
                endcase
                case(val_out_select[12])
                    2'b01: val_2B[val_seq_select[12]] <= val_out[12][15:0];
                    2'b10: val_4B[val_seq_select[12]] <= val_out[12][31:0];
                    2'b11: val_8B[val_seq_select[12]] <= val_out[12][63:0];
                endcase
                case(val_out_select[13])
                    2'b01: val_2B[val_seq_select[13]] <= val_out[13][15:0];
                    2'b10: val_4B[val_seq_select[13]] <= val_out[13][31:0];
                    2'b11: val_8B[val_seq_select[13]] <= val_out[13][63:0];
                endcase
                case(val_out_select[14])
                    2'b01: val_2B[val_seq_select[14]] <= val_out[14][15:0];
                    2'b10: val_4B[val_seq_select[14]] <= val_out[14][31:0];
                    2'b11: val_8B[val_seq_select[14]] <= val_out[14][63:0];
                endcase
                case(val_out_select[15])
                    2'b01: val_2B[val_seq_select[15]] <= val_out[15][15:0];
                    2'b10: val_4B[val_seq_select[15]] <= val_out[15][31:0];//提取，val_4B[0]
                    2'b11: val_8B[val_seq_select[15]] <= val_out[15][63:0];
                endcase
                case(val_out_select[16])
                    2'b01: val_2B[val_seq_select[16]] <= val_out[16][15:0];
                    2'b10: val_4B[val_seq_select[16]] <= val_out[16][31:0];
                    2'b11: val_8B[val_seq_select[16]] <= val_out[16][63:0];
                endcase
                case(val_out_select[17])
                    2'b01: val_2B[val_seq_select[17]] <= val_out[17][15:0];
                    2'b10: val_4B[val_seq_select[17]] <= val_out[17][31:0];
                    2'b11: val_8B[val_seq_select[17]] <= val_out[17][63:0];
                endcase
                case(val_out_select[18])
                    2'b01: val_2B[val_seq_select[18]] <= val_out[18][15:0];
                    2'b10: val_4B[val_seq_select[18]] <= val_out[18][31:0];
                    2'b11: val_8B[val_seq_select[18]] <= val_out[18][63:0];
                endcase
                case(val_out_select[19])
                    2'b01: val_2B[val_seq_select[19]] <= val_out[19][15:0];
                    2'b10: val_4B[val_seq_select[19]] <= val_out[19][31:0];
                    2'b11: val_8B[val_seq_select[19]] <= val_out[19][63:0];
                endcase
                phv_valid_out_reg <= 1'b1;
                parse_state <= IDLE_S;
            end

        endcase
    end
end


//assign phv_out = {val_8B_BE[15], val_8B_BE[14], val_8B_BE[13], val_8B_BE[12], val_8B_BE[11], val_8B_BE[10], val_8B_BE[9], val_8B_BE[8],val_8B_BE[7], val_8B_BE[6], val_8B_BE[5], val_8B_BE[4], val_8B_BE[3], val_8B_BE[2], val_8B_BE[1], val_8B_BE[0],
//				 val_4B_BE[15], val_4B_BE[14], val_4B_BE[13], val_4B_BE[12], val_4B_BE[11], val_4B_BE[10], val_4B_BE[9], val_4B_BE[8],val_4B_BE[7], val_4B_BE[6], val_4B_BE[5], val_4B_BE[4], val_4B_BE[3], val_4B_BE[2], val_4B_BE[1], val_4B_BE[0],
//				 val_2B_BE[3], val_2B_BE[2], val_2B_BE[1], val_2B_BE[0],
//				 condi_action[0], condi_action[1], condi_action[2], condi_action[3], condi_action[4],
//                 metadata};
//assign phv_out = {val_8B[15], val_8B[14], val_8B[13], val_8B[12], val_8B[11], val_8B[10], val_8B[9], val_8B[8],
//                 val_8B[7], val_8B[6], val_8B[5], val_8B[4], val_8B[3], val_8B[2], val_8B[1], val_8B[0],
//				 val_4B[11], val_4B[10], val_4B[9], val_4B[8], val_4B[7], val_4B[6], val_4B[5], val_4B[4],
//				 val_4B[3], val_4B[2], val_4B[1], val_4B[0], val_2B[3], val_2B[2], val_2B[1], val_2B[0],
//				 condi_action[0], condi_action[1], condi_action[2], condi_action[3], condi_action[4],
//                 metadata};
assign           phv_out = {64'd0, 64'd0, 64'd0, 64'd0, 64'd0, 64'd0, 64'd0, 64'd0,
                 val_8B[7], val_8B[6], val_8B[5], val_8B[4], val_8B[3], val_8B[2], val_8B[1], val_8B[0],
				 val_4B[11], val_4B[10], val_4B[9], val_4B[8], val_4B[7], val_4B[6], val_4B[5], val_4B[4],
				 val_4B[3], val_4B[2], val_4B[1], val_4B[0], val_2B[3], val_2B[2], val_2B[1], val_2B[0],
				 condi_action[0], condi_action[1], condi_action[2], condi_action[3], condi_action[4],
                 metadata};


generate
    for(gen_i = 0; gen_i < 20; gen_i = gen_i + 1)
        begin: sub_op
            sub_parser #(
	            .PARSE_ACT_RAM_WIDTH(),
                .C_PARSE_ACTION_LEN(),
                .HDR_FIELD_LEN(),
                .VAL_LEN()
            )sub_parser(
                .axis_clk(axis_clk),
	            .aresetn(aresetn),

	            .pkt_hdr_field(pkt_hdr_field),
                .pkt_hdr_field_valid(pkt_hdr_field_valid[gen_i]),

                .parse_action(parse_action[gen_i]),
                .parse_action_valid_in(parse_action_valid_in[gen_i]),

	            .val_valid_out(val_valid_out[gen_i]),
	            .val_out(val_out[gen_i]),
                .val_out_select(val_out_select[gen_i]),
                .val_seq_select(val_seq_select[gen_i])
            );
        end

endgenerate



/*================Control Path====================*/
reg [C_S_AXIS_DATA_WIDTH-1:0]	ctrl_m_axis_tdata_next;
reg [C_S_AXIS_TUSER_WIDTH-1:0]	ctrl_m_axis_tuser_next;
reg [C_S_AXIS_DATA_WIDTH/8-1:0]	ctrl_m_axis_tkeep_next;
reg								ctrl_m_axis_tlast_next;
reg								ctrl_m_axis_tvalid_next;

wire [C_S_AXIS_DATA_WIDTH-1:0] ctrl_s_axis_tdata_swapped;

assign ctrl_s_axis_tdata_swapped = {	c_s_axis_tdata[0+:8],
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
										c_s_axis_tdata[248+:8]};


reg	[7:0]						ctrl_wr_ram_addr, ctrl_wr_ram_addr_next;
reg	[611:0]						ctrl_wr_ram_data, ctrl_wr_ram_data_next;
reg								ctrl_wr_ram_en;
wire [7:0]						ctrl_mod_id;

assign ctrl_mod_id = c_s_axis_tdata[112+:8];

localparam	WAIT_FIRST_PKT = 0,
			WAIT_SECOND_PKT = 1,
			WAIT_THIRD_PKT = 2,
			WRITE_RAM = 3,
			FLUSH_REST_C = 4;

reg [2:0] ctrl_state, ctrl_state_next;

always @(*) begin
	ctrl_m_axis_tdata_next = c_s_axis_tdata;
	ctrl_m_axis_tuser_next = c_s_axis_tuser;
	ctrl_m_axis_tkeep_next = c_s_axis_tkeep;
	ctrl_m_axis_tlast_next = c_s_axis_tlast;
	ctrl_m_axis_tvalid_next = c_s_axis_tvalid;

	ctrl_state_next = ctrl_state;
	ctrl_wr_ram_en = 0;

	case (ctrl_state)
		WAIT_FIRST_PKT: begin
			// 1st ctrl packet
			if (c_s_axis_tvalid) begin
				ctrl_state_next = WAIT_SECOND_PKT;
			end
		end
		WAIT_SECOND_PKT: begin
			// 2nd ctrl packet, we can check module ID
			if (c_s_axis_tvalid) begin
				if (ctrl_mod_id[2:0]==PARSER_ID) begin
					ctrl_state_next = WAIT_THIRD_PKT;

					ctrl_wr_ram_addr = c_s_axis_tdata[128+:8];
				end
				else begin
					ctrl_state_next = FLUSH_REST_C;
				end
			end
		end
		WAIT_THIRD_PKT: begin // first half of ctrl_wr_ram_data
			if (c_s_axis_tvalid) begin
				ctrl_state_next = WRITE_RAM;
				ctrl_wr_ram_data[419-: 256] = ctrl_s_axis_tdata_swapped[255:0];
			end
		end
		WRITE_RAM: begin // second half of ctrl_wr_ram_data
			if (c_s_axis_tvalid) begin
				if (c_s_axis_tlast) 
					ctrl_state_next = WAIT_FIRST_PKT;
				else
					ctrl_state_next = FLUSH_REST_C;
				    ctrl_wr_ram_en = 1;
				    ctrl_wr_ram_data[163:0] = ctrl_s_axis_tdata_swapped[255-: 164];
			end
		end
		FLUSH_REST_C: begin
			if (c_s_axis_tvalid && c_s_axis_tlast)
				ctrl_state_next = WAIT_FIRST_PKT;
		end
	endcase
end

always @(posedge axis_clk) begin
	if (~aresetn) begin
		//
		ctrl_state <= WAIT_FIRST_PKT;

		c_m_axis_tdata <= 0;
		c_m_axis_tuser <= 0;
		c_m_axis_tkeep <= 0;
		c_m_axis_tvalid <= 0;
		c_m_axis_tlast <= 0;
	end
	else begin
		ctrl_state <= ctrl_state_next;

		c_m_axis_tdata <= ctrl_m_axis_tdata_next;
		c_m_axis_tuser <= ctrl_m_axis_tuser_next;
		c_m_axis_tkeep <= ctrl_m_axis_tkeep_next;
		c_m_axis_tlast <= ctrl_m_axis_tlast_next;
		c_m_axis_tvalid <= ctrl_m_axis_tvalid_next;
	end
end

// =============================================================== //
// parse_act_ram_ip #(
// 	.C_INIT_FILE_NAME	("./parse_act_ram_init_file.mif"),
// 	.C_LOAD_INIT_FILE	(1)
// )
parse_act_ram_ip
parse_act_ram
(
	// write port
	.clka		(axis_clk),
	.addra		(ctrl_wr_ram_addr[3:0]),
	.dina		(ctrl_wr_ram_data),
	.ena		(1'b1),
	.wea		(ctrl_wr_ram_en),

	//
	.clkb		(axis_clk),
	.addrb		(vlan_id[7:4]), // TODO: note that we may change due to little or big endian
	.doutb		(bram_out),
	.enb		(1'b1) // always set to 1
);

endmodule