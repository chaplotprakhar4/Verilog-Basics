module or_gate_tb();
reg a,b;
wire c;
integer i;
or_gate uut(.a(a),.b(b),.c(c));
initial begin
    $display("time a b or_gate");
    $monitor("%0t %b %b %b",$time,a,b,c);
    $dumpfile("or_wave.vcd");
    $dumpvars(0, or_gate_tb);
    for (i=0;i<4;i=i+1)
    begin
        {a,b}=i;
        #10;
    end
    $finish;

end
endmodule