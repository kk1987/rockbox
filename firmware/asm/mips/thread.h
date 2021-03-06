/***************************************************************************
 *             __________               __   ___.
 *   Open      \______   \ ____   ____ |  | _\_ |__   _______  ___
 *   Source     |       _//  _ \_/ ___\|  |/ /| __ \ /  _ \  \/  /
 *   Jukebox    |    |   (  <_> )  \___|    < | \_\ (  <_> > <  <
 *   Firmware   |____|_  /\____/ \___  >__|_ \|___  /\____/__/\_ \
 *                     \/            \/     \/    \/            \/
 * $Id$
 *
 * Copyright (C) 2002 by Ulf Ralberg
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This software is distributed on an "AS IS" basis, WITHOUT WARRANTY OF ANY
 * KIND, either express or implied.
 *
 ****************************************************************************/

/* index offset register
 *  0     0     $16 s0
 *  1     4     $17 s1
 *  2     8     $18 s2
 *  3    12     $19 s3
 *  4    16     $20 s4
 *  5    20     $21 s5
 *  6    24     $22 s6
 *  7    28     $23 s7
 *  8    32     $28 gp
 *  9    36     $30 s8 (s8)
 * 10    40     $29 sp
 * 11    44     $31 ra
 * 12    48     start
 */
struct regs
{
    uint32_t r[10]; /* 0-32 - Registers s0-s7, gp, fp */
    uint32_t sp;    /*   36 - Stack pointer */
    uint32_t ra;    /*   40 - Return address */
    uint32_t start; /*   44 - Thread start address, or NULL when started */
};

#define DEFAULT_STACK_SIZE 0x400 /* Bytes */

