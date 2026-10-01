module apb_uart #(
    parameter system_frq=50000000,
    parameter baud_rate=9600
)(
    input pclk,presetn,pwrite,penable,psel,rx,
    input [31:0]pwdata,paddr,
    output reg [31:0]prdata,
    output reg pready,
    output tx,tx_done,rx_done
);

reg [7:0]data_in;
wire [7:0] rx_data;   
reg [1:0]state;
reg uart_tx_start;
wire uart_rst;

parameter idle =2'b00;
parameter setup =2'b01;
parameter access =2'b10;

assign uart_rst=~presetn;

uart #(
    .system_frq(system_frq),
    .baud_rate(baud_rate)
)uart1(
    .clk(pclk),
    .rst(uart_rst),
    .tx_start(uart_tx_start),
    .rx(rx),
    .data_in(data_in),
    .rx_data(rx_data),
    .rx_done(rx_done),
    .tx(tx),
    .tx_done(tx_done)
);

always @(posedge pclk or negedge presetn) begin
    if (!presetn) begin
       state<=idle;
       prdata<=0;
       uart_tx_start<=0;
       pready<=0;
       data_in<=0;
    end else begin
        case (state)
           idle : begin
            pready<=0;
            uart_tx_start<=0;
            if(psel)begin
                state<=setup;
            end
           end
           setup:begin
            if (penable) begin
                state<=access;
                pready<=1;
            end
           end
           access:begin
            if(pwrite)begin
            case (paddr)
               32'h0000 : data_in<=pwdata[7:0];
               32'h0004 : uart_tx_start<=pwdata[0];
            endcase
            end
            else begin
                case (paddr)
                   32'h0008 : prdata<={24'b0,rx_data};
                   32'h000c : prdata<={31'b0,tx_done};
                   32'h0010 : prdata<={31'b0,rx_done};
                    default: prdata<=0;
                endcase
            end
            state<=idle;
           end
            default: begin
                state<=idle;
            end
        endcase
    end
end
endmodule