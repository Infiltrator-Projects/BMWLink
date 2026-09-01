// SPDX-License-Identifier: GPL-3.0-or-later
#include "bmwlink/bmwlink.h"
#include <stdio.h>
#include <string.h>
int main(void){
 if(strcmp(bmwlink_product_name(),"BMWLINK")!=0) return 1;
 if(strcmp(bmwlink_brand_name(),"BMW")!=0) return 2;
 if(strcmp(bmwlink_version(),"0.1.1")!=0) return 3;
 puts("BMWLINK skeleton smoke test passed");
 return 0;
}
