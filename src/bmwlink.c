// SPDX-License-Identifier: GPL-3.0-or-later
#include "bmwlink/bmwlink.h"

#if defined(__APPLE__)
#include <TargetConditionals.h>
#endif

#if defined(__APPLE__) && TARGET_OS_IOS
#ifndef LINK_SOURCE_REVISION
#define LINK_SOURCE_REVISION "a49e349cb434fad9b191b3a68dbf4cc77b14536c"
#define BMWLINK_DEFINED_LINK_SOURCE_REVISION 1
#endif
#include "link/platform/apple/LinkPortableCore.c"
#ifdef BMWLINK_DEFINED_LINK_SOURCE_REVISION
#undef BMWLINK_DEFINED_LINK_SOURCE_REVISION
#undef LINK_SOURCE_REVISION
#endif
#endif

const char *bmwlink_product_name(void){return "BMWLINK";}
const char *bmwlink_brand_name(void){return "BMW";}
const char *bmwlink_version(void){return BMWLINK_VERSION;}
