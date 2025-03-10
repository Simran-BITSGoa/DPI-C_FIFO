module testbench;
    import "DPI-C" function void send_packet(output logic [7:0] pkt);
    import "DPI-C" function void request_packet();

    logic write_clk = 0, read_clk = 0;
    logic write_en, read_en;
    logic [7:0] packet_in;   // Single byte
    logic [7:0] packet_out;  // Single byte
    logic fifo_full, fifo_empty;

    fifo dut (
        .write_clk(write_clk),
        .read_clk(read_clk),
        .write_en(write_en),
        .read_en(read_en),
        .data_in(packet_in),   // Single byte
        .data_out(packet_out), // Single byte
        .full(fifo_full),
        .empty(fifo_empty)
    );

    always #10 write_clk = ~write_clk;  // 50 MHz ? 20 ns period
    always #20 read_clk = ~read_clk;    // 25 MHz ? 40 ns period

    initial begin
        request_packet();  // Reset message index

        repeat (13) begin  // Send 13 characters of "Hello, World!"
            if (!fifo_full) begin
                send_packet(packet_in);
                write_en = 1;
            end else begin
                write_en = 0;
            end
            #20;  // Write clock period
        end
        write_en = 0;  // Stop writing

        #100;

        repeat (13) begin  // Read all 13 characters
            if (!fifo_empty) begin
                read_en = 1;
            end else begin
                read_en = 0;
            end
            #40;  // Read clock period
        end
        read_en = 0;  // Stop reading

        #100;
        $finish;
    end
endmodule

