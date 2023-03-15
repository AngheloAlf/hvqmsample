#include "hasm.h"

.section .start, "ax"

.balign 16

LEAF(__start)
    la $t0, _codeSegmentBssStart
    la $t1, _codeSegmentBssSize

.clear_bss:
    sw      $zero, 0x0($t0)
    sw      $zero, 0x4($t0)
    addi    $t0, $t0, 0x8
    addi    $t1, $t1, -0x8
    bnez    $t1, .clear_bss

.enter_program:
    la $t2, boot
	la $sp, bootStack+STACKSIZE
    jr      $t2
END(__start)
