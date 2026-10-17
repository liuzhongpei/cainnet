`timescale 1ns / 1ps

module parser #(
    //for 100g MAC, the AXIS width is 512b
	parameter C_S_AXIS_DATA_WIDTH = 512,
	parameter C_S_AXIS_TUSER_WIDTH = 128,
	parameter PKT_HDR_LEN = 8*16*8+4*12*8+2*4*8+20*5+256, // check with the doc
	parameter PARSE_ACT_RAM_WIDTH = 167,    //��֪��
    parameter PARSER_ID = 0
    )(
    input									axis_clk,
	input									aresetn,

	// input slvae axi stream   //Դ�˿�
	input [C_S_AXIS_DATA_WIDTH-1:0]			s_axis_tdata,
	input [C_S_AXIS_TUSER_WIDTH-1:0]		s_axis_tuser,
	input [C_S_AXIS_DATA_WIDTH/8-1:0]		s_axis_tkeep,
	input									s_axis_tvalid,
	input									s_axis_tlast,

	// output
	output   								phv_valid_out,
	output      [PKT_HDR_LEN-1:0]			phv_out,

    //control path  //Ŀ�Ķ˿�
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

reg [11:0] vlan_id;

//Parse Action RAM
wire [611:0] bram_out;  //��������33����ָ��
//13~16λ��ʾphv��������-8B 16��
wire [15:0]  parse_action [0:31];    //ǰ32����ָ��
reg  [19:0]  condi_action [0:4];    //n��20b
reg  [19:0]  condi_action_d[0:4];

reg [63:0] val_8B [0:15];    //8��16����
reg [31:0] val_4B [0:11];
reg [15:0] val_2B [0:3];

wire [63:0] val_8B_BE [0:15];    //���
wire [31:0] val_4B_BE [0:11];
wire [15:0] val_2B_BE [0:3];

//��С���л�
//BE LE switching
assign val_2B_BE[0] = {val_2B[0][7:0], val_2B[0][15:8]};
assign val_2B_BE[1] = {val_2B[1][7:0], val_2B[1][15:8]};
assign val_2B_BE[2] = {val_2B[2][7:0], val_2B[2][15:8]};
assign val_2B_BE[3] = {val_2B[3][7:0], val_2B[3][15:8]};

assign val_4B_BE[0] = {val_4B[0][7:0], val_4B[0][15:8], val_4B[0][23:16], val_4B[0][31:24]};
assign val_4B_BE[1] = {val_4B[1][7:0], val_4B[1][15:8], val_4B[1][23:16], val_4B[1][31:24]};
assign val_4B_BE[2] = {val_4B[2][7:0], val_4B[2][15:8], val_4B[2][23:16], val_4B[2][31:24]};
assign val_4B_BE[3] = {val_4B[3][7:0], val_4B[3][15:8], val_4B[3][23:16], val_4B[3][31:24]};
assign val_4B_BE[4] = {val_4B[4][7:0], val_4B[4][15:8], val_4B[4][23:16], val_4B[4][31:24]};
assign val_4B_BE[5] = {val_4B[5][7:0], val_4B[5][15:8], val_4B[5][23:16], val_4B[5][31:24]};
assign val_4B_BE[6] = {val_4B[6][7:0], val_4B[6][15:8], val_4B[6][23:16], val_4B[6][31:24]};
assign val_4B_BE[7] = {val_4B[7][7:0], val_4B[7][15:8], val_4B[7][23:16], val_4B[7][31:24]};
assign val_4B_BE[8] = {val_4B[8][7:0], val_4B[8][15:8], val_4B[8][23:16], val_4B[8][31:24]};
assign val_4B_BE[9] = {val_4B[9][7:0], val_4B[9][15:8], val_4B[9][23:16], val_4B[9][31:24]};
assign val_4B_BE[10] = {val_4B[10][7:0], val_4B[10][15:8], val_4B[10][23:16], val_4B[10][31:24]};
assign val_4B_BE[11] = {val_4B[11][7:0], val_4B[11][15:8], val_4B[11][23:16], val_4B[11][31:24]};

assign val_8B_BE[0] = {val_8B[0][7:0], val_8B[0][15:8], val_8B[0][23:16], val_8B[0][31:24], val_8B[0][39:32], val_8B[0][47:40], val_8B[0][55:48], val_8B[0][63:56]};
assign val_8B_BE[1] = {val_8B[1][7:0], val_8B[1][15:8], val_8B[1][23:16], val_8B[1][31:24], val_8B[1][39:32], val_8B[1][47:40], val_8B[1][55:48], val_8B[1][63:56]};
assign val_8B_BE[2] = {val_8B[2][7:0], val_8B[2][15:8], val_8B[2][23:16], val_8B[2][31:24], val_8B[2][39:32], val_8B[2][47:40], val_8B[2][55:48], val_8B[2][63:56]};
assign val_8B_BE[3] = {val_8B[3][7:0], val_8B[3][15:8], val_8B[3][23:16], val_8B[3][31:24], val_8B[3][39:32], val_8B[3][47:40], val_8B[3][55:48], val_8B[3][63:56]};
assign val_8B_BE[4] = {val_8B[4][7:0], val_8B[4][15:8], val_8B[4][23:16], val_8B[4][31:24], val_8B[4][39:32], val_8B[4][47:40], val_8B[4][55:48], val_8B[4][63:56]};
assign val_8B_BE[5] = {val_8B[5][7:0], val_8B[5][15:8], val_8B[5][23:16], val_8B[5][31:24], val_8B[5][39:32], val_8B[5][47:40], val_8B[5][55:48], val_8B[5][63:56]};
assign val_8B_BE[6] = {val_8B[6][7:0], val_8B[6][15:8], val_8B[6][23:16], val_8B[6][31:24], val_8B[6][39:32], val_8B[6][47:40], val_8B[6][55:48], val_8B[6][63:56]};
assign val_8B_BE[7] = {val_8B[7][7:0], val_8B[7][15:8], val_8B[7][23:16], val_8B[7][31:24], val_8B[7][39:32], val_8B[7][47:40], val_8B[7][55:48], val_8B[7][63:56]};
assign val_8B_BE[8] = {val_8B[8][7:0], val_8B[8][15:8], val_8B[8][23:16], val_8B[8][31:24], val_8B[8][39:32], val_8B[8][47:40], val_8B[8][55:48], val_8B[8][63:56]};
assign val_8B_BE[9] = {val_8B[9][7:0], val_8B[9][15:8], val_8B[9][23:16], val_8B[9][31:24], val_8B[9][39:32], val_8B[9][47:40], val_8B[9][55:48], val_8B[9][63:56]};
assign val_8B_BE[10] = {val_8B[10][7:0], val_8B[10][15:8], val_8B[10][23:16], val_8B[10][31:24], val_8B[10][39:32], val_8B[10][47:40], val_8B[10][55:48], val_8B[10][63:56]};
assign val_8B_BE[11] = {val_8B[11][7:0], val_8B[11][15:8], val_8B[11][23:16], val_8B[11][31:24], val_8B[11][39:32], val_8B[11][47:40], val_8B[11][55:48], val_8B[11][63:56]};
assign val_8B_BE[12] = {val_8B[12][7:0], val_8B[12][15:8], val_8B[12][23:16], val_8B[12][31:24], val_8B[12][39:32], val_8B[12][47:40], val_8B[12][55:48], val_8B[12][63:56]};
assign val_8B_BE[13] = {val_8B[13][7:0], val_8B[13][15:8], val_8B[13][23:16], val_8B[13][31:24], val_8B[13][39:32], val_8B[13][47:40], val_8B[13][55:48], val_8B[13][63:56]};
assign val_8B_BE[14] = {val_8B[14][7:0], val_8B[14][15:8], val_8B[14][23:16], val_8B[14][31:24], val_8B[14][39:32], val_8B[14][47:40], val_8B[14][55:48], val_8B[14][63:56]};
assign val_8B_BE[15] = {val_8B[15][7:0], val_8B[15][15:8], val_8B[15][23:16], val_8B[15][31:24], val_8B[15][39:32], val_8B[15][47:40], val_8B[15][55:48], val_8B[15][63:56]};

integer idx;
localparam SEG_NUM = 2048/C_S_AXIS_DATA_WIDTH; //?????????????????????????????????????????????????????????????????????????????????????
//reg [C_S_AXIS_DATA_WIDTH-1:0]  pkt_seg [0:(1024/C_S_AXIS_DATA_WIDTH-1)];

// reg [SEG_NUM-1:0] pkt_seg_cnt;
reg [3:0]    pkt_seg_cnt; //cnt is 4'd6 if its invalid ��������
reg          s_axis_tvalid_before;

reg [2047:0] pkt_hdr_field;
reg [255:0] metadata;


/**
divide and conquar (below)
*/

genvar gen_i;

localparam C_PARSE_ACTION_LEN = 16;

reg [31:0]                    pkt_hdr_field_valid;
reg [31:0]                    parse_action_valid_in;

wire [63:0]                  val_out[0:31]; 
wire [1:0]                   val_out_select[0:31];
wire [3:0]                   val_seq_select[0:31];
wire [31:0]                   val_valid_out;


//here we extract the 1024b from packet (depend on data_width)
reg [3:0] parse_state;

localparam IDLE_S   = 4'd0,
           WAIT1_S  = 4'd1,
           WAIT2_S  = 4'd2,
           WAIT3_S  = 4'd3,
           WAIT4_S  = 4'd4,
           WAIT5_S  = 4'd5,
           WAIT6_S  = 4'd6,
           WAIT7_S  = 4'd7,
           WAIT8_S  = 4'd8,
           PHVGEN_S = 4'd9;


//get vlan_id from 1st segment.


assign parse_action[31] = bram_out[100+:16]; //ǰ32����ָ��ȡ��λ��
assign parse_action[30] = bram_out[116+:16];
assign parse_action[29] = bram_out[132+:16];
assign parse_action[28] = bram_out[148+:16];
assign parse_action[27] = bram_out[164+:16];
assign parse_action[26] = bram_out[180+:16];
assign parse_action[25] = bram_out[196+:16];
assign parse_action[24] = bram_out[212+:16];
assign parse_action[23] = bram_out[228+:16];
assign parse_action[22] = bram_out[244+:16];
assign parse_action[21] = bram_out[260+:16];
assign parse_action[20] = bram_out[276+:16];
assign parse_action[19] = bram_out[292+:16];
assign parse_action[18] = bram_out[308+:16];
assign parse_action[17] = bram_out[324+:16];
assign parse_action[16] = bram_out[340+:16];
assign parse_action[15] = bram_out[356+:16];
assign parse_action[14] = bram_out[372+:16];
assign parse_action[13] = bram_out[388+:16];
assign parse_action[12] = bram_out[404+:16];
assign parse_action[11] = bram_out[420+:16];
assign parse_action[10] = bram_out[436+:16];
assign parse_action[9] = bram_out[452+:16];
assign parse_action[8] = bram_out[468+:16];
assign parse_action[7] = bram_out[484+:16];
assign parse_action[6] = bram_out[500+:16];
assign parse_action[5] = bram_out[516+:16];
assign parse_action[4] = bram_out[532+:16];
assign parse_action[3] = bram_out[548+:16];
assign parse_action[2] = bram_out[564+:16];
assign parse_action[1] = bram_out[580+:16];
assign parse_action[0] = bram_out[596+:16];
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

always @(posedge axis_clk) begin
    condi_action_d[0] <= bram_out[0+:20];   //ȡ��11����ָ��
    condi_action_d[1] <= bram_out[20+:20];
    condi_action_d[2] <= bram_out[40+:20];
    condi_action_d[3] <= bram_out[60+:20];
    condi_action_d[4] <= bram_out[80+:20];
    condi_action[0] <= condi_action_d[0];   //����
    condi_action[1] <= condi_action_d[1];
    condi_action[2] <= condi_action_d[2];
    condi_action[3] <= condi_action_d[3];
    condi_action[4] <= condi_action_d[4];
    
end

generate
    if(C_S_AXIS_DATA_WIDTH == 512) begin
        always @(posedge axis_clk) begin
            s_axis_tvalid_before <= s_axis_tvalid;
        end

//a counter to determine if this value needs to be recorded
        always @(posedge axis_clk or negedge aresetn) begin
            if(~aresetn) begin
                pkt_seg_cnt <= 0;
            end
    //1st segment
            else begin
                if(s_axis_tvalid && ~s_axis_tvalid_before) begin
                    pkt_seg_cnt <= 4'd0;
                end
        //left but not 1st segment (within SEG_NUM)
                else if(s_axis_tvalid) begin
                    pkt_seg_cnt <= pkt_seg_cnt + 4'b1;
                end
                else begin
                    pkt_seg_cnt <= pkt_seg_cnt;
                end
            end
        end

//record the pkts into pkt_hdr_field
        always @(posedge axis_clk or negedge aresetn) begin
            if(~aresetn) begin
                pkt_hdr_field <= 2048'b0;
                s_axis_tvalid_before <= 0;
                vlan_id <= 0;
            end
            else begin
        //the 1st segment of the packet
                if(s_axis_tvalid && ~s_axis_tvalid_before) begin
            //pkt_hdr_field <= s_axis_tdata<<(1024-C_S_AXIS_DATA_WIDTH);    
                    pkt_hdr_field[511:0] <= s_axis_tdata;   
                    metadata[127:0] <= s_axis_tuser;
                    vlan_id <= s_axis_tdata[116 +: 12];  
                end
                else if(pkt_seg_cnt < SEG_NUM && s_axis_tvalid) begin
                    if(pkt_seg_cnt == SEG_NUM-4) begin
                        pkt_hdr_field[1024-1 -: C_S_AXIS_DATA_WIDTH] <= s_axis_tdata;
                        metadata[256-1 -: C_S_AXIS_TUSER_WIDTH] <= s_axis_tuser; 
                    end
                    else if(pkt_seg_cnt == SEG_NUM-3) begin
                        pkt_hdr_field[1536-1 -: C_S_AXIS_DATA_WIDTH] <= s_axis_tdata;
                        metadata <= metadata;
                    end   
                    else if(pkt_seg_cnt == SEG_NUM-2) begin
                        pkt_hdr_field[2048-1 -: C_S_AXIS_DATA_WIDTH] <= s_axis_tdata;
                        metadata <= metadata;
                    end
                    else begin
                            pkt_hdr_field <= pkt_hdr_field;
                            metadata <= metadata;
                    end   
                end
                else begin
                    pkt_hdr_field <= pkt_hdr_field;
                    metadata <= metadata;
                end
            end
        end
         //fire up the FSM
        always @(posedge axis_clk or negedge aresetn) begin
            if(~aresetn) begin
                phv_valid_out_reg <= 1'b0;
                //phv_out <= 1828'b0;
                pkt_hdr_field <= 2048'b0;
                metadata <= 356'b0;
                for(idx=0; idx<32; idx = idx+1) begin
                    parse_action_valid_in[idx] <= 1'b0;
                    pkt_hdr_field_valid[idx] <= 1'b0;
                end
                parse_state <= IDLE_S;
            end
            else begin
                case(parse_state)
                    IDLE_S: begin
                        if(s_axis_tvalid && ~s_axis_tvalid_before) begin
                            parse_state <= WAIT1_S;
                        end
                        phv_valid_out_reg <= 1'b0;
                        //phv_out<=1024';
                        for(idx = 0; idx < 4; idx = idx+1) begin
                            val_2B[idx] <= 16'b0;
                        end
                        for(idx = 0; idx < 12; idx = idx+1) begin
                            val_4B[idx] <= 32'b0;
                        end
                        for(idx = 0; idx < 16; idx = idx+1) begin
                            val_8B[idx] <= 64'b0;
                        end
                        for(idx=0; idx<32; idx = idx+1) begin
                            parse_action_valid_in[idx] <= parse_action[idx][0];
                            pkt_hdr_field_valid[idx] <= 1'b0;
                        end
                    end
        
                    WAIT1_S: begin
                        parse_state <= WAIT2_S;
                        for(idx=0; idx<32; idx = idx+1) begin
                            parse_action_valid_in[idx] <= parse_action[idx][0];
                            pkt_hdr_field_valid[idx] <= 1'b0;
                        end
                    end 
                    
                    WAIT2_S: begin
                        parse_state <= WAIT7_S;
                        for(idx=0; idx<32; idx = idx+1) begin
                            parse_action_valid_in[idx] <= parse_action[idx][0];
                            pkt_hdr_field_valid[idx] <= 1'b0;
                        end
                    end 
                    
                    WAIT7_S: begin
                        parse_state <= WAIT8_S;
                        for(idx=0; idx<32; idx = idx+1) begin
                            parse_action_valid_in[idx] <= parse_action[idx][0];
                            pkt_hdr_field_valid[idx] <= 1'b1;
                        end
                    end
                    
                    
                    WAIT8_S: begin
                        for(idx=0; idx<32; idx = idx+1) begin
                            parse_action_valid_in[idx] <= 1'b0;
                            pkt_hdr_field_valid[idx] <= 1'b0;
                        end
                        parse_state <= PHVGEN_S;
                    end
                    
        
                    PHVGEN_S: begin
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
                            2'b10: val_4B[val_seq_select[15]] <= val_out[15][31:0];
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
                        case(val_out_select[20])
                            2'b01: val_2B[val_seq_select[20]] <= val_out[20][15:0];
                            2'b10: val_4B[val_seq_select[20]] <= val_out[20][31:0];
                            2'b11: val_8B[val_seq_select[20]] <= val_out[20][63:0];
                        endcase
                        case(val_out_select[21])
                            2'b01: val_2B[val_seq_select[21]] <= val_out[21][15:0];
                            2'b10: val_4B[val_seq_select[21]] <= val_out[21][31:0];
                            2'b11: val_8B[val_seq_select[21]] <= val_out[21][63:0];
                        endcase
                        case(val_out_select[22])
                            2'b01: val_2B[val_seq_select[22]] <= val_out[22][15:0];
                            2'b10: val_4B[val_seq_select[22]] <= val_out[22][31:0];
                            2'b11: val_8B[val_seq_select[22]] <= val_out[22][63:0];
                        endcase
                        case(val_out_select[23])
                            2'b01: val_2B[val_seq_select[23]] <= val_out[23][15:0];
                            2'b10: val_4B[val_seq_select[23]] <= val_out[23][31:0];
                            2'b11: val_8B[val_seq_select[23]] <= val_out[23][63:0];
                        endcase
                        case(val_out_select[24])
                            2'b01: val_2B[val_seq_select[24]] <= val_out[24][15:0];
                            2'b10: val_4B[val_seq_select[24]] <= val_out[24][31:0];
                            2'b11: val_8B[val_seq_select[24]] <= val_out[24][63:0];
                        endcase
                        case(val_out_select[25])
                            2'b01: val_2B[val_seq_select[25]] <= val_out[25][15:0];
                            2'b10: val_4B[val_seq_select[25]] <= val_out[25][31:0];
                            2'b11: val_8B[val_seq_select[25]] <= val_out[25][63:0];
                        endcase
                        case(val_out_select[26])
                            2'b01: val_2B[val_seq_select[26]] <= val_out[26][15:0];
                            2'b10: val_4B[val_seq_select[26]] <= val_out[26][31:0];
                            2'b11: val_8B[val_seq_select[26]] <= val_out[26][63:0];
                        endcase
                        case(val_out_select[27])
                            2'b01: val_2B[val_seq_select[27]] <= val_out[27][15:0];
                            2'b10: val_4B[val_seq_select[27]] <= val_out[27][31:0];
                            2'b11: val_8B[val_seq_select[27]] <= val_out[27][63:0];
                        endcase
                        case(val_out_select[28])
                            2'b01: val_2B[val_seq_select[28]] <= val_out[28][15:0];
                            2'b10: val_4B[val_seq_select[28]] <= val_out[28][31:0];
                            2'b11: val_8B[val_seq_select[28]] <= val_out[28][63:0];
                        endcase
                        case(val_out_select[29])
                            2'b01: val_2B[val_seq_select[29]] <= val_out[29][15:0];
                            2'b10: val_4B[val_seq_select[29]] <= val_out[29][31:0];
                            2'b11: val_8B[val_seq_select[29]] <= val_out[29][63:0];
                        endcase
                        case(val_out_select[30])
                            2'b01: val_2B[val_seq_select[30]] <= val_out[30][15:0];
                            2'b10: val_4B[val_seq_select[30]] <= val_out[30][31:0];
                            2'b11: val_8B[val_seq_select[30]] <= val_out[30][63:0];
                        endcase
                        case(val_out_select[31])
                            2'b01: val_2B[val_seq_select[31]] <= val_out[31][15:0];
                            2'b10: val_4B[val_seq_select[31]] <= val_out[31][31:0];
                            2'b11: val_8B[val_seq_select[31]] <= val_out[31][63:0];
                        endcase
                        phv_valid_out_reg <= 1'b1;
                        parse_state <= IDLE_S;
                    end
                endcase
            end
        end
    end
    
    
    else begin
        always @(posedge axis_clk) begin
            s_axis_tvalid_before <= s_axis_tvalid;
        end

//a counter to determine if this value needs to be recorded
        always @(posedge axis_clk or negedge !aresetn) begin
            if(~aresetn) begin
                pkt_seg_cnt <= 0;
            end
    //1st segment
            else begin
                if(s_axis_tvalid && ~s_axis_tvalid_before) begin
                    pkt_seg_cnt <= 4'd0;
                end
        //left but not 1st segment (within SEG_NUM)
                else if(s_axis_tvalid) begin
                    pkt_seg_cnt <= pkt_seg_cnt + 4'b1;
                end
                else begin
                    pkt_seg_cnt <= pkt_seg_cnt;
                end
            end
        end

//record the pkts into pkt_hdr_field
        always @(posedge axis_clk or negedge aresetn) begin
            if(~aresetn) begin
                pkt_hdr_field <= 2048'b0;
                s_axis_tvalid_before <= 0;
                vlan_id <= 0;
            end
            else begin
        //the 1st segment of the packet
                if(s_axis_tvalid && ~s_axis_tvalid_before) begin
            //pkt_hdr_field <= s_axis_tdata<<(1024-C_S_AXIS_DATA_WIDTH);    
                    pkt_hdr_field[255:0] <= s_axis_tdata;  
                    metadata[127:0] <= s_axis_tuser[111:0];
                    metadata[140:129] <= s_axis_tdata[116 +: 12];//give vlan_id to metadata
                    vlan_id <= s_axis_tdata[116 +: 12];     
                end
                else if(pkt_seg_cnt < SEG_NUM && s_axis_tvalid) begin
                    if(pkt_seg_cnt == SEG_NUM-8) begin
                        pkt_hdr_field[512-1 -: C_S_AXIS_DATA_WIDTH] <= s_axis_tdata;
                        metadata[256-1 -: C_S_AXIS_TUSER_WIDTH] <= s_axis_tuser; 
                    end
                    else if(pkt_seg_cnt == SEG_NUM-7) begin
                        pkt_hdr_field[768-1 -: C_S_AXIS_DATA_WIDTH] <= s_axis_tdata;
                        metadata <= metadata;
                    end   
                    else if(pkt_seg_cnt == SEG_NUM-6) begin
                        pkt_hdr_field[1024-1 -: C_S_AXIS_DATA_WIDTH] <= s_axis_tdata;
                        metadata <= metadata;
                    end
                    else if(pkt_seg_cnt == SEG_NUM-5) begin
                        pkt_hdr_field[1280-1 -: C_S_AXIS_DATA_WIDTH] <= s_axis_tdata;
                        metadata <= metadata;
                    end
                    else if(pkt_seg_cnt == SEG_NUM-4) begin
                        pkt_hdr_field[1536-1 -: C_S_AXIS_DATA_WIDTH] <= s_axis_tdata;
                        metadata <= metadata;
                    end
                    else if(pkt_seg_cnt == SEG_NUM-3) begin
                        pkt_hdr_field[1792-1 -: C_S_AXIS_DATA_WIDTH] <= s_axis_tdata;
                        metadata <= metadata;
                    end
                    else if(pkt_seg_cnt == SEG_NUM-2) begin
                        pkt_hdr_field[2048-1 -: C_S_AXIS_DATA_WIDTH] <= s_axis_tdata;
                        metadata <= metadata;
                    end
                    else begin
                            pkt_hdr_field <= pkt_hdr_field;
                            metadata <= metadata;
                    end   
                end
                else begin
                    pkt_hdr_field <= pkt_hdr_field;
                    metadata <= metadata;
                end
            end
        end

        //fire up the FSM
        always @(posedge axis_clk or negedge aresetn) begin
            if(~aresetn) begin
                phv_valid_out_reg <= 1'b0;
                //phv_out <= 1828'b0;
                pkt_hdr_field <= 2048'b0;
                metadata <= 356'b0;
                
                for(idx=0; idx<32; idx = idx+1) begin
                    parse_action_valid_in[idx] <= 1'b0;
                    pkt_hdr_field_valid[idx] <= 1'b0;
                end
                parse_state <= IDLE_S;
            end
            else begin
                case(parse_state)
                    IDLE_S: begin
                        if(s_axis_tvalid && ~s_axis_tvalid_before) begin
                            parse_state <= WAIT1_S;
                        end
                        phv_valid_out_reg <= 1'b0;
                        //phv_out<=1024';
                        for(idx = 0; idx < 4; idx = idx+1) begin
                            val_2B[idx] <= 16'b0;
                        end
                        for(idx = 0; idx < 12; idx = idx+1) begin
                            val_4B[idx] <= 32'b0;
                        end
                        for(idx = 0; idx < 16; idx = idx+1) begin
                            val_8B[idx] <= 64'b0;
                        end
                        for(idx=0; idx<32; idx = idx+1) begin
                            parse_action_valid_in[idx] <= parse_action[idx][0];
                            pkt_hdr_field_valid[idx] <= 1'b0;
                        end
                    end
        
                    WAIT1_S: begin
                        parse_state <= WAIT2_S;
                        for(idx=0; idx<32; idx = idx+1) begin
                            parse_action_valid_in[idx] <= parse_action[idx][0];
                            pkt_hdr_field_valid[idx] <= 1'b0;
                        end
                    end 
                    
                    WAIT2_S: begin
                        parse_state <= WAIT3_S;
                        for(idx=0; idx<32; idx = idx+1) begin
                            parse_action_valid_in[idx] <= parse_action[idx][0];
                            pkt_hdr_field_valid[idx] <= 1'b0;
                        end
                    end 
                    
                    WAIT3_S: begin
                        parse_state <= WAIT4_S;
                        for(idx=0; idx<32; idx = idx+1) begin
                            parse_action_valid_in[idx] <= parse_action[idx][0];
                            pkt_hdr_field_valid[idx] <= 1'b0;
                        end
                    end
                    
                    WAIT4_S: begin
                        parse_state <= WAIT5_S;
                        for(idx=0; idx<32; idx = idx+1) begin
                            parse_action_valid_in[idx] <= parse_action[idx][0];
                            pkt_hdr_field_valid[idx] <= 1'b0;
                        end
                    end
                    
                    WAIT5_S: begin
                        parse_state <= WAIT6_S;
                        for(idx=0; idx<32; idx = idx+1) begin
                            parse_action_valid_in[idx] <= parse_action[idx][0];
                            pkt_hdr_field_valid[idx] <= 1'b0;
                        end
                    end
                    
                    WAIT6_S: begin
                        parse_state <= WAIT7_S;
                        for(idx=0; idx<32; idx = idx+1) begin
                            parse_action_valid_in[idx] <= parse_action[idx][0];
                            pkt_hdr_field_valid[idx] <= 1'b0;
                        end
                    end
        
                    WAIT7_S: begin
                        parse_state <= WAIT8_S;
                        for(idx=0; idx<32; idx = idx+1) begin
                            parse_action_valid_in[idx] <= parse_action[idx][0];
                            pkt_hdr_field_valid[idx] <= 1'b1;
                        end
                    end
                    
                    
                    WAIT8_S: begin
                        for(idx=0; idx<32; idx = idx+1) begin
                            parse_action_valid_in[idx] <= 1'b0;
                            pkt_hdr_field_valid[idx] <= 1'b0;
                        end
                        parse_state <= PHVGEN_S;
                    end
                    
        
                    PHVGEN_S: begin
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
                            2'b10: val_4B[val_seq_select[15]] <= val_out[15][31:0];
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
                        case(val_out_select[20])
                            2'b01: val_2B[val_seq_select[20]] <= val_out[20][15:0];
                            2'b10: val_4B[val_seq_select[20]] <= val_out[20][31:0];
                            2'b11: val_8B[val_seq_select[20]] <= val_out[20][63:0];
                        endcase
                        case(val_out_select[21])
                            2'b01: val_2B[val_seq_select[21]] <= val_out[21][15:0];
                            2'b10: val_4B[val_seq_select[21]] <= val_out[21][31:0];
                            2'b11: val_8B[val_seq_select[21]] <= val_out[21][63:0];
                        endcase
                        case(val_out_select[22])
                            2'b01: val_2B[val_seq_select[22]] <= val_out[22][15:0];
                            2'b10: val_4B[val_seq_select[22]] <= val_out[22][31:0];
                            2'b11: val_8B[val_seq_select[22]] <= val_out[22][63:0];
                        endcase
                        case(val_out_select[23])
                            2'b01: val_2B[val_seq_select[23]] <= val_out[23][15:0];
                            2'b10: val_4B[val_seq_select[23]] <= val_out[23][31:0];
                            2'b11: val_8B[val_seq_select[23]] <= val_out[23][63:0];
                        endcase
                        case(val_out_select[24])
                            2'b01: val_2B[val_seq_select[24]] <= val_out[24][15:0];
                            2'b10: val_4B[val_seq_select[24]] <= val_out[24][31:0];
                            2'b11: val_8B[val_seq_select[24]] <= val_out[24][63:0];
                        endcase
                        case(val_out_select[25])
                            2'b01: val_2B[val_seq_select[25]] <= val_out[25][15:0];
                            2'b10: val_4B[val_seq_select[25]] <= val_out[25][31:0];
                            2'b11: val_8B[val_seq_select[25]] <= val_out[25][63:0];
                        endcase
                        case(val_out_select[26])
                            2'b01: val_2B[val_seq_select[26]] <= val_out[26][15:0];
                            2'b10: val_4B[val_seq_select[26]] <= val_out[26][31:0];
                            2'b11: val_8B[val_seq_select[26]] <= val_out[26][63:0];
                        endcase
                        case(val_out_select[27])
                            2'b01: val_2B[val_seq_select[27]] <= val_out[27][15:0];
                            2'b10: val_4B[val_seq_select[27]] <= val_out[27][31:0];
                            2'b11: val_8B[val_seq_select[27]] <= val_out[27][63:0];
                        endcase
                        case(val_out_select[28])
                            2'b01: val_2B[val_seq_select[28]] <= val_out[28][15:0];
                            2'b10: val_4B[val_seq_select[28]] <= val_out[28][31:0];
                            2'b11: val_8B[val_seq_select[28]] <= val_out[28][63:0];
                        endcase
                        case(val_out_select[29])
                            2'b01: val_2B[val_seq_select[29]] <= val_out[29][15:0];
                            2'b10: val_4B[val_seq_select[29]] <= val_out[29][31:0];
                            2'b11: val_8B[val_seq_select[29]] <= val_out[29][63:0];
                        endcase
                        case(val_out_select[30])
                            2'b01: val_2B[val_seq_select[30]] <= val_out[30][15:0];
                            2'b10: val_4B[val_seq_select[30]] <= val_out[30][31:0];
                            2'b11: val_8B[val_seq_select[30]] <= val_out[30][63:0];
                        endcase
                        case(val_out_select[31])
                            2'b01: val_2B[val_seq_select[31]] <= val_out[31][15:0];
                            2'b10: val_4B[val_seq_select[31]] <= val_out[31][31:0];
                            2'b11: val_8B[val_seq_select[31]] <= val_out[31][63:0];
                        endcase
                        phv_valid_out_reg <= 1'b1;
                        parse_state <= IDLE_S;
                    end
                endcase
            end
        end
    end
endgenerate

//big endian for simpler processing
assign phv_out = {val_8B_BE[15], val_8B_BE[14], val_8B_BE[13], val_8B_BE[12], val_8B_BE[11], val_8B_BE[10], val_8B_BE[9], val_8B_BE[8],
                 val_8B_BE[7], val_8B_BE[6], val_8B_BE[5], val_8B_BE[4], val_8B_BE[3], val_8B_BE[2], val_8B_BE[1], val_8B_BE[0],
				 val_4B_BE[11], val_4B_BE[10], val_4B_BE[9], val_4B_BE[8], val_4B_BE[7], val_4B_BE[6], val_4B_BE[5], val_4B_BE[4],
				 val_4B_BE[3], val_4B_BE[2], val_4B_BE[1], val_4B_BE[0], val_2B_BE[3], val_2B_BE[2], val_2B_BE[1], val_2B_BE[0],
				 condi_action[0], condi_action[1], condi_action[2], condi_action[3], condi_action[4],
                 metadata};



generate
    for(gen_i = 0; gen_i < 32; gen_i = gen_i + 1)
        begin: sub_op
            sub_parser #(
                //for 100g MAC, the AXIS width is 512b
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



/****control path for 512b*****/
wire [7:0]          mod_id; //module ID
wire [15:0]         control_flag; //dst udp port num
reg  [7:0]          c_index; //table index(addr)
reg                 c_wr_en; //enable table write(wen)
reg  [611:0]        entry_reg;

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

        always @(posedge axis_clk or negedge aresetn) begin
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
                        if(c_s_axis_tvalid && mod_id[2:0] == PARSER_ID && control_flag == 16'hf2f1)begin
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
        parse_act_ram_ip
        parse_act_ram
        (
	       // write port
	       .clka		(axis_clk),
	       .addra		(c_index[3:0]),
	       .dina		(entry_reg),    /////////////////////////////////////////////260�� 32*16+100
	       .ena		(1'b1),
	       .wea		(c_wr_en),

	       //
	       .clkb		(axis_clk),
	       .addrb		(vlan_id[7:4]), // TODO: note that we may change due to little or big endian
	       .doutb		(bram_out),
	       .enb		(1'b1) // always set to 1
        );
    end
    
    //NOTE: data width is 256b
    else if(C_S_AXIS_DATA_WIDTH == 256) begin
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

        always @(posedge axis_clk or negedge aresetn) begin
            if(~aresetn) begin
                c_wr_en <= 1'b0;
                c_index <= 8'b0;

                c_m_axis_tdata <= 0;
                c_m_axis_tuser <= 0;
                c_m_axis_tkeep <= 0;
                c_m_axis_tvalid <= 0;
                c_m_axis_tlast <= 0;
                
                c_m_axis_tdata_r <= 0;
                c_m_axis_tuser_r <= 0;
                c_m_axis_tkeep_r <= 0;
                c_m_axis_tvalid_r <= 0;
                c_m_axis_tlast_r <= 0;
                
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
                        if(mod_id[2:0] == PARSER_ID && control_flag == 16'hf2f1 && c_s_axis_tvalid) begin
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
        parse_act_ram_ip
        parse_act_ram
        (
	       // write port
	       .clka		(axis_clk),
	       .addra		(c_index[3:0]),
	       .dina		(entry_reg),    /////////////////////////////////////////////260�� 32*16+100
	       .ena		(1'b1),
	       .wea		(c_wr_en),

	       //
	       .clkb		(axis_clk),
	       .addrb		(vlan_id[7:4]), // TODO: note that we may change due to little or big endian
	       .doutb		(bram_out),
	       .enb		(1'b1) // always set to 1
        );
    end


endgenerate
endmodule


