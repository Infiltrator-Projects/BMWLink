// SPDX-License-Identifier: GPL-3.0-or-later
#include "bmwlink/obd2.h"
#include <stdio.h>
#include <string.h>
#define CHECK(x) do { if (!(x)) { fprintf(stderr, "FAIL: %s\n", #x); return 1; } } while (0)
int main(void)
{
    char command[16], dtc[LINK_OBD2_DTC_TEXT_LENGTH];
    uint16_t did = 0U;
    uint8_t rpm_payload[] = { 0x1aU, 0xf8U };
    BmwlinkObd2DecodedPid decoded;
    CHECK(bmwlink_obd2_pid_definition_count() > 0U);
    CHECK(bmwlink_obd2_mode01_assigned_count() > 0U);
    CHECK(bmwlink_obd2_build_supported_pid_request(0x00U, command, sizeof(command)) == BMWLINK_OBD2_RESULT_OK);
    CHECK(strcmp(command, "0100") == 0);
    CHECK(bmwlink_obd2_build_live_pid_request(0x0cU, command, sizeof(command)) == BMWLINK_OBD2_RESULT_OK);
    CHECK(strcmp(command, "010C") == 0);
    CHECK(bmwlink_obd2_build_vin_request(command, sizeof(command)) == BMWLINK_OBD2_RESULT_OK);
    CHECK(strcmp(command, "0902") == 0);
    CHECK(bmwlink_obd2_build_dtc_request(BMWLINK_OBD2_DTC_STORED, command, sizeof(command)) == BMWLINK_OBD2_RESULT_OK);
    CHECK(strcmp(command, "03") == 0);
    CHECK(bmwlink_obd2_decode_pid_payload(0x01U, 0x0cU, rpm_payload, sizeof(rpm_payload), &decoded) == BMWLINK_OBD2_RESULT_OK);
    CHECK(decoded.signal_count >= 1U);
    CHECK(decoded.signals[0].value > 1725.999 && decoded.signals[0].value < 1726.001);
    CHECK(bmwlink_obd2_decode_dtc_pair(0x01U, 0x33U, dtc) == BMWLINK_OBD2_RESULT_OK);
    CHECK(strcmp(dtc, "P0133") == 0);
    CHECK(bmwlink_obd2_obdonuds_pid_to_did(0x000cU, &did) == BMWLINK_OBD2_RESULT_OK);
    CHECK(did == 0xf40cU);
    puts("BMWLINK inherited standard OBD-II baseline passed");
    return 0;
}
