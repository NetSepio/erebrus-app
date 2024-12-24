// SPDX-License-Identifier: MIT
// Copyright © 2018-2023 WireGuard LLC. All Rights Reserved.

#include "key.h"
#include "x25519.h"

/* From <sys/kern_control.h> */
#define CTLIOCGINFO 0xc0644e03UL
struct ctl_info {
    int   ctl_id;
    char        ctl_name[96];
};
struct sockaddr_ctl {
    char      sc_len;
    char      sc_family;
    int   ss_sysaddr;
    int   sc_id;
    int   sc_unit;
    int   sc_reserved[5];
};
