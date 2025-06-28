#include <stdio.h>
#include <fcntl.h>
#include <sys/mman.h>
#include "./physical.h"
#include "../address_map_arm.h"

#define CUSTOM_BLOCK_BASE 0xFF200000 // Cambia esto por la dirección real
#define CUSTOM_BLOCK_SPAN 0x100

int open_physical(int);
void *map_physical(int, unsigned int, unsigned int);
void close_physical(int);
int unmap_physical(void *, unsigned int);

int main(void)
{
    volatile int *reg_ptr;
    int fd = -1;
    void *lw_virtual;

    if ((fd = open_physical(fd)) == -1)
        return (-1);
    if (!(lw_virtual = map_physical(fd, CUSTOM_BLOCK_BASE, CUSTOM_BLOCK_SPAN)))
        return (-1);

    reg_ptr = (int *)lw_virtual;
    for (int i = 0; i < 16; i++)
    {
        reg_ptr[i] = i; // Escribe valor i en la dirección i
    }

    unmap_physical(lw_virtual, CUSTOM_BLOCK_SPAN);
    close_physical(fd);
    return 0;
}
