`timescale 1ns/1ps

module fifo_tb;

reg clk;
reg reset;
reg write_enable;
reg read_enable;
reg [3:0] write_data;

wire [3:0] read_data;
wire full;
wire empty;

integer errors;
integer i;

fifo dut (
    .clk(clk),
    .reset(reset),
    .write_enable(write_enable),
    .read_enable(read_enable),
    .write_data(write_data),
    .read_data(read_data),
    .full(full),
    .empty(empty)
);

always #5 clk = ~clk;

task write_data_task;
input [3:0] data;
begin
    @(negedge clk);
    write_enable = 1'b1;
    read_enable = 1'b0;
    write_data = data;

    @(posedge clk);
    #1;

    write_enable = 1'b0;
end
endtask

task read_data_task;
input [3:0] expected_data;
begin
    @(negedge clk);
    write_enable = 1'b0;
    read_enable = 1'b1;

    @(posedge clk);
    #1;

    if (read_data !== expected_data) begin
        $display("ERROR: Expected %h, Got %h at time %0t",
                 expected_data, read_data, $time);
        errors = errors + 1;
    end

    read_enable = 1'b0;
end
endtask

initial begin

    clk = 1'b0;
    reset = 1'b1;
    write_enable = 1'b0;
    read_enable = 1'b0;
    write_data = 4'd0;
    errors = 0;

    #12;
    reset = 1'b0;

    #1;

    if (!empty) begin
        $display("ERROR: FIFO is not empty after reset");
        errors = errors + 1;
    end

    if (full) begin
        $display("ERROR: FIFO is full after reset");
        errors = errors + 1;
    end

    write_data_task(4'h1);
    write_data_task(4'h2);
    write_data_task(4'h3);
    write_data_task(4'h4);

    read_data_task(4'h1);
    read_data_task(4'h2);
    read_data_task(4'h3);
    read_data_task(4'h4);

    #1;

    if (!empty) begin
        $display("ERROR: FIFO should be empty");
        errors = errors + 1;
    end

    for (i = 0; i < 16; i = i + 1) begin
        write_data_task(i[3:0]);
    end

    #1;

    if (!full) begin
        $display("ERROR: FIFO should be full");
        errors = errors + 1;
    end

    write_data_task(4'hF);

    read_data_task(4'h0);
    read_data_task(4'h1);
    read_data_task(4'h2);
    read_data_task(4'h3);

    write_data_task(4'hA);
    write_data_task(4'hB);
    write_data_task(4'hC);
    write_data_task(4'hD);

    read_data_task(4'h4);
    read_data_task(4'h5);
    read_data_task(4'h6);
    read_data_task(4'h7);

    reset = 1'b1;

    #10;

    reset = 1'b0;

    #1;

    if (!empty) begin
        $display("ERROR: FIFO should be empty after second reset");
        errors = errors + 1;
    end

    if (errors == 0) begin
        $display("=================================");
        $display("ALL TESTS PASSED");
        $display("=================================");
    end
    else begin
        $display("=================================");
        $display("TEST FAILED");
        $display("ERRORS = %0d", errors);
        $display("=================================");
    end

    #10;
    $finish;

end

initial begin
    $monitor("TIME=%0t CLK=%b RESET=%b WE=%b RE=%b WD=%h RD=%h FULL=%b EMPTY=%b COUNT=%d WP=%d RP=%d",
             $time, clk, reset, write_enable, read_enable,
             write_data, read_data, full, empty,
             dut.count, dut.write_ptr, dut.read_ptr);
end

initial begin
    $dumpfile("fifo.vcd");
    $dumpvars(0, fifo_tb);
end

endmodule
