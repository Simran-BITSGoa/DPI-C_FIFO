`timescale 1ns/1ps

module testbench;

    import "DPI-C" function void request_packet(output byte pkt[10]);

    logic write_clk, read_clk, rst, write_en, read_en;
    logic [79:0] data_in;
    logic [79:0] data_out;
    logic full, empty;
    string read_str;

    // Instantiate FIFO
    fifo fifo_inst (
        .write_clk(write_clk),
        .read_clk(read_clk),
        .rst(rst),
        .write_en(write_en),
        .read_en(read_en),
        .data_in(data_in),
        .data_out(data_out),
        .full(full),
        .empty(empty)
    );

    // Clock Generation
    always #5 write_clk = ~write_clk;  // 10ns period
    always #7 read_clk = ~read_clk;    // 14ns period

    initial begin
        write_clk = 0;
        read_clk = 0;
        rst = 1;
        write_en = 0;
        read_en = 0;
        data_in = 0;

        #50 rst = 0;  // Hold reset longer

        // Print initial FIFO status
        $display("[TB] Time=%0t | FULL=%b | EMPTY=%b", $time, full, empty);

        // **Write Until Full**
        while (!full) begin
            byte pkt[10];
            request_packet(pkt);
            
            // Convert byte array to 80-bit logic
            for (int j = 0; j < 10; j++) begin
                data_in[j*8 +: 8] = pkt[j];  
            end

            write_en = 1;
            #15;  // Hold write enable for multiple cycles
            write_en = 0;
            #20;

            $display("[TB] Time=%0t | FULL=%b | EMPTY=%b", $time, full, empty);
        end
        $display("[TB] FIFO FULL: Stopping Writes!");

        // **Start Reading Until Empty**
        while (!empty) begin
            read_en = 1;
            #15;  // Keep read enable high longer
            read_en = 0;
            #10;  // Allow FIFO output to settle
            
            // Reset read_str before accumulating characters
            read_str = "";
            for (int i = 0; i < 10; i++) begin
                read_str = {read_str, data_out[i*8 +: 8]};
            end
            $display("[SV] Read Data: %s", read_str);
            $display("[TB] Time=%0t | FULL=%b | EMPTY=%b", $time, full, empty);

            #20;
        end
        $display("[TB] FIFO EMPTY: Stopping Reads!");

        #100 $finish;
    end

endmodule

