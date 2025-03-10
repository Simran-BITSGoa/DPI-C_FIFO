#include <stdio.h>
#include <stdlib.h>
#include <time.h>

// Function called by SystemVerilog to request a packet
void request_packet(unsigned char pkt[10]) {
    static int packet_count = 0;
    static int seeded = 0;  // Ensures srand() runs only once

    // Seed the random number generator only once
    if (!seeded) {
        srand(time(NULL));
        seeded = 1;
    }

    // Generate a random alphanumeric packet (A-Z, a-z, 0-9)
    for (int i = 0; i < 10; i++) {
        int rand_val = rand() % 62; // 26 uppercase + 26 lowercase + 10 digits
        if (rand_val < 26)
            pkt[i] = 'A' + rand_val;  // Uppercase A-Z
        else if (rand_val < 52)
            pkt[i] = 'a' + (rand_val - 26);  // Lowercase a-z
        else
            pkt[i] = '0' + (rand_val - 52);  // Digits 0-9
    }

    packet_count++;

    printf("[C] Generated packet %d: ", packet_count);
    for (int i = 0; i < 10; i++) {
        printf("%c", pkt[i]);  // Print each character without null termination
    }
    printf("\n");
}

