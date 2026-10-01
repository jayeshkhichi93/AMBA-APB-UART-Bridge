module rx (
    input clk,rst,rx,s_tick,
    output reg rx_done,
    output reg [7:0] rx_data
);

parameter idle =2'b00;
parameter start =2'b01;
parameter data =2'b10;
parameter stop =2'b11;

reg rx1,rx2;
reg [3:0]counter;
reg [1:0] state;
reg [3:0] bit_index;

    always @(posedge clk) begin
        rx1<=rx;
        rx2<=rx1;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state<=idle;
            rx_data<=0;
            rx_done<=0;
            counter<=0;
        end
        else begin
            case (state)
            idle:begin
                rx_done<=0;
                if(rx2==0)begin
                    state<=start;
                    counter<=0;
                end
            end
            start:begin
                if (s_tick) begin
                if(counter==7)begin
                    if(rx2==0)begin
                        state<=data;
                        counter<=0;
                        bit_index<=0;
                    end
                    else begin
                        state<=idle;
                    end
                end
                else begin
                    counter<=counter+1;
                end
            end
            end
            data:begin
                if (s_tick)begin
                if (counter==15) begin
                    counter<=0;
                   rx_data[bit_index]<=rx2;
                   if (bit_index==7) begin
                    state<=stop;
                   end 
                   else begin
                    bit_index<=bit_index+1;
                   end
                end
                else begin
                    counter<=counter+1;
                end
            end
            end
            stop:begin
                if (s_tick) begin
                    if (counter==15) begin
                    rx_done<=1;  
                    counter<=0; 
                    state<=idle; 
                    end
                    else begin
                        counter<=counter+1;
                    end
                    
                end
            end
            endcase
        end
    end
endmodule