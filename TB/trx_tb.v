module trx_tb;
reg clk,rst,tx_start,baud_tick;
reg [7:0] data_in;
wire tx_done,tx;
reg [3:0] count;

always #1 clk=~clk;
always @(posedge clk) begin
    if(count==10)begin
        baud_tick<=1;
        count<=0;
    end
        else begin
        count<=count+1;
        baud_tick<=0;
    end
  
end

trx uut(
    .clk(clk),
    .rst(rst),
    .tx_start(tx_start),
    .baud_tick(baud_tick),
    .tx(tx),
    .tx_done(tx_done),
    .data_in(data_in)
);

initial begin
    clk=0;
    rst=1;
    data_in=8'b0000;
    tx_start=0;
    count=0;
    #4;
    rst=0;
    #4;
    data_in=8'b1010_1010;
    #2;
    tx_start=1;
    #2;
    tx_start=0;
    #290;
    $finish;
end

initial begin
    $dumpfile("trx.vcd");
    $dumpvars(0,trx_tb);
    $monitor("time=%0t baud_tick=%b  tx_start=%b tx=%b tx_done=%b",$time,baud_tick,tx_start,tx,tx_done);
end

endmodule