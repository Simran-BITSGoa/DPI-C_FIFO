`timescale 1ns/1ps

module fifo #(parameter DEPTH = 70) (
    input logic write_clk,
    input logic read_clk,
    input logic rst,  // Active-high reset
    input logic write_en,
    input logic read_en,
    input logic [79:0] data_in,
    output logic [79:0] data_out,
    output logic full,
    output logic empty
);

    localparam PTR_WIDTH = $clog2(DEPTH);

    logic [79:0] mem [DEPTH-1:0]; 
    logic [PTR_WIDTH:0] write_ptr, read_ptr;
    logic [PTR_WIDTH:0] write_ptr_gray, read_ptr_gray;
    logic [PTR_WIDTH:0] wptr_sync1, wptr_sync2;
    logic [PTR_WIDTH:0] rptr_sync1, rptr_sync2;

    // **Convert Binary to Gray Code**
    function automatic logic [PTR_WIDTH:0] bin_to_gray(input logic [PTR_WIDTH:0] bin);
        return (bin >> 1) ^ bin;
    endfunction

    // **Convert Gray Code to Binary**
    function automatic logic [PTR_WIDTH:0] gray_to_bin(input logic [PTR_WIDTH:0] gray);
        logic [PTR_WIDTH:0] bin;
        bin = gray[PTR_WIDTH];  // MSB is the same
        for (int i = PTR_WIDTH-1; i >= 0; i--) 
            bin[i] = bin[i+1] ^ gray[i];
        return bin;
    endfunction

    // **Write Operation**
    always_ff @(posedge write_clk or posedge rst) begin
        if (rst) begin
            write_ptr <= 0;
            write_ptr_gray <= 0;
        end else if (write_en && !full) begin
            mem[write_ptr[PTR_WIDTH-1:0]] <= data_in;
            write_ptr <= write_ptr + 1;
            write_ptr_gray <= bin_to_gray(write_ptr + 1);
        end
    end

    // **Read Operation**
    always_ff @(posedge read_clk or posedge rst) begin
        if (rst) begin
            read_ptr <= 0;
            read_ptr_gray <= 0;
            data_out <= 0;
        end else if (read_en && !empty) begin
            data_out <= mem[read_ptr[PTR_WIDTH-1:0]];
            read_ptr <= read_ptr + 1;
            read_ptr_gray <= bin_to_gray(read_ptr + 1);
        end
    end

    // **Synchronize write pointer into read domain**
    always_ff @(posedge read_clk or posedge rst) begin
        if (rst) begin
            wptr_sync1 <= 0;
            wptr_sync2 <= 0;
        end else begin
            wptr_sync1 <= write_ptr_gray;
            wptr_sync2 <= wptr_sync1;
        end
    end

    // **Synchronize read pointer into write domain**
    always_ff @(posedge write_clk or posedge rst) begin
        if (rst) begin
            rptr_sync1 <= 0;
            rptr_sync2 <= 0;
        end else begin
            rptr_sync1 <= read_ptr_gray;
            rptr_sync2 <= rptr_sync1;
        end
    end

    // **Convert synchronized Gray codes back to Binary for comparison**
    logic [PTR_WIDTH:0] wptr_bin, rptr_bin;
    assign wptr_bin = gray_to_bin(write_ptr_gray);
    assign rptr_bin = gray_to_bin(rptr_sync2);

    // **? Fixed Full and Empty Conditions**
    always_ff @(posedge write_clk or posedge rst) begin
        if (rst)
            full <= 0;
        else
            full <= ((write_ptr - read_ptr) == DEPTH);
    end

    always_ff @(posedge read_clk or posedge rst) begin
        if (rst)
            empty <= 1;
        else
            empty <= (write_ptr == read_ptr);
    end

endmodule

