`timescale 1ns / 1ps

module SPI_MASTER #(parameter D = 8, A = 8)(
    input            wire       CLOCK,
 
    output  [D-1:0]  reg        DATAO, 
    input   [D-1:0]  wire       DATAI,
    input   [A-1:0]  wire       ADDR,
    input            wire       WR,
    input            wire       RD,
    output           reg        BUSY,
 
    output           reg        SS,
    output           reg        SCLK,
    output           reg        MOSI,
    input            wire       MISO
    );

    reg     [31 :0]        bit;
    reg     [D-1:0]        data;
    reg     [A-1:0]        addr;
    reg                    wr;


    SS = 1;
    

    always @(posedge CLOCK or posedge (WR|RD)) begin
        if (WR|RD) begin
            BUSY <= 1;
            data <= DATAI;
            addr <= ADDR;
            wr <= WR;
            bit <= 0;
            SS <= 0;
        end else begin
            if (wr) begin
                if (bit == 0) begin
                    MOSI <= 1;
                end else if (bit <= A) begin
                    MOSI <= addr[bit-1];
                end else if (bit <= A + D ) begin
                    MOSI <= data[bit-A];
                end else begin
                    SS <= 1;
                    BUSY <= 0;
                end
            end else begin
                
            end
            SCLK <= ~CLOCK
            bit <= bit +1;
        end
    end

endmodule



module SPI_SLAVE #(parameter D = 8, A = 8)(
    input            reg        SS,
    input            reg        SCLK,
    input            reg        MOSI,
    output           wire       MISO
    );

    reg     [A-1:0]        regs[D-1:0];
    reg     [D-1:0]        data;
    reg     [A  :0]        addr; 

    reg     [31 :0]        bit;

    always @(posedge SCLK or negedge SS) begin
        if (!SCLK) begin 
            bit <= 0;
        end else begin
            if (bit <= A) begin
                addr[bit] <= MOSI;
            end else begin
                if (addr[0]) begin // 0: rd ,  1:wr
                    regs[addr[D:1]][bit-D] <= MOSI;
                end else begin
                    MISO <= regs[addr[D:1]][bit-D];
                end
            end
            bit <= bit + 1;
        end 
    end
endmodule