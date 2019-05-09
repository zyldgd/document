module SPI_MASTER #(parameter D = 8, A = 8)(
    input       wire             CLOCK,
    output      reg     [D-1:0]  DATAO, 
    input       wire    [D-1:0]  DATAI,
    input       wire    [A-1:0]  ADDR,
    input       wire             WR,
    input       wire             RD,
    output      reg              BUSY,
 
    output      reg              SS,
    output      wire             SCLK,
    output      reg              MOSI,
    input       wire             MISO
    );

    reg     [7  :0]        bit;
    reg     [D-1:0]        data;
    reg     [A-1:0]        addr;
    reg                    wr;
    reg                    clken;

    initial begin
        SS <= 1;
        MOSI <= 0;
        clken <= 0;
        BUSY <= 0;
        DATAO <= 0;
        data <= 0;
        addr <= 0;
        bit <= 0;
        wr <= 0;
    end
    
    assign SCLK = clken & ~CLOCK;
    

    always @(posedge CLOCK or posedge (WR|RD)) begin
        if (WR|RD) begin
            BUSY <= 1;
            data <= DATAI;
            addr <= ADDR;
            wr <= WR;
            bit <= 0;
            SS <= 0;
            clken <= 0;
        end else begin
            if (wr) begin
                if (bit == 0) begin
                    MOSI <= 1;
                    clken <= 1;
                end else if (bit <= A) begin
                    MOSI <= addr[bit-1];
                end else if (bit <= A + D ) begin
                    MOSI <= data[bit-A-1];
                end else if (bit == A + D + 1) begin
                    clken <= 0;
                    MOSI <= 0;
                end else if (bit > A + D + 1) begin 
                    SS <= 1;
                    BUSY <= 0;
                end
            end else begin
                if (bit == 0) begin 
                    clken <= 1;
                end else if (bit <= A) begin
                    MOSI <= addr[bit-1];
                end else if (bit == A+1) begin
                    MOSI <= 0;
                end else if (bit <= A + D + 1) begin
                    DATAO[bit-A-2] <= MISO;
                end else if (bit == A + D + 2) begin
                    clken <= 0;
                end else if (bit > A + D + 2) begin
                    SS <= 1;
                    BUSY <= 0; 
                end
            end
            bit <= bit +1;
        end
    end

endmodule
