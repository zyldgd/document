module SPI_SLAVE #(parameter D = 8, A = 8)(
    input            wire        SS,
    input            wire        SCLK,
    input            wire        MOSI,
    output           reg         MISO
    );

    localparam a = 2**A;

    reg     [D-1:0]        regs[a-1:0];
    reg     [D-1:0]        data;
    reg     [A  :0]        addr; 
    reg     [7  :0]        bit;

    integer i;

    initial begin
        data <= 0;
        addr <= 0;
        bit <= 0;
        MISO <= 0;
        for (i=0; i<a; i=i+1) begin
            regs[i] <= 0;
        end
    end

    always @(posedge SCLK or negedge SS) begin
        if (!SCLK) begin 
            data <= 0;
            addr <= 0;
            bit <= 0;
            MISO <= 0;
        end else begin
            if (bit <= A) begin
                addr[bit] <= MOSI;
            end else begin
                if (addr[0]) begin // 0: rd ,  1:wr
                    regs[addr[A:1]][bit-A-1] <= MOSI;
                end else begin
                    if (bit <= A+D) begin
                        MISO <= regs[addr[A:1]][bit-A-1];
                    end else begin
                        MISO <= 0;
                    end
                end
            end
            bit <= bit + 1;
        end 
    end

endmodule
