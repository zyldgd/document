`timescale 1 ps/ 1 ps

module testbench();

localparam D = 8;
localparam A = 4;



wire  SS;
wire  SCLK;
wire  MOSI;
wire  MISO;
wire  BUSY;

reg   CLK  = 0;
reg   WR   = 0;
reg   RD   = 0;

reg [D-1:0]   DATAI = 0;
reg [A-1:0]   ADDR = 0; 


always @(*) begin
    #50 CLK <= ~CLK;
end

initial begin
    #50  
    DATAI = 15;  
    ADDR  = 15;
    #100 
    WR    = 1;
    #100
    WR    = 0;

    #2000 
    DATAI = 6;
    ADDR  = 0;
    #100 
    WR    = 1;
    #100 
    WR    = 0;

    #2000 
    DATAI = 205;
    ADDR  = 7;
    #100 
    WR    = 1;
    #100 
    WR    = 0;

    #2000 
    ADDR  = 7;
    #100 
    RD    = 1;
    #100 
    RD    = 0;

    #2000 
    ADDR  = 0;
    #100 
    RD    = 1;
    #100 
    RD    = 0;

    #2000 
    ADDR  = 15;
    #100 
    RD    = 1;
    #100 
    RD    = 0;

end



SPI_MASTER #(.D(D), .A(A)) M(
    .CLOCK      (CLK),
    .DATAO      (),
    .DATAI      (DATAI),
    .ADDR       (ADDR),
    .WR         (WR),
    .RD         (RD),
    .BUSY       (BUSY),

    .SS         (SS),
    .SCLK       (SCLK),
    .MOSI       (MOSI),
    .MISO       (MISO)
);


SPI_SLAVE #(.D(D), .A(A)) S(
    .SS         (SS  ),
    .SCLK       (SCLK),
    .MOSI       (MOSI),
    .MISO       (MISO)
);
endmodule


