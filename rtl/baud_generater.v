module baud_generater #(
    parameter system_frq= 50000000,
    parameter baud_rate= 9600
) (
    input clk,rst,
    output  reg baud_tick,s_tick
);

localparam  max_count= system_frq/(baud_rate*16);
//reg [15:0] count ;
reg [$clog2(max_count)-1:0] count; 
reg [3:0] tx_count;
//reg count also define like this,it will automatic calculate the size of reg

always @(posedge clk or posedge rst) begin
    if (rst) begin
      count <=  0;
      s_tick<=0;
    end 
    else begin
        if (count==max_count-1) begin
            count<=0;
            s_tick<=1;
        end
    
    else  begin
        count<=count+1;
        s_tick<=0;
        
    end
    end
end

always @(posedge clk or posedge rst) begin
    if(rst)begin
        tx_count<=0;
        baud_tick<=0;
    end 
    else begin
     if (s_tick)begin
        if (tx_count==15)begin
            tx_count<=0;
            baud_tick<=1;
    end
    else begin
        tx_count<=tx_count+1;
        baud_tick<=0;
    end
     end
    else begin
        baud_tick<=0;
    end
end
end

    endmodule