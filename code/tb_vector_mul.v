`timescale  1ns / 1ps

module tb_vector_mul;

// vector_mul Parameters
parameter PERIOD          = 10;
parameter VECTOR_MUL_LEN  = 32;
parameter DATA_WIDTH      = 8;

// vector_mul Inputs
reg   clk                                  = 0 ;
reg   rst_n                                = 0 ;
reg   data_vector_valid                    = 0 ;
reg   [VECTOR_MUL_LEN*DATA_WIDTH-1 : 0]  data_vector = 0 ;
reg   weight_vector_valid                  = 0 ;
reg   [VECTOR_MUL_LEN*DATA_WIDTH-1 : 0]  weight_vector = 0 ;

// vector_mul Outputs
wire  result_valid                         ;
wire  [DATA_WIDTH - 1 : 0]  result         ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD*2) rst_n  =  1;
    data_vector_valid = 1;
    weight_vector_valid = 1;
    data_vector = {32'hFF030000, 224'd0};
    weight_vector = {32'h12030000, 224'd0};
    #(PERIOD)  
    data_vector_valid = 0;
    weight_vector_valid = 0;
    #(PERIOD*10)  
    $stop;
end

vector_mul #(
    .VECTOR_MUL_LEN ( VECTOR_MUL_LEN ),
    .DATA_WIDTH     ( DATA_WIDTH     ))
 u_vector_mul (
    .clk                     ( clk                                                    ),
    .rst_n                   ( rst_n                                                  ),
    .data_vector_valid       ( data_vector_valid                                      ),
    .data_vector             ( data_vector          [VECTOR_MUL_LEN*DATA_WIDTH-1 : 0] ),
    .weight_vector_valid     ( weight_vector_valid                                    ),
    .weight_vector           ( weight_vector        [VECTOR_MUL_LEN*DATA_WIDTH-1 : 0] ),

    .result_valid            ( result_valid                                           ),
    .result                  ( result               [DATA_WIDTH - 1 : 0]              )
);

endmodule