
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

reg                                 clk;
reg                                 aresetn;

reg [C_S_AXIS_DATA_WIDTH-1:0]		s_axis_tdata;
reg [((C_S_AXIS_DATA_WIDTH/8))-1:0]	s_axis_tkeep;
reg [C_S_AXIS_TUSER_WIDTH-1:0]		s_axis_tuser;
reg									s_axis_tvalid;
wire								s_axis_tready;
reg									s_axis_tlast;

wire [C_S_AXIS_DATA_WIDTH-1:0]		    m_axis_tdata;
wire [((C_S_AXIS_DATA_WIDTH/8))-1:0]    m_axis_tkeep;
wire [C_S_AXIS_TUSER_WIDTH-1:0]		    m_axis_tuser;
wire								    m_axis_tvalid;
reg										m_axis_tready;
wire									m_axis_tlast;

assign s_axis_tready = 1'b1;

//clk signal
localparam CYCLE = 10;

always begin
    #(CYCLE/2) clk = ~clk;
end

//reset signal
initial begin
    clk = 0;
    aresetn = 1;
    #(10);
    aresetn = 0; //reset all the values
    #(10);
    aresetn = 1;
end

initial begin
    #(3*CYCLE+CYCLE/2);
    #(40* CYCLE)
    m_axis_tready <= 1'b1;
    s_axis_tdata <= 512'b0; 
    s_axis_tkeep <= 64'h0;
    s_axis_tuser <= 128'h0;
    s_axis_tvalid <= 1'b0;
    s_axis_tlast <= 1'b0;
