`timescale 1ns/1ps

module uart_tb;

parameter CLKS_PER_BIT = 10;

reg clk;
reg reset;
reg tx_start;
reg [7:0] tx_data;

wire tx;
wire tx_busy;

integer errors;
integer tests;
integer i;

UART dut (
    .clk(clk),
    .reset(reset),
    .tx_start(tx_start),
    .tx_data(tx_data),
    .tx(tx),
    .tx_busy(tx_busy)
);

always #50 clk = ~clk;

task wait_bit;
integer j;
begin
    for (j = 0; j < CLKS_PER_BIT; j = j + 1)
        @(posedge clk);
end
endtask

task transmit;
input [7:0] data;
begin
    @(negedge clk);
    tx_data = data;
    tx_start = 1'b1;

    @(negedge clk);
    tx_start = 1'b0;
end
endtask

task check_frame;
input [7:0] expected_data;
begin

    wait(tx_busy == 1'b1);

    @(negedge clk);

    tests = tests + 1;
    if (tx !== 1'b0) begin
        $display("ERROR START Expected=0 Got=%b Time=%0t", tx, $time);
        errors = errors + 1;
    end
    else begin
        $display("PASS START");
    end

    wait_bit;

    for (i = 0; i < 8; i = i + 1) begin

        @(negedge clk);

        tests = tests + 1;

        if (tx !== expected_data[i]) begin
            $display("ERROR D%0d Expected=%b Got=%b Time=%0t",
                     i, expected_data[i], tx, $time);
            errors = errors + 1;
        end
        else begin
            $display("PASS D%0d = %b", i, tx);
        end

        wait_bit;

    end

    @(negedge clk);

    tests = tests + 1;

    if (tx !== 1'b1) begin
        $display("ERROR STOP Expected=1 Got=%b Time=%0t", tx, $time);
        errors = errors + 1;
    end
    else begin
        $display("PASS STOP");
    end

    wait_bit;

    @(negedge clk);

    tests = tests + 1;

    if (tx_busy !== 1'b0) begin
        $display("ERROR BUSY should be 0");
        errors = errors + 1;
    end
    else begin
        $display("PASS BUSY = 0");
    end

    if (tx !== 1'b1) begin
        $display("ERROR TX should be 1 in IDLE");
        errors = errors + 1;
    end
    else begin
        $display("PASS TX = 1 in IDLE");
    end

end
endtask

initial begin

    clk = 1'b0;
    reset = 1'b1;
    tx_start = 1'b0;
    tx_data = 8'h00;

    errors = 0;
    tests = 0;

    #200;

    reset = 1'b0;

    @(negedge clk);

    tests = tests + 1;

    if (tx !== 1'b1) begin
        $display("ERROR TX after reset");
        errors = errors + 1;
    end
    else begin
        $display("PASS TX after reset");
    end

    tests = tests + 1;

    if (tx_busy !== 1'b0) begin
        $display("ERROR BUSY after reset");
        errors = errors + 1;
    end
    else begin
        $display("PASS BUSY after reset");
    end

    transmit(8'h41);
    check_frame(8'h41);

    transmit(8'h00);
    check_frame(8'h00);

    transmit(8'hFF);
    check_frame(8'hFF);

    transmit(8'hA5);
    check_frame(8'hA5);

    transmit(8'h5A);
    check_frame(8'h5A);

    transmit(8'hAA);
    check_frame(8'hAA);

    transmit(8'h55);
    check_frame(8'h55);

    transmit(8'h3C);
    check_frame(8'h3C);

    #200;

    $display("");
    $display("TOTAL TESTS = %0d", tests);
    $display("TOTAL ERRORS = %0d", errors);

    if (errors == 0)
        $display("ALL TESTS PASSED");
    else
        $display("TEST FAILED");

    #100;

    $finish;

end

initial begin
    $dumpfile("uart.vcd");
    $dumpvars(0, uart_tb);
end

initial begin
    $monitor("TIME=%0t CLK=%b RESET=%b START=%b DATA=%h TX=%b BUSY=%b STATE=%b BAUD=%d BIT=%d",
             $time, clk, reset, tx_start, tx_data, tx, tx_busy,
             dut.state, dut.baud_counter, dut.bit_counter);
end

endmodule
