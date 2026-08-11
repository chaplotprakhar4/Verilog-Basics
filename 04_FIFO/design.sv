module fifo (
    input clk,
    input reset,
    input write_enable,
    input read_enable,
    input [3:0] write_data,
    output reg [3:0] read_data,
    output reg full,
    output reg empty
);

reg [3:0] memory [0:15];
reg [3:0] write_ptr;
reg [3:0] read_ptr;
reg [4:0] count;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        write_ptr <= 4'd0;
        read_ptr <= 4'd0;
        count <= 5'd0;
        read_data <= 4'd0;
        full <= 1'b0;
        empty <= 1'b1;
    end
    else begin

        if (write_enable && !full) begin
            memory[write_ptr] <= write_data;
            write_ptr <= write_ptr + 1'b1;
        end

        if (read_enable && !empty) begin
            read_data <= memory[read_ptr];
            read_ptr <= read_ptr + 1'b1;
        end

        case ({write_enable && !full, read_enable && !empty})

            2'b10: begin
                count <= count + 1'b1;

                if (count == 5'd15)
                    full <= 1'b1;

               else empty <= 1'b0;
            end

            2'b01: begin
                count <= count - 1'b1;

                if (count == 5'd1)
                    empty <= 1'b1;

                else full <= 1'b0;
            end

            2'b11: begin
                count <= count;
                full <= full;
                empty <= empty;
            end

            2'b00: begin
                count <= count;
                full <= full;
                 empty <= empty;
            end

        endcase
    end
end

endmodule
