module apb_uart_tb;
reg pclk,presetn,penable,pwrite,psel;
reg [31:0]pwdata,paddr;
wire [31:0]prdata;
wire pready,tx,tx_done,rx_done;
wire serial_line;

always #1 pclk=~pclk;

apb_uart #(
    .system_frq(1600),
    .baud_rate(20)
)apb_uart1(
    .pclk(pclk),
    .presetn(presetn),
    .pwrite(pwrite),
    .penable(penable),
    .psel(psel),
    .rx(serial_line),
    .pwdata(pwdata),
    .paddr(paddr),
    .prdata(prdata),
    .pready(pready),
    .tx(serial_line),
    .tx_done(tx_done),
    .rx_done(rx_done)
);

initial begin
    pclk=0;
    presetn=0;
    psel=0;
    pwrite=0;
    penable=0;
    pwdata=0;
    paddr=0;
    @(posedge pclk);
    @(posedge pclk);
    presetn=1;
    @(posedge pclk);
    psel=1;
    paddr=32'h0000;
    pwdata=32'h0055;
    penable=0;
    pwrite=1;
    @(posedge pclk);
    penable=1;
     wait (pready==1);
    @(posedge pclk);
    penable=0;
    psel=0;
    

    @(posedge pclk);
    psel=1;
    pwdata=32'h0001;
    pwrite=1;
    paddr=32'h0004;
    @(posedge pclk);
    penable=1;
     wait (pready==1);
    @(posedge pclk);
    penable=0;
    psel=0;

    @(posedge rx_done);

    psel=1;
    paddr=32'h0008;
    pwrite=0;
    penable=0;

    @(posedge pclk);
    penable=1;
    wait (pready==1);
    @(posedge pclk);
    penable=0;
    psel=0;

    #100;

    $finish;
end
initial begin
    $dumpfile("abp_uart1.vcd");
    $dumpvars(0,apb_uart_tb);
end
endmodule