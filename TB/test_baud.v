module baud_generater_test;
reg clk,rst;
wire baud_tick;

always #1 clk=~clk;
baud_generater #(
.system_frq(100),
.baud_rate(10)
)
    uut(
    .clk(clk), 
    .rst(rst),
    .baud_tick(baud_tick)
);

initial begin
    $dumpfile("baud.vcd");
    $dumpvars(0,baud_generater_test);

end
    always @(posedge clk) begin
        if (baud_tick) begin
        $display("[Success]baud tick generated at %0t",$time);
        end
end
initial begin
    clk=0;
    rst=1;
    #4;
    rst=0;
    #200;
$finish;
end
    
endmodule