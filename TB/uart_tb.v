module uart_tb;
reg clk,rst,tx_start;
reg [7:0] data_in;
wire [7:0] rx_data;
wire rx_done,tx,tx_done;
wire serial_line;

always #1 clk=~clk;

uart #(
    .system_frq(1600),
    .baud_rate(20)
) uut (
    .clk(clk),
    .rst(rst),
    .tx_start(tx_start),
    .rx(serial_line),
    .data_in(data_in),
    .rx_data(rx_data),
    .rx_done(rx_done),
    .tx(serial_line),
    .tx_done(tx_done)
);
initial begin
    $dumpfile("uart.vcd");
    $dumpvars(0,uart_tb);
end

initial begin
    clk=0;
    rst=1;
    tx_start=0;
    data_in=0;
    #4;
    rst=0;
    data_in=8'b0101_0101;
    #4;
    tx_start=1;
    #4;
    tx_start=0;
    #1800;
    $finish;

end
endmodule 