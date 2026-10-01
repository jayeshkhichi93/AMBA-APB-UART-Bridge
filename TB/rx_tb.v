module rx_tb;
reg clk,rst,s_tick,rx;
wire rx_done;
wire [7:0] rx_data;
reg [3:0] tick_count;

always #1 clk=~clk;
always @(posedge clk) begin
    if (tick_count==15) begin
        s_tick<=1;
        tick_count<=0;
    end
    else begin
        tick_count<=tick_count+1;
        s_tick<=0;
    end
end
rx uut(
    .clk(clk),
    .rst(rst),
    .s_tick(s_tick),
    .rx(rx),
    .rx_done(rx_done),
    .rx_data(rx_data)
);
initial begin
    clk=0;
    rst=1;
    rx=1;
    tick_count=0;
    #4;
    rst=0;
    rx=0;
    repeat (16) @(posedge s_tick);
    rx=0;
    repeat (16) @(posedge s_tick);
    rx=1;
    repeat (16) @(posedge s_tick);
    rx=0;
    repeat (16) @(posedge s_tick);
    rx=1;
    repeat (16) @(posedge s_tick);
    rx=0;
    repeat (16) @(posedge s_tick);
    rx=1;
    repeat (16) @(posedge s_tick);
    rx=0;
    repeat (16) @(posedge s_tick);
    rx=1;
    repeat (16) @(posedge s_tick);
    rx=1;
    repeat (16) @(posedge s_tick);
    #100;
    $finish;
end
initial begin
    $dumpfile("rx.vcd");
    $dumpvars(0,rx_tb);
end
endmodule