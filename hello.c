#include <stdio.h>
#include <string.h>

static const char *message = "Hello, World!";
static int msg_index = 0;  // Renamed from "index" to "msg_index"

void send_packet(unsigned char *pkt) {
    if (msg_index < strlen(message)) {
        *pkt = message[msg_index];
        printf("[C] Sent packet: %c\n", *pkt);
        msg_index++;
    } else {
        *pkt = '\0';  // Send null character when finished
    }
}

void request_packet() {
    msg_index = 0;  // Reset index
    printf("[C] Reset packet index\n");
}

