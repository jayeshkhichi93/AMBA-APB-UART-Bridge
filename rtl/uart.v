module uart #(
    parameter system_frq=50000000,
    parameter baud_rate=9600
) (
    input clk,rst,tx_start,rx,
    input [7:0] data_in,
    output [7:0] rx_data,
    output rx_done,tx,tx_done
);
    wire baud_tick;
    wire s_tick;

    baud_generater #(
        .system_frq(system_frq),
        .baud_rate(baud_rate)
    ) baud_gen (
        .clk(clk),
        .rst(rst),
        .baud_tick(baud_tick),
        .s_tick(s_tick)
    );

    trx trx_1 (
        .clk(clk),
        .rst(rst),
        .tx_start(tx_start),
        .baud_tick(baud_tick),
        .data_in(data_in),
        .tx(tx),
        .tx_done(tx_done)
    );

    rx rx_1 (
        .clk(clk),
        .rst(rst),
        .rx(rx),
        .s_tick(s_tick),
        .rx_done(rx_done),
        .rx_data(rx_data)
        );

endmodule
