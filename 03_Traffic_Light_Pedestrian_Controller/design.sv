module traffic_controller #(
    parameter RED_TIME    = 5,
    parameter GREEN_TIME  = 10,
    parameter YELLOW_TIME = 3,
    parameter PED_TIME    = 3
)(
    input wire clk,
    input wire reset,
    input wire ped_button,

    output reg red,
    output reg yellow,
    output reg green,
    output reg ped_walk,
    output reg ped_dont_walk,
    output reg [3:0] ped_counter
);

    localparam RED    = 2'b00;
    localparam GREEN  = 2'b01;
    localparam YELLOW = 2'b10;

    reg [1:0] state;
    reg [3:0] counter;
    reg ped_request;
    reg ped_active;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state       <= RED;
            counter     <= 4'd0;
            ped_request <= 1'b0;
            ped_active  <= 1'b0;
            ped_counter <= 4'd0;
        end
        else begin

            if (ped_button)
                ped_request <= 1'b1;

            case (state)

                RED: begin

                    if (ped_request && !ped_active) begin
                        ped_active  <= 1'b1;
                        ped_counter <= PED_TIME;
                    end

                    if (ped_active) begin
                        if (ped_counter == 4'd1) begin
                            ped_active  <= 1'b0;
                            ped_counter <= 4'd0;
                            ped_request <= 1'b0;
                            counter     <= 4'd0;
                        end
                        else begin
                            ped_counter <= ped_counter - 1'b1;
                        end
                    end
                    else if (counter == RED_TIME - 1) begin
                        state   <= GREEN;
                        counter <= 4'd0;
                    end
                    else begin
                        counter <= counter + 1'b1;
                    end
                end

                GREEN: begin
                    if (counter == GREEN_TIME - 1) begin
                        state   <= YELLOW;
                        counter <= 4'd0;
                    end
                    else begin
                        counter <= counter + 1'b1;
                    end
                end

                YELLOW: begin
                    if (counter == YELLOW_TIME - 1) begin
                        state   <= RED;
                        counter <= 4'd0;
                    end
                    else begin
                        counter <= counter + 1'b1;
                    end
                end

                default: begin
                    state       <= RED;
                    counter     <= 4'd0;
                    ped_request <= 1'b0;
                    ped_active  <= 1'b0;
                    ped_counter <= 4'd0;
                end

            endcase
        end
    end

    always @(*) begin

        red           = 1'b0;
        yellow        = 1'b0;
        green         = 1'b0;
        ped_walk      = 1'b0;
        ped_dont_walk = 1'b1;

        case (state)

            RED: begin
                red = 1'b1;

                if (ped_active) begin
                    ped_walk      = 1'b1;
                    ped_dont_walk = 1'b0;
                end
            end

            GREEN: begin
                green         = 1'b1;
                ped_dont_walk = 1'b1;
            end

            YELLOW: begin
                yellow        = 1'b1;
                ped_dont_walk = 1'b1;
            end

            default: begin
                red           = 1'b1;
                ped_dont_walk = 1'b1;
            end

        endcase
    end

