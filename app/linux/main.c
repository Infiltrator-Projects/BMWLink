// SPDX-License-Identifier: GPL-3.0-or-later
#include "bmwlink/bmwlink.h"
#include "bmwlink/diagnostics.h"
#include <stdio.h>
#include <string.h>
static void print_capabilities(void){
    printf("BMWLINK %s\n", bmwlink_version());
    puts("Generic standards baseline inherited from LINK:");
    puts("  SAE OBD-II / J1979 live data, readiness, VIN and DTCs");
    puts("  ISO-TP over Classical CAN and CAN FD");
    puts("  UDS standard service catalogue");
    puts("  OBDonUDS and generic SAE DTC knowledge");
    puts("  ELM327 session/CAN/probing");
    puts("  DoIP framing");
    puts("  read-only discovery safety and evidence primitives");
    puts("  parameter scheduling and telemetry foundations");
    puts("BMW-specific proprietary coverage: not claimed yet");
}
int main(int argc,char **argv){
    if(argc==2 && strcmp(argv[1],"--version")==0){ printf("BMWLINK %s\n",bmwlink_version()); return 0; }
    if(argc==1 || (argc==2 && strcmp(argv[1],"--capabilities")==0)){ print_capabilities(); return 0; }
    fprintf(stderr,"Usage: bmwlink [--version|--capabilities]\n"); return 2;
}
