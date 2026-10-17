
`timescale 1ns / 1ps

module tb_rmt_wrapper #(
    // Slave AXI parameters
	parameter C_S_AXI_DATA_WIDTH = 32,
	parameter C_S_AXI_ADDR_WIDTH = 12,
	parameter C_BASEADDR = 32'h80000000,
	// AXI Stream parameters
	// Slave
	parameter C_S_AXIS_DATA_WIDTH = 256,
	parameter C_S_AXIS_TUSER_WIDTH = 128,
	// Master
	parameter C_M_AXIS_DATA_WIDTH = 256,
	// self-defined
	parameter PHV_ADDR_WIDTH = 4
)();

integer i;
reg                                     clk;
reg                                     aresetn;

reg [C_S_AXIS_DATA_WIDTH-1:0]           s_axis_tdata;
reg [((C_S_AXIS_DATA_WIDTH/8))-1:0]     s_axis_tkeep;
reg [C_S_AXIS_TUSER_WIDTH-1:0]          s_axis_tuser;
reg                                     s_axis_tvalid;
wire                                    s_axis_tready;
reg                                     s_axis_tlast;

wire [C_S_AXIS_DATA_WIDTH-1:0]          m_axis_tdata;
wire [((C_S_AXIS_DATA_WIDTH/8))-1:0]    m_axis_tkeep;
wire [C_S_AXIS_TUSER_WIDTH-1:0]         m_axis_tuser;
wire                                    m_axis_tvalid;
reg                                     m_axis_tready;
wire                                    m_axis_tlast;

reg  [31:0]                             reg_int_01;
reg  [31:0]                             reg_int_02;
reg  [31:0]                             reg_int_03;

initial begin
    #100;
    reg_int_01 = 32'hdddd_dddd;
    reg_int_02 = 32'heeee_eeee;
    reg_int_03 = 32'hffff_ffff;    
end

assign s_axis_tready = 1'b1;

//clk signal
localparam CYCLE = 10;

always begin
    clk = 1'b0;
    forever #(CYCLE/2) clk = ~clk;
end

//reset signal
initial begin
    aresetn = 1'b0;
    #(100);
    aresetn = 1'b1;
end

initial begin
    //init value
    m_axis_tready <= 1'b1;
    s_axis_tdata <= 256'b0; 
    s_axis_tkeep <= 32'h0;
    s_axis_tuser <= 128'h0;
    s_axis_tvalid <= 1'b0;
    s_axis_tlast <= 1'b0;
    
    wait(aresetn == 1'b1)
// /////////////parser config////////////////////////////////////     
    #(50*CYCLE);
        s_axis_tdata <= {16'h6f6f,16'b0,8'h11,72'h0,16'h0008,128'h0};
        s_axis_tvalid <= 1'b1;
        s_axis_tkeep <= 32'hffffffff;
        s_axis_tuser <= 128'b0;
        s_axis_tlast <= 1'b0;
    #(CYCLE) //test
        s_axis_tdata <= 256'b0;
        s_axis_tvalid <= 1'b0;
        s_axis_tkeep <= 32'h0;
        s_axis_tuser <= 128'b0;
        s_axis_tlast <= 1'b0;       
    #(CYCLE)
        s_axis_tdata <= {120'b0,8'b0000_0001/*index*/,8'b0,5'b00000/*stage*/,3'b000/*mod_id*/,24'b0,8'h4f,16'hf2f1/*control_flag*/,16'b0,48'hdededede6f6f};
        s_axis_tvalid <= 1'b1;
        s_axis_tkeep <= 32'hffffffff;
        s_axis_tuser <= 128'b0;
        s_axis_tlast <= 1'b0;
    #(CYCLE) //test
        s_axis_tdata <= 256'b0;
        s_axis_tvalid <= 1'b0;
        s_axis_tkeep <= 32'h0;
        s_axis_tuser <= 128'b0;
        s_axis_tlast <= 1'b0;        
    #(CYCLE)
        s_axis_tdata <= {
//         16'b0110_1111_1001_0111,//46B 8B[7] zhongpeiipv6 here to 8B[7]
//        16'b0110_1101_1001_1011,//54B 8B[6] zhongpeiipv6 here to 8B[6]
         16'b0110_0111_1001_1001,//50B 8B[3] zhongpeiipv6 here 
        16'b0110_0101_1001_0101,//42B 8B[2] zhongpeiipv6 here 
        16'b0100_0011_1000_1111,//xiangyu 4B[1] from 30B in PACKET
        208'b0
        };
        s_axis_tvalid <= 1'b1;
        s_axis_tkeep <= 32'hffffffff;
        s_axis_tuser <= 128'b0;
        s_axis_tlast <= 1'b0;
    #(CYCLE) //test
        s_axis_tdata <= 256'b0;
        s_axis_tvalid <= 1'b0;
        s_axis_tkeep <= 32'h0;
        s_axis_tuser <= 128'b0;
        s_axis_tlast <= 1'b0;        
    #(CYCLE)
        s_axis_tdata <= 256'b0;
        s_axis_tvalid <= 1'b1;
        s_axis_tkeep <= 32'hffffffff;
        s_axis_tuser <= 128'b0;
        s_axis_tlast <= 1'b0;
    #(CYCLE) //test
        s_axis_tdata <= 256'b0;
        s_axis_tvalid <= 1'b0;
        s_axis_tkeep <= 32'h0;
        s_axis_tuser <= 128'b0;
        s_axis_tlast <= 1'b0;         
    #(CYCLE)
        s_axis_tdata <= 256'heeeeeeeeeeeeeeeeeeeeeee;
        s_axis_tvalid <= 1'b1;
        s_axis_tkeep <= 32'hffffffff;
        s_axis_tuser <= 128'b0;
        s_axis_tlast <= 1'b1;
    #(CYCLE)
        s_axis_tdata <= 256'b0;
        s_axis_tvalid <= 1'b0;
        s_axis_tkeep <= 32'h0;
        s_axis_tuser <= 128'b0;
        s_axis_tlast <= 1'b0;
    
//////////deparser/////////////////////
    #(50*CYCLE)
        s_axis_tdata <= {16'h6f6f,16'b0,8'h11,72'h0,16'h0008,128'h0};
        s_axis_tvalid <= 1'b1;
        s_axis_tkeep <= 32'hffffffff;
        s_axis_tuser <= 128'b0;
        s_axis_tlast <= 1'b0;
    #(CYCLE)
        s_axis_tdata <= {120'b0,8'b0000_0001/*index*/,8'b0,5'b00000/*stage*/,3'b101/*mod_id*/,24'b0,8'h4f,16'hf2f1/*control_flag*/,16'b0,48'hdededede6f6f};
        s_axis_tvalid <= 1'b1;
        s_axis_tkeep <= 32'hffffffff;
        s_axis_tuser <= 128'b0;
        s_axis_tlast <= 1'b0;
    #(CYCLE)
        s_axis_tdata <= {16'b0100_0011_1000_1111,
        16'd0,
        16'd0,
        16'd0,
        16'b0100_1101_1001_1100,
        16'b0100_1011_1001_1010,
        176'b0};
        s_axis_tvalid <= 1'b1;
        s_axis_tkeep <= 32'hffffffff;
        s_axis_tuser <= 128'b0;
        s_axis_tlast <= 1'b0;
    #(CYCLE)
        s_axis_tdata <= 256'b0;
        s_axis_tvalid <= 1'b1;
        s_axis_tkeep <= 32'hffffffff;
        s_axis_tuser <= 128'b0;
        s_axis_tlast <= 1'b0;
    #(CYCLE)
        s_axis_tdata <= {256'heeeeeeeeeeeeeeeeeeeeeee};
        s_axis_tvalid <= 1'b1;
        s_axis_tkeep <= 32'hffffffff;
        s_axis_tuser <= 128'b0;
        s_axis_tlast <= 1'b1;
    #(CYCLE)
        s_axis_tdata <= {
        256'b0};
        s_axis_tvalid <= 1'b0;
        s_axis_tkeep <= 32'h0;
        s_axis_tuser <= 128'b0;
        s_axis_tlast <= 1'b0;
    
    
////////////////////////////ker_extract off_set//////////////////////////
    #(50*CYCLE)
        s_axis_tdata <= {16'h6f6f,16'b0,8'h11,72'h0,16'h0008,128'h0};
        s_axis_tvalid <= 1'b1;
        s_axis_tkeep <= 32'hffffffff;
        s_axis_tuser <= 128'b0;
        s_axis_tlast <= 1'b0;
    #(CYCLE)
        s_axis_tdata <= {120'b0,8'b0000_0000/*index*/,4'b0/*resv*/,4'b0,5'b00000/*stage*/,3'b001/*mod_id*/,24'b0,8'h4f,16'hf2f1/*control_flag*/,16'b0,48'hdededede6f6f};
        s_axis_tvalid <= 1'b1;
        s_axis_tkeep <= 32'hffffffff;
        s_axis_tuser <= 128'b0;
        s_axis_tlast <= 1'b0;
    #(CYCLE)
        s_axis_tdata <= 256'b0;
        s_axis_tvalid <= 1'b1;
        s_axis_tkeep <= 32'hffffffff;
        s_axis_tuser <= 128'b0;
        s_axis_tlast <= 1'b1;
    #(CYCLE)
        s_axis_tdata <= {16'habbb,240'b0};
        s_axis_tvalid <= 1'b0;
        s_axis_tkeep <= 32'hffffffff;
        s_axis_tuser <= 128'b0;
        s_axis_tlast <= 1'b0;
        
        
        

////////////////////////////ker_extract mask//////////////////////////
    #(50*CYCLE)
        s_axis_tdata <= {16'h6f6f,16'b0,8'h11,72'h0,16'h0008,128'h0};
        s_axis_tvalid <= 1'b1;
        s_axis_tkeep <= 32'hffffffff;
        s_axis_tuser <= 128'b0;
        s_axis_tlast <= 1'b0;
    #(CYCLE)
        s_axis_tdata <= {120'b0,8'b0000_0000/*index*/,4'b1/*resv*/,4'b0,5'b00000/*stage*/,3'b001/*mod_id*/,24'b0,8'h4f,16'hf2f1/*control_flag*/,16'b0,48'hdededede6f6f};
        s_axis_tvalid <= 1'b1;
        s_axis_tkeep <= 32'hffffffff;
        s_axis_tuser <= 128'b0;
        s_axis_tlast <= 1'b0;
    #(CYCLE)
        s_axis_tdata <= {128'hffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff,16'h0000,112'hffffffffffffffffffffffffffff};
        s_axis_tvalid <= 1'b1;
        s_axis_tkeep <= 32'hffffffff;
        s_axis_tuser <= 128'b0;
        s_axis_tlast <= 1'b1;
    #(CYCLE)
        s_axis_tdata <= {16'habbb,240'b0};
        s_axis_tvalid <= 1'b0;
        s_axis_tkeep <= 32'hffffffff;
        s_axis_tuser <= 128'b0;
        s_axis_tlast <= 1'b0;
        
        
/////////////////lookup_tcam////////////////
    #(50*CYCLE)
        s_axis_tdata <= {16'h6f6f,16'b0,8'h11,72'h0,16'h0008,128'h0};
        s_axis_tvalid <= 1'b1;
        s_axis_tkeep <= 32'hffffffff;
        s_axis_tuser <= 128'b0;
        s_axis_tlast <= 1'b0;
    #(CYCLE)
        s_axis_tdata <= {120'b0,8'b0000_0000/*index*/,4'b0/*resv*/,4'b0,5'b00000/*stage*/,3'b010/*mod_id*/,24'b0,8'h4f,16'hf2f1/*control_flag*/,16'b0,48'hdededede6f6f};
        s_axis_tvalid <= 1'b1;
        s_axis_tkeep <= 32'hffffffff;
        s_axis_tuser <= 128'b0;
        s_axis_tlast <= 1'b0;
    #(CYCLE)
        s_axis_tdata <= 256'b0;
        s_axis_tvalid <= 1'b1;
        s_axis_tkeep <= 32'hffffffff;
        s_axis_tuser <= 128'b0;
        s_axis_tlast <= 1'b1;
    #(CYCLE)
        s_axis_tdata <= {16'habbb,240'b0};
        s_axis_tvalid <= 1'b0;
        s_axis_tkeep <= 32'hffffffff;
        s_axis_tuser <= 128'b0;
        s_axis_tlast <= 1'b0;
 
 
        
 /////////////////looup_action/////////////////
    #(20*CYCLE)     
        s_axis_tdata <= {16'h6f6f,16'b0,8'h11,72'h0,16'h0008,128'h0};
        s_axis_tvalid <= 1'b1;
        s_axis_tkeep <= 32'hffffffff;
        s_axis_tuser <= 128'b0;
        s_axis_tlast <= 1'b0;
    #(CYCLE)
        s_axis_tdata <= {120'b0,8'b0000_0000/*index*/,4'b1/*resv*/,4'b0,5'b00000/*stage*/,3'b010/*mod_id*/,24'b0,8'h4f,16'hf2f1/*control_flag*/,16'b0,48'hdededede6f6f};
        s_axis_tvalid <= 1'b1;
        s_axis_tkeep <= 32'hffffffff;
        s_axis_tuser <= 128'b0;
        s_axis_tlast <= 1'b0;
    #(CYCLE)
        s_axis_tdata <= 256'b0;
        s_axis_tvalid <= 1'b1;
        s_axis_tkeep <= 32'hffffffff;
        s_axis_tuser <= 128'b0;
        s_axis_tlast <= 1'b0;
    #(CYCLE)
        s_axis_tdata <= 256'b0;
        s_axis_tvalid <= 1'b1;
        s_axis_tkeep <= 32'hffffffff;
        s_axis_tuser <= 128'b0;
        s_axis_tlast <= 1'b0;
    #(CYCLE)
        s_axis_tdata <= {
        //256'b0,
        32'd0,
        32'd0,
        32'd0,
        32'd0, 
        32'b0010_1000_0000_0000_0010_0000_0000_0011, //4B[7] yh,load
        32'b0001_1000_0000_0000_0010_0000_0000_0011, //4B[6],yh,load
        //32'b0000_0011_0010_0000_0000_0000_0000_1000, //4B[5]
        32'b0000_1000_0000_0000_0010_0000_0000_0011, //4B[5] yh,load 
        32'd0  //4B[4]
        };
        s_axis_tvalid <= 1'b1;
        s_axis_tkeep <= 32'hffffffff;
        s_axis_tuser <= 128'b0;
        s_axis_tlast <= 1'b0;
    #(CYCLE)
        s_axis_tdata <= {
        32'd0,//4B[3]
        32'd0,//4B[2]
        32'b000000000001_00101_000_00000_0010011,//4B[1]
        32'd0,//4B[0]
        32'd0,//2B[3]
        32'd0,//2B[2]
        32'd0,//2B[1]
        32'd0//2B[0]
        };
        s_axis_tvalid <= 1'b1;
        s_axis_tkeep <= 32'hffffffff;
        s_axis_tuser <= 128'b0;
        s_axis_tlast <= 1'b0;
    #(CYCLE)
        s_axis_tdata <= 256'b0;
        s_axis_tvalid <= 1'b1;
        s_axis_tkeep <= 32'hffffffff;
        s_axis_tuser <= 128'b0;
        s_axis_tlast <= 1'b1;
    #(CYCLE)
        s_axis_tdata <= 256'b0;
        s_axis_tvalid <= 1'b0;
        s_axis_tkeep <= 32'hffffffff;
        s_axis_tuser <= 128'b0;
        s_axis_tlast <= 1'b0;

//**********************here is the ctrl_packet for zhongpei cu***********************
    #(100*CYCLE); 
    //stage 0
    #CYCLE;
    s_axis_tdata <= {16'h6f6f,16'b0,8'h11,72'h0,16'h0008,128'h0};
    s_axis_tvalid <= 1'b1;
    s_axis_tkeep <= 64'hffffffffffffffff;
    s_axis_tuser <= 128'b0;
    s_axis_tlast <= 1'b0;
    #(CYCLE)
    s_axis_tdata <= {120'b0,8'b0000_0000/*index*/,8'b0,5'b00000/*stage*/,3'b111/*mod_id*/,24'b0,8'h4f,16'hf2f1/*control_flag*/,16'b0,48'hdededede6f6f};
    s_axis_tvalid <= 1'b1;
    s_axis_tkeep <= 64'hffffffffffffffff;
    s_axis_tuser <= 128'b0;
    s_axis_tlast <= 1'b0;
    //32X4个256
    #(CYCLE)
    s_axis_tdata <= {248'b0,8'd1};
    s_axis_tvalid <= 1'b1;
    s_axis_tkeep <= 64'hffffffffffffffff;
    s_axis_tuser <= 128'b0;
    s_axis_tlast <= 1'b0;
    for (i = 0;i<30 ;i=i+1 ) begin
        #(CYCLE)
        s_axis_tdata <= {256'b0};
        s_axis_tvalid <= 1'b1;
        s_axis_tkeep <= 64'hffffffffffffffff;
        s_axis_tuser <= 128'b0;
        s_axis_tlast <= 1'b0;
    end
    #(CYCLE)
    s_axis_tdata <= {256'b0};
    s_axis_tvalid <= 1'b1;
    s_axis_tkeep <= 64'hffffffffffffffff;
    s_axis_tuser <= 128'b0;
    s_axis_tlast <= 1'b1;
    #(CYCLE)
    s_axis_tdata <= 0;
    s_axis_tvalid <= 0;
    s_axis_tkeep <= 64'hffffffffffffffff;
    s_axis_tuser <= 128'b0;
    s_axis_tlast <= 1'b0;
//stage 1
    #CYCLE;
    s_axis_tdata <= {16'h6f6f,16'b0,8'h11,72'h0,16'h0008,128'h0};
    s_axis_tvalid <= 1'b1;
    s_axis_tkeep <= 64'hffffffffffffffff;
    s_axis_tuser <= 128'b0;
    s_axis_tlast <= 1'b0;
    #(CYCLE)
    s_axis_tdata <= {120'b0,8'b0000_0001/*index*/,8'b0,5'b00000/*stage*/,3'b111/*mod_id*/,24'b0,8'h4f,16'hf2f1/*control_flag*/,16'b0,48'hdededede6f6f};
    s_axis_tvalid <= 1'b1;
    s_axis_tkeep <= 64'hffffffffffffffff;
    s_axis_tuser <= 128'b0;
    s_axis_tlast <= 1'b0;
    //32X4个256
    #(CYCLE)
    s_axis_tdata <= {255'b0,1'b1};
    s_axis_tvalid <= 1'b1;
    s_axis_tkeep <= 64'hffffffffffffffff;
    s_axis_tuser <= 128'b0;
    s_axis_tlast <= 1'b0;
    for (i = 0;i<30 ;i=i+1 ) begin
        #(CYCLE)
        s_axis_tdata <= {256'b0};
        s_axis_tvalid <= 1'b1;
        s_axis_tkeep <= 64'hffffffffffffffff;
        s_axis_tuser <= 128'b0;
        s_axis_tlast <= 1'b0;
    end
    #(CYCLE)
    s_axis_tdata <= {256'b0};
    s_axis_tvalid <= 1'b1;
    s_axis_tkeep <= 64'hffffffffffffffff;
    s_axis_tuser <= 128'b0;
    s_axis_tlast <= 1'b1;
    #(CYCLE)
    s_axis_tdata <= 0;
    s_axis_tvalid <= 0;
    s_axis_tkeep <= 64'hffffffffffffffff;
    s_axis_tuser <= 128'b0;
    s_axis_tlast <= 1'b0;  
//stage 2
    #CYCLE;
    s_axis_tdata <= {16'h6f6f,16'b0,8'h11,72'h0,16'h0008,128'h0};
    s_axis_tvalid <= 1'b1;
    s_axis_tkeep <= 64'hffffffffffffffff;
    s_axis_tuser <= 128'b0;
    s_axis_tlast <= 1'b0;
    #(CYCLE)
    s_axis_tdata <= {120'b0,8'b0000_0010/*index*/,8'b0,5'b00000/*stage*/,3'b111/*mod_id*/,24'b0,8'h4f,16'hf2f1/*control_flag*/,16'b0,48'hdededede6f6f};
    s_axis_tvalid <= 1'b1;
    s_axis_tkeep <= 64'hffffffffffffffff;
    s_axis_tuser <= 128'b0;
    s_axis_tlast <= 1'b0;
    //32X4个256
    #(CYCLE)
    s_axis_tdata <= {255'b0,1'b1};
    s_axis_tvalid <= 1'b1;
    s_axis_tkeep <= 64'hffffffffffffffff;
    s_axis_tuser <= 128'b0;
    s_axis_tlast <= 1'b0;
    for (i = 0;i<30 ;i=i+1 ) begin
        #(CYCLE)
        s_axis_tdata <= {256'b0};
        s_axis_tvalid <= 1'b1;
        s_axis_tkeep <= 64'hffffffffffffffff;
        s_axis_tuser <= 128'b0;
        s_axis_tlast <= 1'b0;
    end
    #(CYCLE)
    s_axis_tdata <= {256'b0};
    s_axis_tvalid <= 1'b1;
    s_axis_tkeep <= 64'hffffffffffffffff;
    s_axis_tuser <= 128'b0;
    s_axis_tlast <= 1'b1;
    #(CYCLE)
    s_axis_tdata <= 0;
    s_axis_tvalid <= 0;
    s_axis_tkeep <= 64'hffffffffffffffff;
    s_axis_tuser <= 128'b0;
    s_axis_tlast <= 1'b0;
//stage 3
    #CYCLE;
    s_axis_tdata <= {16'h6f6f,16'b0,8'h11,72'h0,16'h0008,128'h0};
    s_axis_tvalid <= 1'b1;
    s_axis_tkeep <= 64'hffffffffffffffff;
    s_axis_tuser <= 128'b0;
    s_axis_tlast <= 1'b0;
    #(CYCLE)
    s_axis_tdata <= {120'b0,8'b0000_0011/*index*/,8'b0,5'b00000/*stage*/,3'b111/*mod_id*/,24'b0,8'h4f,16'hf2f1/*control_flag*/,16'b0,48'hdededede6f6f};
    s_axis_tvalid <= 1'b1;
    s_axis_tkeep <= 64'hffffffffffffffff;
    s_axis_tuser <= 128'b0;
    s_axis_tlast <= 1'b0;
    //32X4个256
    #(CYCLE)
    s_axis_tdata <= {255'b0,1'b1};
    s_axis_tvalid <= 1'b1;
    s_axis_tkeep <= 64'hffffffffffffffff;
    s_axis_tuser <= 128'b0;
    s_axis_tlast <= 1'b0;
    for (i = 0;i<30 ;i=i+1 ) begin
        #(CYCLE)
        s_axis_tdata <= {256'b0};
        s_axis_tvalid <= 1'b1;
        s_axis_tkeep <= 64'hffffffffffffffff;
        s_axis_tuser <= 128'b0;
        s_axis_tlast <= 1'b0;
    end
    #(CYCLE)
    s_axis_tdata <= {256'b0};
    s_axis_tvalid <= 1'b1;
    s_axis_tkeep <= 64'hffffffffffffffff;
    s_axis_tuser <= 128'b0;
    s_axis_tlast <= 1'b1;
    #(CYCLE)
    s_axis_tdata <= 0;
    s_axis_tvalid <= 0;
    s_axis_tkeep <= 64'hffffffffffffffff;
    s_axis_tuser <= 128'b0;
    s_axis_tlast <= 1'b0;
//////////weights_manager_bias////////////////////////////////////  
    #CYCLE;
    s_axis_tdata <= {16'h6f6f,16'b0,8'h11,72'h0,16'h0008,128'h0};
    s_axis_tvalid <= 1'b1;
    s_axis_tkeep <= 64'hffffffffffffffff;
    s_axis_tuser <= 128'b0;
    s_axis_tlast <= 1'b0;
    #(CYCLE)
    s_axis_tdata <= {120'b0,8'b0000_0100/*index*/,8'b0,5'b00000/*stage*/,3'b111/*mod_id*/,24'b0,8'h4f,16'hf2f1/*control_flag*/,16'b0,48'hdededede6f6f};
    s_axis_tvalid <= 1'b1;
    s_axis_tkeep <= 64'hffffffffffffffff;
    s_axis_tuser <= 128'b0;
    s_axis_tlast <= 1'b0;
    //4个256
    #(CYCLE)
    s_axis_tdata <= {248'b0,8'd1};
    s_axis_tvalid <= 1'b1;
    s_axis_tkeep <= 64'hffffffffffffffff;
    s_axis_tuser <= 128'b0;
    s_axis_tlast <= 1'b1;

    #(CYCLE)
    s_axis_tdata <= 256'b0;
    s_axis_tvalid <= 1'b0;
    s_axis_tkeep <= 64'h0;
    s_axis_tuser <= 128'b0;
    s_axis_tlast <= 1'b0;
    #(10*CYCLE) 
    
    
//////////////foure data packets second que///////////////
//    #(100*CYCLE);   
//        s_axis_tdata <= {16'h1234,16'b0,8'h11,72'h0,16'h0008,117'h0};
//        s_axis_tuser <= {60'b0,68'hfffffffffffffffff};
//        s_axis_tkeep <= 32'hffffffff;
//        s_axis_tvalid <= 1'b1;
//        s_axis_tlast <= 1'b0;
//    #(CYCLE)
//        s_axis_tdata <= {80'b0,8'd1,120'b0,48'hdededede5678};
//        s_axis_tuser <= 128'b0;
//        s_axis_tkeep <= 32'hffffffff;
//        s_axis_tvalid <= 1'b1;
//        s_axis_tlast <= 1'b0;
//    #(CYCLE)
//        s_axis_tdata <= {8'h01,248'h0};
//        s_axis_tuser <= {115'b0,12'b0000_0000_0000,1'b0};
//        s_axis_tkeep <= 32'hffffffff;
//        s_axis_tvalid <= 1'b1;
//        s_axis_tlast <= 1'b0;
//    #(CYCLE)
//        s_axis_tdata <= {8'h02,248'h0};
//        s_axis_tuser <= 128'hfffffffffffffffff;
//        s_axis_tkeep <= 32'hffffffff;
//        s_axis_tvalid <= 1'b1;
//        s_axis_tlast <= 1'b1;
//    #(CYCLE)
//        s_axis_tdata <= {64'hffff_ffff_ffff_ffff,64'b1,12'b0000_0001_0000,116'b0};
//        s_axis_tuser <= 128'b0;
//        s_axis_tkeep <= 32'hffffffff;
//        s_axis_tvalid <= 1'b0;
//        s_axis_tlast <= 1'b0;
    
//////////////foure data packets third que///////////////
//    #(100*CYCLE);   
//        s_axis_tdata <= {16'h7654,16'b0,8'h11,72'h0,16'h0008,12'h1,116'h0};
//        s_axis_tuser <= {60'b0,68'hfffffffffffffffff};
//        s_axis_tkeep <= 32'hffffffff;
//        s_axis_tvalid <= 1'b1;
//        s_axis_tlast <= 1'b0;
//    #(CYCLE)
//        s_axis_tdata <= {120'b0,8'b0000_0000/*index*/,4'b0/*resv*/,4'b0,5'b00000/*stage*/,3'b000/*mod_id*/,24'b0,8'h4f,16'h0000/*control_flag*/,16'b0,48'hdededede1234};
//        s_axis_tuser <= 128'b0;
//        s_axis_tkeep <= 32'hffffffff;
//        s_axis_tvalid <= 1'b1;
//        s_axis_tlast <= 1'b0;
//    #(CYCLE)
//        s_axis_tdata <= {8'h01,248'h0};
//        s_axis_tuser <= {115'b0,12'b0000_0000_0000,1'b0};
//        s_axis_tkeep <= 32'hffffffff;
//        s_axis_tvalid <= 1'b1;
//        s_axis_tlast <= 1'b0;
//    #(CYCLE)
//        s_axis_tdata <= {8'h02,248'h0};
//        s_axis_tuser <= 128'hfffffffffffffffff;
//        s_axis_tkeep <= 32'hffffffff;
//        s_axis_tvalid <= 1'b1;
//        s_axis_tlast <= 1'b1;
//    #(CYCLE)
//        s_axis_tdata <= {64'hffff_ffff_ffff_ffff,64'b1,12'b0000_0001_0000,116'b0};
//        s_axis_tuser <= 128'b0;
//        s_axis_tkeep <= 32'hffffffff;
//        s_axis_tvalid <= 1'b0;
//        s_axis_tlast <= 1'b0;

#(40*CYCLE);   
    
    //s_axis_tdata <= {56'h0,8'h11,48'h0,16'hdd86,12'd16,116'h0};//32B-1B 00 00 00 00 00 00 00 11 00 00 00 00 00 00 86 dd 00 0f 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                                           
    s_axis_tdata <= {16'h1234,40'h0,8'h11,48'h0,16'hdd86,12'd16,116'd0};
    s_axis_tuser <= {128'd0};
    s_axis_tkeep <= 64'hffffffffffffffff;
    s_axis_tvalid <= 1'b1;
    s_axis_tlast <= 1'b0;
    #(CYCLE)
    s_axis_tdata <= {48'd0,8'd1,56'd0,64'd0,80'b0};//31+16=47B+8B=55B //64B-32B// 00 00 00 00 00 00 00 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    s_axis_tuser <= 128'd0;
    s_axis_tkeep <= 64'hffffffffffffffff;
    s_axis_tvalid <= 1'b1;
    s_axis_tlast <= 1'b0;
    #(CYCLE)
    s_axis_tdata <= {8'h01,248'h0};  //
    s_axis_tuser <= {115'b0,12'b0000_0000_0000,1'b0};
    s_axis_tkeep <= 64'hffffffffffffffff;
    s_axis_tvalid <= 1'b1;
    s_axis_tlast <= 1'b0;
    #(CYCLE)
    s_axis_tdata <= {8'h02,248'h0};
    s_axis_tuser <= 128'hfffffffffffffffff;
    s_axis_tkeep <= 64'hffffffffffffffff;
    s_axis_tvalid <= 1'b1;
    s_axis_tlast <= 1'b1;
    #(CYCLE)
    s_axis_tdata <= {64'hffff_ffff_ffff_ffff,64'b1,12'b0000_0001_0000,116'b0};
    s_axis_tuser <= 128'b0;
    s_axis_tkeep <= 64'hffffffffffffffff;
    s_axis_tvalid <= 1'b0;
    s_axis_tlast <= 1'b0; 
     #(10*CYCLE);




////config 2 xp5


// /////////////parser config////////////////////////////////////     
//    #(50*CYCLE+CYCLE/2);
//        s_axis_tdata <= 256'h6f6fbc4c_11_4000001a858e0000450008ff0000_8100_454d555302888888888888;
//        //VLAN HEAD 8100 
//        //UDP 11
//        s_axis_tvalid <= 1'b1;
//        s_axis_tkeep <= 32'hffffffff;
//        s_axis_tuser <= 128'b0;
//        s_axis_tlast <= 1'b0;
//    #(CYCLE) //test
//        s_axis_tdata <= 256'b0;
//        s_axis_tvalid <= 1'b0;
//        s_axis_tkeep <= 32'h0;
//        s_axis_tuser <= 128'b0;
//        s_axis_tlast <= 1'b0;       
//    #(CYCLE)
//        s_axis_tdata <= 256'h000000000000000000000000000000_02_000000007a00_f2f1_3412dededede6f6f;
//        //CONTROL PKT TAG : f1f2
//        //VALN ID : 02
//        s_axis_tvalid <= 1'b1;
//        s_axis_tkeep <= 32'hffffffff;
//        s_axis_tuser <= 128'b0;
//        s_axis_tlast <= 1'b0;
//    #(CYCLE) //test
//        s_axis_tdata <= 256'b0;
//        s_axis_tvalid <= 1'b0;
//        s_axis_tkeep <= 32'h0;
//        s_axis_tuser <= 128'b0;
//        s_axis_tlast <= 1'b0;        
//    #(CYCLE)
//        s_axis_tdata <= 256'h0000_0000_0000_0000_0000_0000_0000_2188_418d_2793_6198_258c_4591_438f_238b_6783;
//        //16����ȡ��  parser_action[15]       >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>            parser_action[0]
//        s_axis_tvalid <= 1'b1;
//        s_axis_tkeep <= 32'hffffffff;
//        s_axis_tuser <= 128'b0;
//        s_axis_tlast <= 1'b0;
//    #(CYCLE) //test
//        s_axis_tdata <= 256'b0;
//        s_axis_tvalid <= 1'b0;
//        s_axis_tkeep <= 32'h0;
//        s_axis_tuser <= 128'b0;
//        s_axis_tlast <= 1'b0;        
//    #(CYCLE)
//        s_axis_tdata <= 256'h0000000000000000000000000000_00000_00000_00000_00000_0000_0000_0000_0000;
//        //4����ȡ�� + 5*20 condition
//        s_axis_tvalid <= 1'b1;
//        s_axis_tkeep <= 32'hffffffff;
//        s_axis_tuser <= 128'b0;
//        s_axis_tlast <= 1'b0;
//    #(CYCLE) //test
//        s_axis_tdata <= 256'b0;
//        s_axis_tvalid <= 1'b0;
//        s_axis_tkeep <= 32'h0;
//        s_axis_tuser <= 128'b0;
//        s_axis_tlast <= 1'b0;         
//    #(CYCLE)
//        s_axis_tdata <= 256'hffff;
//        s_axis_tvalid <= 1'b1;
//        s_axis_tkeep <= 32'hffffffff;
//        s_axis_tuser <= 128'b0;
//        s_axis_tlast <= 1'b1;
//    #(CYCLE)
//        s_axis_tdata <= 256'b0;
//        s_axis_tvalid <= 1'b0;
//        s_axis_tkeep <= 32'h0;
//        s_axis_tuser <= 128'b0;
//        s_axis_tlast <= 1'b0;
    
////////////deparser/////////////////////
//    #(50*CYCLE)
//        s_axis_tdata <= 256'h6f6fbc4c114000001a858e0000450008ff00008100454d555302888888888888;
//        s_axis_tvalid <= 1'b1;
//        s_axis_tkeep <= 32'hffffffff;
//        s_axis_tuser <= 128'b0;
//        s_axis_tlast <= 1'b0;
//    #(CYCLE) //test
//        s_axis_tdata <= 256'b0;
//        s_axis_tvalid <= 1'b0;
//        s_axis_tkeep <= 32'h0;
//        s_axis_tuser <= 128'b0;
//        s_axis_tlast <= 1'b0;         
//    #(CYCLE)
//        s_axis_tdata <= 256'h00000000000000000000000000000002000500007a00f2f13412dededede6f6f;
//        s_axis_tvalid <= 1'b1;
//        s_axis_tkeep <= 32'hffffffff;
//        s_axis_tuser <= 128'b0;
//        s_axis_tlast <= 1'b0;
//    #(CYCLE) //test
//        s_axis_tdata <= 256'b0;
//        s_axis_tvalid <= 1'b0;
//        s_axis_tkeep <= 32'h0;
//        s_axis_tuser <= 128'b0;
//        s_axis_tlast <= 1'b0;         
//    #(CYCLE)
//        s_axis_tdata <= 256'h00000000000000000000000000002188418d27936198258c4591438f238b6783;
//        s_axis_tvalid <= 1'b1;
//        s_axis_tkeep <= 32'hffffffff;
//        s_axis_tuser <= 128'b0;
//        s_axis_tlast <= 1'b0;
//    #(CYCLE) //test
//        s_axis_tdata <= 256'b0;
//        s_axis_tvalid <= 1'b0;
//        s_axis_tkeep <= 32'h0;
//        s_axis_tuser <= 128'b0;
//        s_axis_tlast <= 1'b0;         
//    #(CYCLE)
//        s_axis_tdata <= 256'b0;
//        s_axis_tvalid <= 1'b1;
//        s_axis_tkeep <= 32'hffffffff;
//        s_axis_tuser <= 128'b0;
//        s_axis_tlast <= 1'b0;
//    #(CYCLE) //test
//        s_axis_tdata <= 256'b0;
//        s_axis_tvalid <= 1'b0;
//        s_axis_tkeep <= 32'h0;
//        s_axis_tuser <= 128'b0;
//        s_axis_tlast <= 1'b0;         
//    #(CYCLE)
//        s_axis_tdata <= 256'h0;
//        s_axis_tvalid <= 1'b1;
//        s_axis_tkeep <= 32'hffffffff;
//        s_axis_tuser <= 128'b0;
//        s_axis_tlast <= 1'b1;
//    #(CYCLE)
//        s_axis_tdata <= 256'b0;
//        s_axis_tvalid <= 1'b0;
//        s_axis_tkeep <= 32'h0;
//        s_axis_tuser <= 128'b0;
//        s_axis_tlast <= 1'b0;
    
    
//////////////////////////////ker_extract off_set//////////////////////////
//    #(50*CYCLE)
//        s_axis_tdata <= 256'h6f6fbc4c114000001a85310000450008ff00008100454d555302888888888888;
//        s_axis_tvalid <= 1'b1;
//        s_axis_tkeep <= 32'hffffffff;
//        s_axis_tuser <= 128'b0;
//        s_axis_tlast <= 1'b0;
//    #(CYCLE) //test
//        s_axis_tdata <= 256'b0;
//        s_axis_tvalid <= 1'b0;
//        s_axis_tkeep <= 32'h0;
//        s_axis_tuser <= 128'b0;
//        s_axis_tlast <= 1'b0;        
//    #(CYCLE)
//        s_axis_tdata <= 256'h00000000000000000000000000000002000100001d00f2f13412dededede6f6f;
//        s_axis_tvalid <= 1'b1;
//        s_axis_tkeep <= 32'hffffffff;
//        s_axis_tuser <= 128'b0;
//        s_axis_tlast <= 1'b0;
//    #(CYCLE) //test
//        s_axis_tdata <= 256'b0;
//        s_axis_tvalid <= 1'b0;
//        s_axis_tkeep <= 32'h0;
//        s_axis_tuser <= 128'b0;
//        s_axis_tlast <= 1'b0;         
//    #(CYCLE)
//        s_axis_tdata <= 256'h0000000000000000000000000030103000000000000000000000000000_3_0_1_0_3_0;
//        //[23:20]:8B[0]  [19:16]:8B[1]  [15:12]:4B[0]   [11:8]:4B[1]  [7:4]:2B[0]   [3:0]:2B[1]
//        s_axis_tvalid <= 1'b1;
//        s_axis_tkeep <= 32'hffffffff;
//        s_axis_tuser <= 128'b0;
//        s_axis_tlast <= 1'b1;
//    #(CYCLE)
//        s_axis_tdata <= {16'habbb,240'b0};
//        s_axis_tvalid <= 1'b0;
//        s_axis_tkeep <= 32'hffffffff;
//        s_axis_tuser <= 128'b0;
//        s_axis_tlast <= 1'b0;
        
        
        

//////////////////////////////ker_extract mask//////////////////////////
//    #(50*CYCLE)
//        s_axis_tdata <= 256'h6f6fbc4c114000001a854e0000450008ff00008100454d555302888888888888;
//        s_axis_tvalid <= 1'b1;
//        s_axis_tkeep <= 32'hffffffff;
//        s_axis_tuser <= 128'b0;
//        s_axis_tlast <= 1'b0;
//    #(CYCLE) //test
//        s_axis_tdata <= 256'b0;
//        s_axis_tvalid <= 1'b0;
//        s_axis_tkeep <= 32'h0;
//        s_axis_tuser <= 128'b0;
//        s_axis_tlast <= 1'b0;         
//    #(CYCLE)
//        s_axis_tdata <= 256'h000000000000000000000000000000020f0100003a00f2f13412dededede6f6f;
//        s_axis_tvalid <= 1'b1;
//        s_axis_tkeep <= 32'hffffffff;
//        s_axis_tuser <= 128'b0;
//        s_axis_tlast <= 1'b0;
//    #(CYCLE) //test
//        s_axis_tdata <= 256'b0;
//        s_axis_tvalid <= 1'b0;
//        s_axis_tkeep <= 32'h0;
//        s_axis_tuser <= 128'b0;
//        s_axis_tlast <= 1'b0;         
//    #(CYCLE)
//        s_axis_tdata <= 256'h0000000000000000_ffffffffffffffff_00000000_ffffffff_0000_ffff_ff000000;
//        //0:care   1:don't care 229bit
//        s_axis_tvalid <= 1'b1;
//        s_axis_tkeep <= 32'hffffffff;
//        s_axis_tuser <= 128'b0;
//        s_axis_tlast <= 1'b1;
//    #(CYCLE)
//        s_axis_tdata <= {16'habbb,240'b0};
//        s_axis_tvalid <= 1'b0;
//        s_axis_tkeep <= 32'hffffffff;
//        s_axis_tuser <= 128'b0;
//        s_axis_tlast <= 1'b0;
        
        
///////////////////lookup_tcam////////////////
//    #(50*CYCLE)
//        s_axis_tdata <= 256'h6f6fbc4c114000001a854e0000450008ff00008100454d555302888888888888;
//        s_axis_tvalid <= 1'b1;
//        s_axis_tkeep <= 32'hffffffff;
//        s_axis_tuser <= 128'b0;
//        s_axis_tlast <= 1'b0;
//    #(CYCLE) //test
//        s_axis_tdata <= 256'b0;
//        s_axis_tvalid <= 1'b0;
//        s_axis_tkeep <= 32'h0;
//        s_axis_tuser <= 128'b0;
//        s_axis_tlast <= 1'b0;         
//    #(CYCLE)
//        s_axis_tdata <= 256'h00000000000000000000000000000007000200003a00f2f13412dededede6f6f;
//        s_axis_tvalid <= 1'b1;
//        s_axis_tkeep <= 32'hffffffff;
//        s_axis_tuser <= 128'b0;
//        s_axis_tlast <= 1'b0;
//    #(CYCLE) //test
//        s_axis_tdata <= 256'b0;
//        s_axis_tvalid <= 1'b0;
//        s_axis_tkeep <= 32'h0;
//        s_axis_tuser <= 128'b0;
//        s_axis_tlast <= 1'b0;        
//    #(CYCLE)
//        s_axis_tdata <= 256'h0081554433221100_0000000000000000_0801a8c0_00000000_3412_0000_00000000;
//        //8 8 4 4 2 2
//        s_axis_tvalid <= 1'b1;
//        s_axis_tkeep <= 32'hffffffff;
//        s_axis_tuser <= 128'b0;
//        s_axis_tlast <= 1'b1;
//    #(CYCLE)
//        s_axis_tdata <= {16'habbb,240'b0};
//        s_axis_tvalid <= 1'b0;
//        s_axis_tkeep <= 32'hffffffff;
//        s_axis_tuser <= 128'b0;
//        s_axis_tlast <= 1'b0;
 
 
        
// /////////////////looup_action/////////////////
//    #(50*CYCLE)     
//        s_axis_tdata <= 256'h6f6fbc4c114000001a85b20000450008ff00008100454d555302888888888888;
//        s_axis_tvalid <= 1'b1;
//        s_axis_tkeep <= 32'hffffffff;
//        s_axis_tuser <= 128'b0;
//        s_axis_tlast <= 1'b0;
//    #(CYCLE) //test
//        s_axis_tdata <= 256'b0;
//        s_axis_tvalid <= 1'b0;
//        s_axis_tkeep <= 32'h0;
//        s_axis_tuser <= 128'b0;
//        s_axis_tlast <= 1'b0;        
//    #(CYCLE)
//        s_axis_tdata <= 256'h000000000000000000000000000000070f0200009e00f2f13412dededede6f6f;
//        s_axis_tvalid <= 1'b1;
//        s_axis_tkeep <= 32'hffffffff;
//        s_axis_tuser <= 128'b0;
//        s_axis_tlast <= 1'b0;
//    #(CYCLE) //test
//        s_axis_tdata <= 256'b0;
//        s_axis_tvalid <= 1'b0;
//        s_axis_tkeep <= 32'h0;
//        s_axis_tuser <= 128'b0;
//        s_axis_tlast <= 1'b0;        
//    #(CYCLE)
//        s_axis_tdata <= 256'h00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000;
//        //8B[15] >>> 8B[8]
//        s_axis_tvalid <= 1'b1;
//        s_axis_tkeep <= 32'hffffffff;
//        s_axis_tuser <= 128'b0;
//        s_axis_tlast <= 1'b0;
//    #(CYCLE) //test
//        s_axis_tdata <= 256'b0;
//        s_axis_tvalid <= 1'b0;
//        s_axis_tkeep <= 32'h0;
//        s_axis_tuser <= 128'b0;
//        s_axis_tlast <= 1'b0;        
//    #(CYCLE)
//        s_axis_tdata <= 256'h00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000;
//        //8B[7] >>> 8B[0]
//        s_axis_tvalid <= 1'b1;
//        s_axis_tkeep <= 32'hffffffff;
//        s_axis_tuser <= 128'b0;
//        s_axis_tlast <= 1'b0;
//    #(CYCLE) //test
//        s_axis_tdata <= 256'b0;
//        s_axis_tvalid <= 1'b0;
//        s_axis_tkeep <= 32'h0;
//        s_axis_tuser <= 128'b0;
//        s_axis_tlast <= 1'b0;        
//    #(CYCLE)
//        s_axis_tdata <= 256'h00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000;
//        //4B[12]  >>>  4B[5]
//        s_axis_tvalid <= 1'b1;
//        s_axis_tkeep <= 32'hffffffff;
//        s_axis_tuser <= 128'b0;
//        s_axis_tlast <= 1'b0;
//    #(CYCLE) //test
//        s_axis_tdata <= 256'b0;
//        s_axis_tvalid <= 1'b0;
//        s_axis_tkeep <= 32'h0;
//        s_axis_tuser <= 128'b0;
//        s_axis_tlast <= 1'b0;         
//    #(CYCLE)
//        s_axis_tdata <= 256'h00000000_101e8013_00000000_00000000_00000000_fe9c8013_00000000_aaaa000b;//PORT
//        //4B[3] 4B[2] 4B[1] 4B[0] 2B[3] 2B[2] 2B[1] 2B[0] 
//        s_axis_tvalid <= 1'b1;
//        s_axis_tkeep <= 32'hffffffff;
//        s_axis_tuser <= 128'b0;
//        s_axis_tlast <= 1'b0;
//    #(CYCLE) //test
//        s_axis_tdata <= 256'b0;
//        s_axis_tvalid <= 1'b0;
//        s_axis_tkeep <= 32'h0;
//        s_axis_tuser <= 128'b0;
//        s_axis_tlast <= 1'b0;         
//    #(CYCLE)
//        s_axis_tdata <= 256'h000E7BEB_00000000000000000000000000000000000000000000000000000000;
//        //Metadata_op
//        s_axis_tvalid <= 1'b1;
//        s_axis_tkeep <= 32'hffffffff;
//        s_axis_tuser <= 128'b0;
//        s_axis_tlast <= 1'b1;
//    #(CYCLE)
//        s_axis_tdata <= 256'b0;
//        s_axis_tvalid <= 1'b0;
//        s_axis_tkeep <= 32'hffffffff;
//        s_axis_tuser <= 128'b0;
//        s_axis_tlast <= 1'b0;





///* ************************************************** */
///* send test pkt */
///* ************************************************** */
//    #(500*CYCLE)  
//        s_axis_tdata <= {16'ha8c0,64'hbc4c114000001a85,16'h4c00,16'h0045,16'h0008,16'h0200,16'h0081,48'h554433221100,48'h554433221100};
//        s_axis_tuser <= {60'b0,68'hfffffffffffffffff};
//        s_axis_tkeep <= 32'hffffffff;
//        s_axis_tvalid <= 1'b1;
//        s_axis_tlast <= 1'b0;
//    #(CYCLE) //test
//        s_axis_tdata <= 256'b0;
//        s_axis_tvalid <= 1'b0;
//        s_axis_tkeep <= 32'h0;
//        s_axis_tuser <= 128'b0;
//        s_axis_tlast <= 1'b0;         
//    #(CYCLE)
//        s_axis_tdata <= 256'h00000000000000000000000000000000000000000000_0000_3412_04030201_0801;
//        s_axis_tuser <= 128'b0;
//        s_axis_tkeep <= 32'hffffffff;
//        s_axis_tvalid <= 1'b1;
//        s_axis_tlast <= 1'b0;
//    #(CYCLE) //test
//        s_axis_tdata <= 256'b0;
//        s_axis_tvalid <= 1'b0;
//        s_axis_tkeep <= 32'h0;
//        s_axis_tuser <= 128'b0;
//        s_axis_tlast <= 1'b0;        
//    #(CYCLE)
//        s_axis_tdata <= 256'h000000000000000000000000000000008b00aaaaaaaaaaaa0000000000000000;
//        s_axis_tuser <= {115'b0,12'b0000_0000_0000,1'b0};
//        s_axis_tkeep <= 32'hffffffff;
//        s_axis_tvalid <= 1'b1;
//        s_axis_tlast <= 1'b0;
//    #(CYCLE) //test
//        s_axis_tdata <= 256'b0;
//        s_axis_tvalid <= 1'b0;
//        s_axis_tkeep <= 32'h0;
//        s_axis_tuser <= 128'b0;
//        s_axis_tlast <= 1'b0;        
//    #(CYCLE)
//        s_axis_tdata <= {8'h02,248'h0};
//        s_axis_tuser <= 128'hfffffffffffffffff;
//        s_axis_tkeep <= 32'hffffffff;
//        s_axis_tvalid <= 1'b1;
//        s_axis_tlast <= 1'b1;
//    #(CYCLE)
//        s_axis_tdata <= 256'h0;
//        s_axis_tuser <= 128'b0;
//        s_axis_tkeep <= 32'hffffffff;
//        s_axis_tvalid <= 1'b0;
//        s_axis_tlast <= 1'b0;
        
//    #(500*CYCLE)  
//        s_axis_tdata <= {16'ha8c0,64'hbc4c114000001a85,16'h4c00,16'h0045,16'h0008,16'h0200,16'h0081,48'h554433221100,48'h554433221100};
//        s_axis_tuser <= {60'b0,68'hfffffffffffffffff};
//        s_axis_tkeep <= 32'hffffffff;
//        s_axis_tvalid <= 1'b1;
//        s_axis_tlast <= 1'b0;
//    #(CYCLE) //test
//        s_axis_tdata <= 256'b0;
//        s_axis_tvalid <= 1'b0;
//        s_axis_tkeep <= 32'h0;
//        s_axis_tuser <= 128'b0;
//        s_axis_tlast <= 1'b0;         
//    #(CYCLE)
//        s_axis_tdata <= 256'h00000000000000000000000000000000000000000000_0000_3412_dddd4b01_0801;
//        s_axis_tuser <= 128'b0;
//        s_axis_tkeep <= 32'hffffffff;
//        s_axis_tvalid <= 1'b1;
//        s_axis_tlast <= 1'b0;
//    #(CYCLE) //test
//        s_axis_tdata <= 256'b0;
//        s_axis_tvalid <= 1'b0;
//        s_axis_tkeep <= 32'h0;
//        s_axis_tuser <= 128'b0;
//        s_axis_tlast <= 1'b0;        
//    #(CYCLE)
//        s_axis_tdata <= 256'h000000000000000000000000000000008b00aaaaaaaaaaaa0000000000000000;
//        s_axis_tuser <= {115'b0,12'b0000_0000_0000,1'b0};
//        s_axis_tkeep <= 32'hffffffff;
//        s_axis_tvalid <= 1'b1;
//        s_axis_tlast <= 1'b0;
//    #(CYCLE) //test
//        s_axis_tdata <= 256'b0;
//        s_axis_tvalid <= 1'b0;
//        s_axis_tkeep <= 32'h0;
//        s_axis_tuser <= 128'b0;
//        s_axis_tlast <= 1'b0;        
//    #(CYCLE)
//        s_axis_tdata <= {8'h02,248'h0};
//        s_axis_tuser <= 128'hfffffffffffffffff;
//        s_axis_tkeep <= 32'hffffffff;
//        s_axis_tvalid <= 1'b1;
//        s_axis_tlast <= 1'b1;
//    #(CYCLE)
//        s_axis_tdata <= 256'h0;
//        s_axis_tuser <= 128'b0;
//        s_axis_tkeep <= 32'hffffffff;
//        s_axis_tvalid <= 1'b0;
//        s_axis_tlast <= 1'b0;





              
////////////foure data packets first que///////////////
//    #(500*CYCLE)  
//        s_axis_tdata <= {16'ha8c0,64'hbc4c114000001a85,16'h4c00,16'h0045,16'h0008,16'h0200,16'h0081,48'h00454d555302,48'h888888888888};
//        s_axis_tuser <= {60'b0,68'hfffffffffffffffff};
//        s_axis_tkeep <= 32'hffffffff;
//        s_axis_tvalid <= 1'b1;
//        s_axis_tlast <= 1'b0;
//    #(CYCLE) //test
//        s_axis_tdata <= 256'b0;
//        s_axis_tvalid <= 1'b0;
//        s_axis_tkeep <= 32'h0;
//        s_axis_tuser <= 128'b0;
//        s_axis_tlast <= 1'b0;         
//    #(CYCLE)
//        s_axis_tdata <= {208'h000000000000000000000000000000000f0200009e0000003412,32'hdededede,16'h0801};
//        s_axis_tuser <= 128'b0;
//        s_axis_tkeep <= 32'hffffffff;
//        s_axis_tvalid <= 1'b1;
//        s_axis_tlast <= 1'b0;
//    #(CYCLE) //test
//        s_axis_tdata <= 256'b0;
//        s_axis_tvalid <= 1'b0;
//        s_axis_tkeep <= 32'h0;
//        s_axis_tuser <= 128'b0;
//        s_axis_tlast <= 1'b0;        
//    #(CYCLE)
//        s_axis_tdata <= {8'h01,248'h0};
//        s_axis_tuser <= {115'b0,12'b0000_0000_0000,1'b0};
//        s_axis_tkeep <= 32'hffffffff;
//        s_axis_tvalid <= 1'b1;
//        s_axis_tlast <= 1'b0;
//    #(CYCLE) //test
//        s_axis_tdata <= 256'b0;
//        s_axis_tvalid <= 1'b0;
//        s_axis_tkeep <= 32'h0;
//        s_axis_tuser <= 128'b0;
//        s_axis_tlast <= 1'b0;        
//    #(CYCLE)
//        s_axis_tdata <= {8'h02,248'h0};
//        s_axis_tuser <= 128'hfffffffffffffffff;
//        s_axis_tkeep <= 32'hffffffff;
//        s_axis_tvalid <= 1'b1;
//        s_axis_tlast <= 1'b1;
//    #(CYCLE)
//        s_axis_tdata <= 256'h0;
//        s_axis_tuser <= 128'b0;
//        s_axis_tkeep <= 32'hffffffff;
//        s_axis_tvalid <= 1'b0;
//        s_axis_tlast <= 1'b0;






    

    

//    //******************************************************************************
//    //******************************************************************************
//    //******************************************************************************
//    /////////////parser for get 2B to VAL2b[1]////////////////////////////////////  
//    #(10*CYCLE);
//    s_axis_tdata <= {16'h6f6f,16'b0,8'h11,72'h0,16'h0008,128'h0};
//    s_axis_tvalid <= 1'b1;
//    s_axis_tkeep <= 64'hffffffffffffffff;
//    s_axis_tuser <= 128'b0;
//    s_axis_tlast <= 1'b0;
//    #(CYCLE);
//    s_axis_tdata <= {120'b0,8'b0000_0000/*index*/,8'b0,5'b00000/*stage*/,3'b000/*mod_id*/,24'b0,8'h4f,16'hf2f1/*control_flag*/,16'b0,48'hdededede6f6f};
//    s_axis_tvalid <= 1'b1;
//    s_axis_tkeep <= 64'hffffffffffffffff;
//    s_axis_tuser <= 128'b0;
//    s_axis_tlast <= 1'b0;
//    #(CYCLE);
//    s_axis_tdata <= {
////        16'b0100_0001_1000_1111,
////          16'b0010_0011_1000_1111,for 2B valid
//        16'b1010_0011_1000_1110,
//        240'b0
//        };
//    s_axis_tvalid <= 1'b1;
//    s_axis_tkeep <= 64'hffffffffffffffff;
//    s_axis_tuser <= 128'b0;
//    s_axis_tlast <= 1'b0;
//    #(CYCLE);
//    s_axis_tdata <= 256'b0;
//    s_axis_tvalid <= 1'b1;
//    s_axis_tkeep <= 64'hffffffffffffffff;
//    s_axis_tuser <= 128'b0;
//    s_axis_tlast <= 1'b0;
//    #(CYCLE);
//    s_axis_tdata <= {100'b0,256'heeeeeeeeeeeeeeeeeeeeeee};
//    s_axis_tvalid <= 1'b1;
//    s_axis_tkeep <= 64'hffffffffffffffff;
//    s_axis_tuser <= 128'b0;
//    s_axis_tlast <= 1'b1;
//    #(CYCLE);
//    s_axis_tdata <= 256'b0;
//    s_axis_tvalid <= 1'b0;
//    s_axis_tkeep <= 64'h0;
//    s_axis_tuser <= 128'b0;
//    s_axis_tlast <= 1'b0;
//    #(10*CYCLE);
////////////deparser for get 2B to VAL2b[1]/////////////////////
//    s_axis_tdata <= {16'h6f6f,16'b0,8'h11,72'h0,16'h0008,128'h0};
//    s_axis_tvalid <= 1'b1;
//    s_axis_tkeep <= 64'hffffffffffffffff;
//    s_axis_tuser <= 128'b0;
//    s_axis_tlast <= 1'b0;
//    #(CYCLE);
//    s_axis_tdata <= {120'b0,8'b0000_0000/*index*/,8'b0,5'b00000/*stage*/,3'b101/*mod_id*/,24'b0,8'h4f,16'hf2f1/*control_flag*/,16'b0,48'hdededede6f6f};
//    s_axis_tvalid <= 1'b1;
//    s_axis_tkeep <= 64'hffffffffffffffff;
//    s_axis_tuser <= 128'b0;
//    s_axis_tlast <= 1'b0;
//    #(CYCLE);
//    s_axis_tdata <= {
////        16'b0100_0001_1000_1111,
////          16'b0010_0011_1000_1111,//for 2B valid
          
//        //16'b1_00011110_10_1011_1,
//        16'b1010_0011_1000_1110,
//        240'b0
//        };
//    s_axis_tvalid <= 1'b1;
//    s_axis_tkeep <= 64'hffffffffffffffff;
//    s_axis_tuser <= 128'b0;
//    s_axis_tlast <= 1'b0;
//    #(CYCLE)
//    s_axis_tdata <= 256'b0;
//    s_axis_tvalid <= 1'b1;
//    s_axis_tkeep <= 64'hffffffffffffffff;
//    s_axis_tuser <= 128'b0;
//    s_axis_tlast <= 1'b0;
//    #(CYCLE)
//    s_axis_tdata <= {100'b0,412'heeeeeeeeeeeeeeeeeeeeeee};
//    s_axis_tvalid <= 1'b1;
//    s_axis_tkeep <= 64'hffffffffffffffff;
//    s_axis_tuser <= 128'b0;
//    s_axis_tlast <= 1'b1;
//    #(CYCLE)
//    s_axis_tdata <= 512'b0;
//    s_axis_tvalid <= 1'b0;
//    s_axis_tkeep <= 64'h0;
//    s_axis_tuser <= 128'b0;
//    s_axis_tlast <= 1'b0;
//    #(10*CYCLE);
//         ////////////foure data packets third que///////////////
//    #(40*CYCLE);   
//    s_axis_tdata <= {16'h769a,16'b0,8'h11,72'h0,16'h0008,128'h0};
//    s_axis_tuser <= {60'b0,68'hfffffffffffffffff};
//    s_axis_tkeep <= 64'hffffffffffffffff;
//    s_axis_tvalid <= 1'b1;
//    s_axis_tlast <= 1'b0;
//    #(CYCLE)
//    s_axis_tdata <= {120'b0,8'b0000_0000/*index*/,4'b0/*resv*/,4'b0,5'b00000/*stage*/,3'b000/*mod_id*/,24'b0,8'h4f,16'h0000/*control_flag*/,16'b0,48'hdededede1234};
//    s_axis_tuser <= 128'b0;
//    s_axis_tkeep <= 64'hffffffffffffffff;
//    s_axis_tvalid <= 1'b1;
//    s_axis_tlast <= 1'b0;
//    #(CYCLE)
//    s_axis_tdata <= {8'h01,248'h0};
//    s_axis_tuser <= {115'b0,12'b0000_0000_0000,1'b0};
//    s_axis_tkeep <= 64'hffffffffffffffff;
//    s_axis_tvalid <= 1'b1;
//    s_axis_tlast <= 1'b0;
//    #(CYCLE)
//    s_axis_tdata <= {8'h02,248'h0};
//    s_axis_tuser <= 128'hfffffffffffffffff;
//    s_axis_tkeep <= 64'hffffffffffffffff;
//    s_axis_tvalid <= 1'b1;
//    s_axis_tlast <= 1'b1;
//    #(CYCLE)
//    s_axis_tdata <= {64'hffff_ffff_ffff_ffff,64'b1,12'b0000_0001_0000,116'b0};
//    s_axis_tuser <= 128'b0;
//    s_axis_tkeep <= 64'hffffffffffffffff;
//    s_axis_tvalid <= 1'b0;
//    s_axis_tlast <= 1'b0;
//    //******************************************************************************
//    //******************************************************************************
//    //******************************************************************************
//    /////////////parser for get 8B to VAL8b[7]////////////////////////////////////  
//    #(10*CYCLE);
//    s_axis_tdata <= {16'h6f6f,16'b0,8'h11,72'h0,16'h0008,128'h0};
//    s_axis_tvalid <= 1'b1;
//    s_axis_tkeep <= 64'hffffffffffffffff;
//    s_axis_tuser <= 128'b0;
//    s_axis_tlast <= 1'b0;
//    #(CYCLE);
//    s_axis_tdata <= {120'b0,8'b0000_0000/*index*/,8'b0,5'b00000/*stage*/,3'b000/*mod_id*/,24'b0,8'h4f,16'hf2f1/*control_flag*/,16'b0,48'hdededede6f6f};
//    s_axis_tvalid <= 1'b1;
//    s_axis_tkeep <= 64'hffffffffffffffff;
//    s_axis_tuser <= 128'b0;
//    s_axis_tlast <= 1'b0;
//    #(CYCLE);
//    s_axis_tdata <= {
////        16'b0100_0001_1000_1111,
////          16'b0010_0011_1000_1111,for 2B valid
////        16'b1010_0011_1000_1110,for 2B different data from pkt-field
//        16'b0110_1111_1000_1111,
//        240'b0
//        };
//    s_axis_tvalid <= 1'b1;
//    s_axis_tkeep <= 64'hffffffffffffffff;
//    s_axis_tuser <= 128'b0;
//    s_axis_tlast <= 1'b0;
//    #(CYCLE);
//    s_axis_tdata <= 256'b0;
//    s_axis_tvalid <= 1'b1;
//    s_axis_tkeep <= 64'hffffffffffffffff;
//    s_axis_tuser <= 128'b0;
//    s_axis_tlast <= 1'b0;
//    #(CYCLE);
//    s_axis_tdata <= {100'b0,256'heeeeeeeeeeeeeeeeeeeeeee};
//    s_axis_tvalid <= 1'b1;
//    s_axis_tkeep <= 64'hffffffffffffffff;
//    s_axis_tuser <= 128'b0;
//    s_axis_tlast <= 1'b1;
//    #(CYCLE);
//    s_axis_tdata <= 256'b0;
//    s_axis_tvalid <= 1'b0;
//    s_axis_tkeep <= 64'h0;
//    s_axis_tuser <= 128'b0;
//    s_axis_tlast <= 1'b0;
//    #(10*CYCLE);
////////////deparser for get 2B to VAL2b[1]/////////////////////
//    s_axis_tdata <= {16'h6f6f,16'b0,8'h11,72'h0,16'h0008,128'h0};
//    s_axis_tvalid <= 1'b1;
//    s_axis_tkeep <= 64'hffffffffffffffff;
//    s_axis_tuser <= 128'b0;
//    s_axis_tlast <= 1'b0;
//    #(CYCLE);
//    s_axis_tdata <= {120'b0,8'b0000_0000/*index*/,8'b0,5'b00000/*stage*/,3'b101/*mod_id*/,24'b0,8'h4f,16'hf2f1/*control_flag*/,16'b0,48'hdededede6f6f};
//    s_axis_tvalid <= 1'b1;
//    s_axis_tkeep <= 64'hffffffffffffffff;
//    s_axis_tuser <= 128'b0;
//    s_axis_tlast <= 1'b0;
//    #(CYCLE);
//    s_axis_tdata <= {
////        16'b0100_0001_1000_1111,
////          16'b0010_0011_1000_1111,//for 2B valid
          
//        //16'b1_00011110_10_1011_1,
////        16'b1010_0011_1000_1110,
////        16'b1010_0011_1000_1110,
//  16'b0110_1111_1000_1111,
//        240'b0
//        };
//    s_axis_tvalid <= 1'b1;
//    s_axis_tkeep <= 64'hffffffffffffffff;
//    s_axis_tuser <= 128'b0;
//    s_axis_tlast <= 1'b0;
//    #(CYCLE)
//    s_axis_tdata <= 256'b0;
//    s_axis_tvalid <= 1'b1;
//    s_axis_tkeep <= 64'hffffffffffffffff;
//    s_axis_tuser <= 128'b0;
//    s_axis_tlast <= 1'b0;
//    #(CYCLE)
//    s_axis_tdata <= {100'b0,412'heeeeeeeeeeeeeeeeeeeeeee};
//    s_axis_tvalid <= 1'b1;
//    s_axis_tkeep <= 64'hffffffffffffffff;
//    s_axis_tuser <= 128'b0;
//    s_axis_tlast <= 1'b1;
//    #(CYCLE)
//    s_axis_tdata <= 512'b0;
//    s_axis_tvalid <= 1'b0;
//    s_axis_tkeep <= 64'h0;
//    s_axis_tuser <= 128'b0;
//    s_axis_tlast <= 1'b0;
//    #(10*CYCLE);
//         ////////////foure data packets third que///////////////
//    #(40*CYCLE);   
//    s_axis_tdata <= {16'h769a,16'b0,8'h11,72'h0,16'h0008,128'h0};
//    s_axis_tuser <= {60'b0,68'hfffffffffffffffff};
//    s_axis_tkeep <= 64'hffffffffffffffff;
//    s_axis_tvalid <= 1'b1;
//    s_axis_tlast <= 1'b0;
//    #(CYCLE)
//    s_axis_tdata <= {120'b0,8'b0000_0000/*index*/,4'b0/*resv*/,4'b0,5'b00000/*stage*/,3'b000/*mod_id*/,24'b0,8'h4f,16'h0000/*control_flag*/,16'b0,48'hdededede1234};
//    s_axis_tuser <= 128'b0;
//    s_axis_tkeep <= 64'hffffffffffffffff;
//    s_axis_tvalid <= 1'b1;
//    s_axis_tlast <= 1'b0;
//    #(CYCLE)
//    s_axis_tdata <= {8'h01,248'h0};
//    s_axis_tuser <= {115'b0,12'b0000_0000_0000,1'b0};
//    s_axis_tkeep <= 64'hffffffffffffffff;
//    s_axis_tvalid <= 1'b1;
//    s_axis_tlast <= 1'b0;
//    #(CYCLE)
//    s_axis_tdata <= {8'h02,248'h0};
//    s_axis_tuser <= 128'hfffffffffffffffff;
//    s_axis_tkeep <= 64'hffffffffffffffff;
//    s_axis_tvalid <= 1'b1;
//    s_axis_tlast <= 1'b1;
//    #(CYCLE)
//    s_axis_tdata <= {64'hffff_ffff_ffff_ffff,64'b1,12'b0000_0001_0000,116'b0};
//    s_axis_tuser <= 128'b0;
//    s_axis_tkeep <= 64'hffffffffffffffff;
//    s_axis_tvalid <= 1'b0;
//    s_axis_tlast <= 1'b0;

   
   
    
end

///////////////////////512λͨ·////////////////////////////////////////////////////////////
//initial begin
//    #(3*CYCLE+CYCLE/2);
//    #(40* CYCLE)
//    m_axis_tready <= 1'b1;
//    s_axis_tdata <= 512'b0; 
//    s_axis_tkeep <= 64'h0;
//    s_axis_tuser <= 128'h0;
//    s_axis_tvalid <= 1'b0;
//    s_axis_tlast <= 1'b0;
///////////////��parser��������////////////////////////////////////  
////paser
//    #CYCLE;
//    s_axis_tdata <= {120'b0,8'b0000_0000,8'b0,5'b00000,3'b000,32'b0,16'hf2f1,64'b0,32'b0,8'h11,72'b0,16'h0008,128'b0};
//    s_axis_tvalid <= 1'b1;
//    s_axis_tkeep <= 64'hffffffffffffffff;
//    s_axis_tuser <= 128'b0;
//    s_axis_tlast <= 1'b0;
//    #(CYCLE)
//        s_axis_tdata <= {16'b0_00110000_11_1111_1,	//8B[15]��ȡ�������ݱ��ĵ�[447:384]
//			   16'b0_00111000_11_1110_1,	//8B[14]��ȡ�������ݱ��ĵ�[511:448]
//			   16'b0_01000000_11_1101_1,	//8B[13]��ȡ�������ݱ��ĵ�[575:512]
//			   16'b0_01001000_11_1100_1,	//8B[12]��ȡ�������ݱ��ĵ�[639:576]
//			   16'b0_01010000_11_1011_1,	//8B[11]��ȡ�������ݱ��ĵ�[703:640]
//			   176'b0,
//			   16'b0_01011000_10_1011_1,	//4B[11]��ȡ�������ݱ��ĵ�[735:704]
//			   16'b0_01100000_10_1010_1,	//4B[10]��ȡ�������ݱ��ĵ�[799:768]
//			   16'b0_01101000_10_1001_1,	//4B[9]��ȡ�������ݱ��ĵ�[863:832]
//			   16'b0_01110000_10_1000_1,	//4B[8]��ȡ�������ݱ��ĵ�[927:896]
//			   16'b0_01111000_10_0111_1,	//4B[7]��ȡ�������ݱ��ĵ�[991:960]
//			   16'b0_10000000_01_0011_1,	//2B[3]��ȡ�������ݱ��ĵ�[1039:1024]
//			   16'b0_10001000_01_0010_1,	//2B[2]��ȡ�������ݱ��ĵ�[1103:1088]
//			   16'b0_10010000_01_0001_1,	//2B[1]��ȡ�������ݱ��ĵ�[1167:1152]
			   
//			   128'b0};
//        s_axis_tvalid <= 1'b1;
//        s_axis_tkeep <= 64'hffffffffffffffff;
//        s_axis_tuser <= 128'b0;
//        s_axis_tlast <= 1'b0;
//        #(CYCLE)
//        //c_s_axis_tdata <= {100'b0,412'heeeeeeeeeeeeeeeeeeeeeee};
//        s_axis_tdata <= {100'b0,412'heeeeeeeeeeeeeeeeeeeeeee};
//        s_axis_tvalid <= 1'b1;
//        s_axis_tkeep <= 64'hffffffffffffffff;
//        s_axis_tuser <= 128'b0;
//        s_axis_tlast <= 1'b1;

//        #(CYCLE)
//        s_axis_tdata <= 512'b0;
//        s_axis_tvalid <= 1'b0;
//        s_axis_tkeep <= 64'h0;
//        s_axis_tuser <= 128'b0;
//        s_axis_tlast <= 1'b0;
//    #(10*CYCLE)
////////////deparser/////////////////////
//    s_axis_tdata <= {120'b0,8'b0000_0000,8'b0,5'b00000,3'b101,32'b0,16'hf2f1,64'b0,32'b0,8'h11,72'b0,16'h0008,128'b0};
//    s_axis_tvalid <= 1'b1;
//    s_axis_tkeep <= 64'hffffffffffffffff;
//    s_axis_tuser <= 128'b0;
//    s_axis_tlast <= 1'b0;
//       #(CYCLE)
//        s_axis_tdata <= {120'b0,8'b0000_0000,8'b0,5'b00000,3'b000,32'b0,16'hf2f1,64'b0};
//        s_axis_tvalid <= 1'b1;
//        s_axis_tkeep <= 64'hffffffffffffffff;
//        s_axis_tuser <= 128'b0;
//        s_axis_tlast <= 1'b0;
//        #(CYCLE)
//        s_axis_tdata <= {16'b0_00110000_11_1111_1,	//8B[15]��ȡ�������ݱ��ĵ�[447:384]
//			   16'b0_00111000_11_1110_1,	//8B[14]��ȡ�������ݱ��ĵ�[511:448]
//			   16'b0_01000000_11_1101_1,	//8B[13]��ȡ�������ݱ��ĵ�[575:512]
//			   16'b0_01001000_11_1100_1,	//8B[12]��ȡ�������ݱ��ĵ�[639:576]
//			   16'b0_01010000_11_1011_1,	//8B[11]��ȡ�������ݱ��ĵ�[703:640]
//			   176'b0,
//			   16'b0_01011000_10_1011_1,	//4B[11]��ȡ�������ݱ��ĵ�[735:704]
//			   16'b0_01100000_10_1010_1,	//4B[10]��ȡ�������ݱ��ĵ�[799:768]
//			   16'b0_01101000_10_1001_1,	//4B[9]��ȡ�������ݱ��ĵ�[863:832]
//			   16'b0_01110000_10_1000_1,	//4B[8]��ȡ�������ݱ��ĵ�[927:896]
//			   16'b0_01111000_10_0111_1,	//4B[7]��ȡ�������ݱ��ĵ�[991:960]
//			   16'b0_10000000_01_0011_1,	//2B[3]��ȡ�������ݱ��ĵ�[1039:1024]
//			   16'b0_10001000_01_0010_1,	//2B[2]��ȡ�������ݱ��ĵ�[1103:1088]
//			   16'b0_10010000_01_0001_1,	//2B[1]��ȡ�������ݱ��ĵ�[1167:1152]
			   
//			   128'b0};
//        s_axis_tvalid <= 1'b1;
//        s_axis_tkeep <= 64'hffffffffffffffff;
//        s_axis_tuser <= 128'b0;
//        s_axis_tlast <= 1'b0;
        
        
        
//        #(CYCLE)
//        //c_s_axis_tdata <= {100'b0,412'heeeeeeeeeeeeeeeeeeeeeee};
//        s_axis_tdata <= {100'b0,412'heeeeeeeeeeeeeeeeeeeeeee};
//        s_axis_tvalid <= 1'b1;
//        s_axis_tkeep <= 64'hffffffffffffffff;
//        s_axis_tuser <= 128'b0;
//        s_axis_tlast <= 1'b1;

//        #(CYCLE)
//        s_axis_tdata <= 512'b0;
//        s_axis_tvalid <= 1'b0;
//        s_axis_tkeep <= 64'h0;
//        s_axis_tuser <= 128'b0;
//        s_axis_tlast <= 1'b0;
//    #(10*CYCLE)
//    //////////////////////��дlookup_tcam��һ������//////////////////////////////
//          #(2*CYCLE)
//        s_axis_tdata <= {120'b0,8'b0,4'b0000,4'b0, 8'h2, 32'b0,16'hf2f1,64'b0,32'b0,8'h11,72'b0,16'h0008,128'b0};
//        s_axis_tvalid <= 1'b1;
//        s_axis_tkeep <= 64'hffffffffffffffff;
//        s_axis_tuser <= 128'b0;
//        s_axis_tlast <= 1'b0;
//        #(CYCLE)

//        s_axis_tdata <= {229'h0000000000000000e000000000000000e0000001e0000001e000600060,283'b0};
//        s_axis_tvalid <= 1'b1;
//        s_axis_tkeep <= 64'hffffffffffffffff;
//        s_axis_tuser <= 128'b0;
//        s_axis_tlast <= 1'b1;
//        #(CYCLE)
//        s_axis_tdata <= {16'habbb,496'b0};
//        s_axis_tvalid <= 1'b0;
//        s_axis_tkeep <= 64'hffffffffffffffff;
//        s_axis_tuser <= 128'b0;
//        s_axis_tlast <= 1'b0;
//        #(20*CYCLE)
// //****************************д��looup_action��һ������*********************************************************************//
      
//        s_axis_tdata <= {120'b0,8'b0,4'b0001,4'b1, 8'h2, 32'b0,16'hf2f1,64'b0,32'b0,8'h11,72'b0,16'h0008,128'b0};
//        s_axis_tvalid <= 1'b1;
//        s_axis_tkeep <= 64'hffffffffffffffff;
//        s_axis_tuser <= 128'b0;
//        s_axis_tlast <= 1'b0;
        

//        #(CYCLE)

//        s_axis_tdata <= 
//        {
//        352'h0,
//        32'b000000000001_11111_000_00000_0010011,
//        32'b000000000111_11111_100_00000_0010011,
//        32'b000000000111_11110_110_00000_0010011,
//        32'b000000000111_11110_111_00000_0010011,
//        32'b000000000111_11110_011_00000_0010011
//        };
//        s_axis_tvalid <= 1'b1;
//        s_axis_tkeep <= 64'hffffffffffffffff;
//        s_axis_tuser <= 128'b0;
//        s_axis_tlast <= 1'b0;
//       #(CYCLE)

//        s_axis_tdata <= {224'h0,
//        32'b000000000001_01110_000_00000_0010011,
//        32'b000000000111_01111_100_00000_0010011,
//        32'b000000000111_01100_110_00000_0010011,
//        32'b000000000111_01100_111_00000_0010011,
//        32'b000000000111_01100_011_00000_0010011,
//        32'b000000000111_00011_100_00000_0010011,
//        32'b000000000111_00011_110_00000_0010011,
//        32'b000000000111_00011_111_00000_0010011,
//        32'b000000000111_00011_011_00000_0010011
//        };
//        s_axis_tvalid <= 1'b1;
//        s_axis_tkeep <= 64'hffffffffffffffff;
//        s_axis_tuser <= 128'b0;
//        s_axis_tlast <= 1'b0;
//        #(CYCLE)
//        s_axis_tdata <= 512'b0;
//        s_axis_tvalid <= 1'b1;
//        s_axis_tkeep <= 64'hffffffffffffffff;
//        s_axis_tuser <= 128'b0;
//        s_axis_tlast <= 1'b1;
//        #(CYCLE)
//        s_axis_tdata <= 512'b0;
//        s_axis_tvalid <= 1'b0;
//        s_axis_tkeep <= 64'hffffffffffffffff;
//        s_axis_tuser <= 128'b0;
//        s_axis_tlast <= 1'b0;
//        #(20*CYCLE);       
//   ////////////parser����///////////////
   
//      //���ݱ��Ĳ��ԣ�δ��
//    s_axis_tdata <= {64'h02000000_00000000,64'h07000000_00000000,12'b0000_0000_0000,116'b0,32'b0,8'h11,72'b0,16'h0008,128'b0};
//    s_axis_tuser <= {60'b0,68'hfffffffffffffffff};
//    s_axis_tkeep <= 64'hffffffffffffffff;
//    s_axis_tvalid <= 1'b1;
//    s_axis_tlast <= 1'b0;
//    #(CYCLE)
//    s_axis_tdata <= {64'h00000000_fffffff0,64'h00000000_02000000,64'h00000000_05000000,64'h00000000_03000000,
//                     64'h00000000_0f000000,64'hffffffff_fffffff0,64'h01000000_00000000,64'h05000000_00000000};
//    s_axis_tuser <= 128'b0;
//    s_axis_tkeep <= 64'hffffffffffffffff;
//    s_axis_tvalid <= 1'b1;
//    s_axis_tlast <= 1'b0;
//    #(CYCLE)
//    s_axis_tdata <= {128'b1,12'b0000_0001_0000,116'b0,
//                     64'h00000000_00000000,64'h00000000_0000fff0,64'h00000000_00000200,64'h00000000_00000300};
//    s_axis_tuser <= {115'b0,12'b0000_0000_0000,1'b0};
//    s_axis_tkeep <= 64'hffffffffffffffff;
//    s_axis_tvalid <= 1'b1;
//    s_axis_tlast <= 1'b0;
//    #(CYCLE)
//    s_axis_tdata <= {128'b1,12'b0000_0001_0000,116'b0,128'b1,12'b0000_0001_0000,116'b0};
//    s_axis_tuser <= 128'b0;
//    s_axis_tkeep <= 64'hffffffffffffffff;
//    s_axis_tvalid <= 1'b1;
//    s_axis_tlast <= 1'b1;
//    #(CYCLE)
//    s_axis_tdata <= {256'b1,64'hffff_ffff_ffff_ffff,64'b1,12'b0000_0001_0000,116'b0};
//    s_axis_tuser <= 128'b0;
//    s_axis_tkeep <= 64'hffffffffffffffff;
//    s_axis_tvalid <= 1'b0;
//    s_axis_tlast <= 1'b0;
//    #(10*CYCLE);
//    #(40*CYCLE);
//end



rmt_wrapper #(
	.C_S_AXI_DATA_WIDTH(),
	.C_S_AXI_ADDR_WIDTH(),
	.C_BASEADDR(),
	.C_S_AXIS_DATA_WIDTH(C_S_AXIS_DATA_WIDTH),
	.C_S_AXIS_TUSER_WIDTH(),
	.C_M_AXIS_DATA_WIDTH(C_M_AXIS_DATA_WIDTH),
	.PHV_ADDR_WIDTH()
)rmt_wrapper_ins
(
	.clk(clk),		// axis clk
	.aresetn(aresetn),	

	// input Slave AXI Stream
	.s_axis_tdata(s_axis_tdata),
	.s_axis_tkeep(s_axis_tkeep),
	.s_axis_tuser(s_axis_tuser),
	.s_axis_tvalid(s_axis_tvalid),
	.s_axis_tready(s_axis_tready),
	.s_axis_tlast(s_axis_tlast),
	
	.reg_int_01(reg_int_01),
	.reg_int_02(reg_int_02),
	.reg_int_03(reg_int_03),

	// output Master AXI Stream
	.m_axis_tdata(m_axis_tdata),
	.m_axis_tkeep(m_axis_tkeep),
	.m_axis_tuser(m_axis_tuser),
	.m_axis_tvalid(m_axis_tvalid),
	.m_axis_tready(m_axis_tready),
	.m_axis_tlast(m_axis_tlast)
	
);

endmodule
