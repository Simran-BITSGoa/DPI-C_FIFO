package packet_pkg;
  
    // Define packet structure (4-byte packets)
    typedef struct packed {
        logic [7:0] byte0;
        logic [7:0] byte1;
        logic [7:0] byte2;
        logic [7:0] byte3;
    } packet_t;

endpackage

