module apb_uart_tb;
reg pclk,presetn,penable,pwrite,psel;
reg [31:0]pwdata,paddr;
wire [31:0]prdata;
wire pready,tx,tx_done,rx_done;
wire serial_line;
reg [31:0] read_value;

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
task apb_write;
input [31:0]paddr_in;
input [7:0]data_in;

begin
    @(posedge pclk);
    pwdata={24'b0,data_in};
    paddr=paddr_in;
    psel=1;
    penable=0;
    pwrite=1;

    @(posedge pclk);
    penable=1;

    wait (pready==1);

    @(posedge pclk);
    psel=0;
    penable=0;
end

endtask

task apb_read;
input [31:0]addr_in;
output [31:0]data_out;

begin
    @(posedge pclk);
     paddr=addr_in;
     psel=1;
     pwrite=0;
     penable=0;

     @(posedge pclk);
     penable=1;

     wait (pready==1);

     @(posedge pclk);
     #1;

     data_out=prdata;

     $display("at Time=%0t read data from address %h = %h",$time,addr_in,data_out);

     @(posedge pclk);
     psel=0;
     penable=0;
end
endtask


initial begin
    pclk=0;
    presetn=0;
    psel=0;
    penable=0;
    pwrite=0;
    @(posedge pclk);
    presetn=1;
    @(posedge pclk);
    $display("wtrite first data");
    apb_write(32'h0000,8'h55);
    @(posedge pclk);
    $display("write second data");
    apb_write(32'h0004,8'h01);
    
    @(posedge rx_done);
    $display("rx completed");
    @(posedge pclk);

    $display("reading final data");
    apb_read(32'h0008,read_value);

    #200;
    $finish;
end

initial begin
    $dumpfile("apb_uart.vcd");
    $dumpvars(0,apb_uart_tb);
end
endmodule