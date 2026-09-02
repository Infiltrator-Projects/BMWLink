// SPDX-License-Identifier: GPL-3.0-or-later
#include "bmwlink/bmwlink.h"
#include <stdio.h>
#include <string.h>

#ifndef BMWLINK_EXPECTED_VERSION
#error "BMWLINK_EXPECTED_VERSION must be supplied by the build"
#endif

int main(void)
{
    if (strcmp(bmwlink_product_name(), "BMWLINK") != 0)
        return 1;
    if (strcmp(bmwlink_brand_name(), "BMW") != 0)
        return 2;
    if (strcmp(bmwlink_version(), BMWLINK_EXPECTED_VERSION) != 0)
        return 3;

    puts("BMWLINK GUI product smoke test passed");
    return 0;
}
