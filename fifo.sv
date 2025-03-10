module fifo #(parameter DEPTH = 50) (
    input logic write_clk,
    input logic read_clk,
    input logic write_en,
    input logic read_en,
    input logic [7:0] data_in,  // Single byte per packet
    output logic [7:0] data_out, // Single byte per packet
    output logic full,
    output logic empty
);
    logic [7:0] mem [DEPTH];  // Storage for 50 characters
    int write_ptr = 0, read_ptr = 0, count = 0;

    assign full = (count == DEPTH);
    assign empty = (count == 0);

    always_ff @(posedge write_clk) begin
        if (write_en && !full) begin
            mem[write_ptr] = data_in;
            write_ptr = (write_ptr + 1) % DEPTH;
            count++;
        end
    end

    always_ff @(posedge read_clk) begin
        if (read_en && !empty) begin
            data_out = mem[read_ptr];
            read_ptr = (read_ptr + 1) % DEPTH;
            count--;
        end
    end
endmodule

