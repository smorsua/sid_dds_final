#include <stdio.h>
#include <fcntl.h>
#include <sys/mman.h>
#include "../address_map_arm.h"

/* Prototypes for functions used to access physical memory addresses */
int open_physical(int);
void *map_physical(int, unsigned int, unsigned int);
void close_physical(int);
int unmap_physical(void *, unsigned int);

/* This program increments the contents of the red LED parallel port */
int main(void)
{
    volatile int *LEDR_ptr; // virtual address pointer to red LEDs
    int fd = -1;            // used to open /dev/mem
    void *LW_virtual;       // physical addresses for light-weight bridge

    // Create virtual memory access to the FPGA light-weight bridge
    if ((fd = open_physical(fd)) == -1)
        return (-1);
    if (!(LW_virtual = map_physical(fd, LW_BRIDGE_BASE, LW_BRIDGE_SPAN)))
        return (-1);

    // Set virtual address pointer to I/O port
    LEDR_ptr = (int *)(LW_virtual + LEDR_BASE);
    *LEDR_ptr = *LEDR_ptr + 1; // Add 1 to the I/O register

    unmap_physical(LW_virtual, LW_BRIDGE_SPAN);
    close_physical(fd);
    return 0;
}

