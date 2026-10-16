// SPDX-License-Identifier: GPL-3.0-or-later
#include "bmwlink/bmwlink.h"

#if defined(__APPLE__)
#include <TargetConditionals.h>
#endif

#if defined(__APPLE__) && TARGET_OS_IOS
#include "link/platform/apple/LinkPortableCore.c"
#endif

const char *bmwlink_product_name(void){return "BMWLINK";}
const char *bmwlink_brand_name(void){return "BMW";}
const char *bmwlink_version(void){return BMWLINK_VERSION;}