/////////////对parser进行配置////////////////////////////////////  

    #CYCLE;
    s_axis_tdata <= {32'b0,8'h11,72'b0,16'h0008,128'b0};
    s_axis_tvalid <= 1'b1;
    s_axis_tkeep <= 64'hffffffffffffffff;
    s_axis_tuser <= 128'b0;
    s_axis_tlast <= 1'b0;
        #(CYCLE)
    s_axis_tdata <= {120'b0,8'b0000_0000,8'b0,5'b00000,3'b000,32'b0,16'hf2f1,64'b0};
    s_axis_tvalid <= 1'b1;
    s_axis_tkeep <= 64'hffffffffffffffff;
    s_axis_tuser <= 128'b0;
    s_axis_tlast <= 1'b0;
        #(CYCLE)
    s_axis_tdata <= {16'b0_11111000_11_0001_1,16'b0_11111000_10_0001_1,16'b0_11111000_01_0001_1,208'b0};
    s_axis_tvalid <= 1'b1;
    s_axis_tkeep <= 64'hffffffffffffffff;
    s_axis_tuser <= 128'b0;
    s_axis_tlast <= 1'b0;
        #(CYCLE)
    s_axis_tdata <= 256'b0;
    s_axis_tvalid <= 1'b1;
    s_axis_tkeep <= 64'hffffffffffffffff;
    s_axis_tuser <= 128'b0;
    s_axis_tlast <= 1'b0;
        #(CYCLE)

    s_axis_tdata <= 256'b0;
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
//////////deparser/////////////////////
    s_axis_tdata <= {32'b0,8'h11,72'b0,16'h0008,128'b0};
    s_axis_tvalid <= 1'b1;
    s_axis_tkeep <= 64'hffffffffffffffff;
    s_axis_tuser <= 128'b0;
    s_axis_tlast <= 1'b0;
        #(CYCLE)
    s_axis_tdata <= {120'b0,8'b0000_0000,8'b0,5'b00000,3'b101,32'b0,16'hf2f1,64'b0};
    s_axis_tvalid <= 1'b1;
    s_axis_tkeep <= 64'hffffffffffffffff;
    s_axis_tuser <= 128'b0;
    s_axis_tlast <= 1'b0;
        #(CYCLE)
    s_axis_tdata <= {16'b0_11111000_11_0001_1,16'b0_11111000_10_0001_1,16'b0_11111000_01_0001_1,208'b0};
    s_axis_tvalid <= 1'b1;
    s_axis_tkeep <= 64'hffffffffffffffff;
    s_axis_tuser <= 128'b0;
    s_axis_tlast <= 1'b0;
        #(CYCLE)
    s_axis_tdata <= 256'b0;
    s_axis_tvalid <= 1'b1;
    s_axis_tkeep <= 64'hffffffffffffffff;
    s_axis_tuser <= 128'b0;
    s_axis_tlast <= 1'b0;
        #(CYCLE)

        //c_s_axis_tdata <= {100'hfffff_fffff_fffff_fffff_fffff,412'heeeeeeeeeeeeeeeeeeeeeee};
    s_axis_tdata <= 256'b0;
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
   /////////////////填写lookup_tcam第一个表项////////////////
          #(2*CYCLE)
    s_axis_tdata <= {32'b0,8'h11,72'b0,16'h0008,128'b0};
        s_axis_tvalid <= 1'b1;
        s_axis_tkeep <= 32'hffffffff;
        s_axis_tuser <= 128'b0;
        s_axis_tlast <= 1'b0;
        #(CYCLE)

        s_axis_tdata <= {120'b0,8'b0,4'b0000,4'b0, 8'h2, 32'b0,16'hf2f1,64'b0};
        s_axis_tvalid <= 1'b1;
        s_axis_tkeep <= 32'hffffffff;
        s_axis_tuser <= 128'b0;
        s_axis_tlast <= 1'b0;
        #(CYCLE)

        s_axis_tdata <= {229'h0000000000000000e000000000000000e0000001e0000001e000600060,27'b0};
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
        #(20*CYCLE)
 //****************************写入looup_action第一个表项*********************************************************************//
      
    s_axis_tdata <= {32'b0,8'h11,72'b0,16'h0008,128'b0};
        s_axis_tvalid <= 1'b1;
        s_axis_tkeep <= 32'hffffffff;
        s_axis_tuser <= 128'b0;
        s_axis_tlast <= 1'b0;

        //action table
        #(CYCLE)
        s_axis_tdata <= {120'b0,8'b0,4'b0000,4'b1, 8'h2, 32'b0,16'hf2f1,64'b0};
        s_axis_tvalid <= 1'b1;
        s_axis_tkeep <= 32'hffffffff;
        s_axis_tuser <= 128'b0;
        s_axis_tlast <= 1'b0;
        
        #(CYCLE)
        s_axis_tdata <= 256'h0;
        s_axis_tvalid <= 1'b1;
        s_axis_tkeep <= 32'hffffffff;
        s_axis_tuser <= 128'b0;
        s_axis_tlast <= 1'b0;

        #(CYCLE)

        s_axis_tdata <= 
        {
        96'h0,
        32'b000000000001_11111_000_00000_0010011,
        32'b000000000111_11111_100_00000_0010011,
        32'b000000000111_11110_110_00000_0010011,
        32'b000000000111_11110_111_00000_0010011,
        32'b000000000111_11110_011_00000_0010011
        };
        s_axis_tvalid <= 1'b1;
        s_axis_tkeep <= 32'hffffffff;
        s_axis_tuser <= 128'b0;
        s_axis_tlast <= 1'b0;
       #(CYCLE)

        s_axis_tdata <= {224'h0,32'b000000000001_01110_000_00000_0010011};
        s_axis_tvalid <= 1'b1;
        s_axis_tkeep <= 32'hffffffff;
        s_axis_tuser <= 128'b0;
        s_axis_tlast <= 1'b0;
        #(CYCLE)

        s_axis_tdata <= {
        32'b000000000111_01111_100_00000_0010011,
        32'b000000000111_01100_110_00000_0010011,
        32'b000000000111_01100_111_00000_0010011,
        32'b000000000111_01100_011_00000_0010011,
        32'b000000000111_00011_100_00000_0010011,
        32'b000000000111_00011_110_00000_0010011,
        32'b000000000111_00011_111_00000_0010011,
        32'b000000000111_00011_011_00000_0010011
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
        #(4*CYCLE);       
   ////////////parser数据///////////////
   
      //数据报文测试（未）
    s_axis_tdata <= {32'b0,8'h11,72'b0,16'h0008,128'b0};
    s_axis_tuser <= 128'hfffffffffffffffff;
    s_axis_tkeep <= 64'hffffffffffffffff;
    s_axis_tvalid <= 1'b1;
    s_axis_tlast <= 1'b0;
    #(CYCLE)
    s_axis_tdata <= {128'b1,12'b0000_0000_0000,116'b0};
    s_axis_tuser <= {115'b1111,12'b0000_0001_0000,1'b1};
    s_axis_tkeep <= 64'hffffffffffffffff;
    s_axis_tvalid <= 1'b1;
    s_axis_tlast <= 1'b0;
    #(CYCLE)
    s_axis_tdata <= {128'b1,12'b0000_0000_0000,116'b0};
    s_axis_tuser <= 128'hfffffffffffffffff;
    s_axis_tkeep <= 64'hffffffffffffffff;
    s_axis_tvalid <= 1'b1;
    s_axis_tlast <= 1'b0;
    #(CYCLE)
    s_axis_tdata <= {128'b1,12'b0000_0000_0000,116'b0};
    s_axis_tuser <= 128'hfffffffffffffffff;
    s_axis_tkeep <= 64'hffffffffffffffff;
    s_axis_tvalid <= 1'b1;
    s_axis_tlast <= 1'b0;
    #(CYCLE)
    s_axis_tdata <= {128'b1,12'b0000_0000_0000,116'b0};
    s_axis_tuser <= 128'b0;
    s_axis_tkeep <= 64'hffffffffffffffff;
    s_axis_tvalid <= 1'b1;
    s_axis_tlast <= 1'b0;
    #(CYCLE)
    s_axis_tdata <= {128'b1,12'b0000_0000_0000,116'b0};
    s_axis_tuser <= 128'b0;
    s_axis_tkeep <= 64'hffffffffffffffff;
    s_axis_tvalid <= 1'b1;
    s_axis_tlast <= 1'b0;
    #(CYCLE)
    s_axis_tdata <= {128'b1,12'b0000_0000_0000,116'b0};
    s_axis_tuser <= 128'b0;
    s_axis_tkeep <= 64'hffffffffffffffff;
    s_axis_tvalid <= 1'b1;
    s_axis_tlast <= 1'b0;
    #(CYCLE)
    s_axis_tdata <= {64'hffff_ffff_ffff_ffff,64'b1,12'b0000_0000_0000,116'b0};
    s_axis_tuser <= 128'b0;
    s_axis_tkeep <= 64'hffffffffffffffff;
    s_axis_tvalid <= 1'b1;
    s_axis_tlast <= 1'b1;
    #(CYCLE)
    s_axis_tdata <= {256'b1};
    s_axis_tuser <= 128'b0;
    s_axis_tkeep <= 64'hffffffffffffffff;
    s_axis_tvalid <= 1'b0;
    s_axis_tlast <= 1'b0;
    #(10*CYCLE);
    #(40*CYCLE);
end




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

	// output Master AXI Stream
	.m_axis_tdata(m_axis_tdata),
	.m_axis_tkeep(m_axis_tkeep),
	.m_axis_tuser(m_axis_tuser),
	.m_axis_tvalid(m_axis_tvalid),
	.m_axis_tready(m_axis_tready),
	.m_axis_tlast(m_axis_tlast)
	
);

endmodule