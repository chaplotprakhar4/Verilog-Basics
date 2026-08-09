module traffic_controller_tb;

reg clk;
reg reset;
reg ped_button;

wire red;
wire yellow;
wire green;
wire ped_walk;
wire ped_dont_walk;
wire [3:0] ped_counter;

traffic_controller uut (
    .clk(clk),
    .reset(reset),
    .ped_button(ped_button),
    .red(red),
    .yellow(yellow),
    .green(green),
    .ped_walk(ped_walk),
    .ped_dont_walk(ped_dont_walk),
    .ped_counter(ped_counter)
);

always #5 clk = ~clk;

initial begin

    clk = 0;
    reset = 1;
    ped_button = 0;

    $dumpfile("dump.vcd");
    $dumpvars(0, traffic_controller_tb);

    $display("TIME RESET PED_BUTTON RED YELLOW GREEN WALK DONT_WALK");

    $monitor("%0t %b %b %b %b %b %b %b",
             $time,
             reset,
             ped_button,
             red,
             yellow,
             green,
             ped_walk,
             ped_dont_walk);

    #10;
    reset = 0;

    #60;
    ped_button = 1;

    #10;
    ped_button = 0;

    #200;

    $finish;

end

endmodule
module traffic_controller_tb;

reg clk;
reg reset;
reg ped_button;

wire red;
wire yellow;
wire green;
wire ped_walk;
wire ped_dont_walk;
wire [3:0] ped_counter;

traffic_controller uut (
    .clk(clk),
    .reset(reset),
    .ped_button(ped_button),
    .red(red),
    .yellow(yellow),
    .green(green),
    .ped_walk(ped_walk),
    .ped_dont_walk(ped_dont_walk),
    .ped_counter(ped_counter)
);

always #5 clk = ~clk;

initial begin

    $display("==============================================");
    $display("TRAFFIC LIGHT PEDESTRIAN CONTROLLER");
    $display("==============================================");

    $monitor("TIME=%0t CLK=%b RESET=%b PED_BTN=%b RED=%b YELLOW=%b GREEN=%b WALK=%b DONT_WALK=%b PED_COUNT=%d",
             $time, clk, reset, ped_button,
             red, yellow, green,
             ped_walk, ped_dont_walk, ped_counter);

    $dumpfile("dump.vcd");
    $dumpvars(0, traffic_controller_tb);

    clk = 0;
    reset = 1;
    ped_button = 0;

    #10;

    reset = 0;

    #60;

    ped_button = 1;
    #10;
    ped_button = 0;

    #150;

    ped_button = 1;
    #10;
    ped_button = 0;

    #150;

    $display("==============================================");
    $display("SIMULATION COMPLETED");
    $display("==============================================");

    $finish;

end

endmodule
