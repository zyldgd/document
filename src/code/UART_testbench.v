`timescale 1 ps/ 1 ps

module testbench();

localparam n = 8;

wire  SS;
wire  SCLK;
wire  MOSI;
wire  MISO;
wire  BUSY;
wire  TX;
wire  RX;

reg   CLK  = 0;
reg   WR0  = 0; 
reg   WR1  = 0; 

reg [n-1:0]   DATA0   = 0;
reg [n-1:0]   DATA1   = 0; 
reg           RESET_N = 1; 


always #1 CLK <= ~CLK;


initial begin 
    #100 
    RESET_N <= 0;
    #100
    RESET_N <= 1;
    
    #1000
    DATA0   <= 77;
    DATA1   <= 88;
    #2000 
    WR0     <= 1;
    WR1     <= 1;
    #200 
    WR0     <= 0;
    WR1     <= 0;

    #30000
    DATA0   <= 55;
    DATA1   <= 66;
    #2000 
    WR0     <= 1;
    WR1     <= 1;
    #200 
    WR0     <= 0;
    WR1     <= 0;

end

UART #(.BaudRate(9600), .RefFrequency(10_000_000), .N(n)) U1(
    .CLOCK     (CLK),
    .RESET_N   (RESET_N),
    .DATAI     (DATA0), 
    .DATAO     (), 
    .WR        (WR0), 
    .BUSY      (), 
    .VALID     (), 
    .TX        (TX),
    .RX        (RX)
    );

UART #(.BaudRate(9600), .RefFrequency(10_000_000), .N(n)) U2(
    .CLOCK     (CLK),
    .RESET_N   (RESET_N),
    .DATAI     (DATA1), 
    .DATAO     (), 
    .WR        (WR1), 
    .BUSY      (), 
    .VALID     (), 
    .TX        (RX),
    .RX        (TX)
    );

endmodule


