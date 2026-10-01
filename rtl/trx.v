module trx (
    input clk,rst,tx_start,baud_tick,
    input [7:0] data_in,
    output reg tx, tx_done
);
parameter idle = 2'b00;
parameter start= 2'b01;
parameter data = 2'b10;
parameter stop = 2'b11;

reg [1:0] state;
reg [3:0] count_in;
reg [7:0] data_reg;
    always @(posedge clk or posedge rst) begin
        if (rst)begin
          state<= idle;
          tx<=1;
          count_in<=0;
          data_reg<=0;  
        end
        else begin
            case (state)
               idle : begin
                 tx<=1;
                if (tx_start)begin
                state<=start;
                count_in<=0;
                tx_done<=0;
                data_reg<=data_in;
                end
               end
               start : begin
                tx<=0;
                if (baud_tick) begin
                tx_done<=0;
                state<=data;
                end
                end
               data : begin
                tx<= data_reg [count_in];
                     if (baud_tick)begin
                tx_done<=0;
                if (count_in==3'b111) begin
                    count_in<=0;
                    state<=stop;
                end
                    else
                  count_in<=count_in+1;   
                end
               end
               stop : begin
                tx<=1;
                if (baud_tick)begin
                tx_done<=1;
                state<=idle;   
                end
                
               end
                default: begin
                    state <= idle;
                end
            endcase
        end
        end
endmodule