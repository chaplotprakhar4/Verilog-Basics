`timescale 1ns/1ps

module UART (
    input clk,
    input reset,
    input tx_start,
    input [7:0] tx_data,
    output reg tx_busy,
    output reg tx
);

reg [7:0] data_reg;
reg [3:0] baud_counter;
reg [2:0] bit_counter;
reg [1:0] state;

parameter IDLE  = 2'b00;
parameter START = 2'b01;
parameter DATA  = 2'b10;
parameter STOP  = 2'b11;

parameter CLKS_PER_BIT = 10;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        tx <= 1'b1;
        tx_busy <= 1'b0;
        data_reg <= 8'd0;
        baud_counter <= 4'd0;
        bit_counter <= 3'd0;
        state <= IDLE;
    end
    else begin
        case (state)

            IDLE: begin
                tx <= 1'b1;
                tx_busy <= 1'b0;
                baud_counter <= 4'd0;
                bit_counter <= 3'd0;

                if (tx_start) begin
                    data_reg <= tx_data;
                    tx_busy <= 1'b1;
                    state <= START;
                end
            end

            START: begin
                tx <= 1'b0;

                if (baud_counter == CLKS_PER_BIT - 1) begin
                    baud_counter <= 4'd0;
                    bit_counter <= 3'd0;
                    state <= DATA;
                end
                else begin
                    baud_counter <= baud_counter + 1'b1;
                end
            end

            DATA: begin
                tx <= data_reg[bit_counter];

                if (baud_counter == CLKS_PER_BIT - 1) begin
                    baud_counter <= 4'd0;

                    if (bit_counter == 3'd7) begin
                        state <= STOP;
                    end
                    else begin
                        bit_counter <= bit_counter + 1'b1;
                    end
                end
                else begin
                    baud_counter <= baud_counter + 1'b1;
                end
            end

            STOP: begin
                tx <= 1'b1;

                if (baud_counter == CLKS_PER_BIT - 1) begin
                    baud_counter <= 4'd0;
                    tx_busy <= 1'b0;
                    state <= IDLE;
                end
                else begin
                    baud_counter <= baud_counter + 1'b1;
                end
            end

            default: begin
                tx <= 1'b1;
                tx_busy <= 1'b0;
                baud_counter <= 4'd0;
                bit_counter <= 3'd0;
                state <= IDLE;
            end

        endcase
    end
end

endmodule
