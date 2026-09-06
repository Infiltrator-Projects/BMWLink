// SPDX-License-Identifier: GPL-3.0-or-later
#if defined(__APPLE__)
#include <TargetConditionals.h>
#endif
#if defined(__APPLE__) && TARGET_OS_IOS
#include "../link/platform/apple/LinkPortableObd2.c"
#else
typedef int bmwlink_obd2_translation_unit;
#endif
