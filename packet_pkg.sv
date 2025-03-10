package packet_pkg;
    // Define packet structure (10-byte packets)
    typedef struct packed {
        logic [7:0] byte0;
        logic [7:0] byte1;
        logic [7:0] byte2;
        logic [7:0] byte3;
        logic [7:0] byte4;
        logic [7:0] byte5;
        logic [7:0] byte6;
        logic [7:0] byte7;
        logic [7:0] byte8;
        logic [7:0] byte9;
    } packet_t;
endpackage

