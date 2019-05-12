module UART #(parameter BaudRate = 9600, RefFrequency = 10_000_000, N = 8)(
    input    wire            CLOCK,
    input    wire            RESET_N,
    input    wire  [N-1:0]   DATAI, 
    output   reg   [N-1:0]   DATAO, 
    input    wire            WR, 
    output   reg             BUSY, 
    output   reg             VALID, 
    output   reg             TX,
    input    wire            RX
    );


    localparam  cycle = RefFrequency/BaudRate;

    reg  signed  [ 15:0]  varCount = 0;
    reg          [ 15:0]  count0   = 0;
    reg          [ 15:0]  count1   = 0;
    reg          [  7:0]  bit0     = 0;
    reg          [  7:0]  bit1     = 0;
    reg          [N-1:0]  datai    = 0;
    reg                   recving  = 0;
    reg                   sending  = 0;
    

    always @(posedge CLOCK or negedge RESET_N) begin
        if (!RESET_N) begin
            count0 <= 0;
            bit0 <= 0;
            recving <= 0;
            varCount <= 0;
            VALID <= 0;
        end else begin
            if (recving) begin
                if (count0 < cycle) begin
                    count0 <= count0+1;
                    bit0 <= bit0+1; 
                    varCount = RX ? varCount+1 : varCount-1;
                end else if(count0 == cycle) begin
                    count0 <= count0+1;
                    if (bit0 == 0) begin
                        if (varCount>0) begin
                            recving <= 0;
                        end 
                    end else if (bit0 <= N) begin
                        DATAO[bit-1] <= varCount>0?1:0;
                    end else begin
                        VALID <= 1;
                        recving <= 0;
                    end  
                end else begin
                    count0 <= 1;
                    varCount <= 0;
                end
            end else begin
                if (RX==0) begin
                    recving <= 1;
                    count0 <= 1;
                    bit0 <= 0;
                    varCount <= 0;
                    VALID <= 0;
                end
            end 
        end
    end


    assign  BUSY = sending;
    
    always @(posedge CLOCK or negedge RESET_N) begin
        if (!RESET_N) begin
            count1 <= 0;
            bit1 <= 0;
            sending <= 0;  
            TX <= 1;
        end else begin
            if (sending) begin
                if (count1 < cycle) begin
                    count1 <= count1+1;
                end else if(count1 == cycle) begin
                    count1 <= count1+1; 
                    bit0 <= bit0+1; 
                    if (bit0 < N) begin
                        TX <= DATAI[bit];
                    end else if (bit0 == N) begin 
                        TX <= 1;
                    end else begin 
                        sending <= 0;
                    end  
                end else begin
                    count1 <= 1; 
                end
            end else begin
                if (WR) begin
                    sending <= 1; 
                    count1 <= 1;
                    bit1 <= 0;
                    TX <= 0;
                end
            end
        end
    end


endmodule 