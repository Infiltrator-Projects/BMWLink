// SPDX-License-Identifier: GPL-3.0-or-later
#ifndef BMWLINK_DIAGNOSTICS_H
#define BMWLINK_DIAGNOSTICS_H

#include "bmwlink/obd2.h"
#include "link/diagnostic_flow.h"
#include "link/diagnostic_request.h"
#include "link/discover.h"
#include "link/doip.h"
#include "link/ecu_probe.h"
#include "link/elm327.h"
#include "link/elm327_can.h"
#include "link/elm327_probe.h"
#include "link/elm327_session.h"
#include "link/isotp.h"
#include "link/kwp2000.h"
#include "link/parameter.h"
#include "link/parameter_store.h"
#include "link/scheduler.h"
#include "link/telemetry.h"
#include "link/transport.h"
#include "link/uds.h"
#include "link/uds_dtc.h"
#include "link/uds_services.h"

typedef LinkTransport BmwlinkTransport;
typedef LinkTransportStatus BmwlinkTransportStatus;
typedef LinkAdapterKind BmwlinkAdapterKind;
typedef LinkAdapterCapabilities BmwlinkAdapterCapabilities;
typedef LinkElm327Response BmwlinkElm327Response;
typedef LinkElm327Session BmwlinkElm327Session;
typedef LinkIsoTpCanFrame BmwlinkIsoTpCanFrame;
typedef LinkUdsResponse BmwlinkUdsResponse;
typedef LinkDoipHeader BmwlinkDoipHeader;
typedef LinkParameterStore BmwlinkParameterStore;
typedef LinkScheduler BmwlinkScheduler;
typedef LinkTelemetryStore BmwlinkTelemetryStore;
typedef LinkDiagnosticFlow BmwlinkDiagnosticFlow;
typedef LinkDiagnosticRequestDefinition BmwlinkDiagnosticRequestDefinition;
typedef LinkEcuProbe BmwlinkEcuProbe;

#define bmwlink_adapter_kind_from_bluetooth_name link_adapter_kind_from_bluetooth_name
#define bmwlink_adapter_kind_name link_adapter_kind_name
#define bmwlink_adapter_capabilities link_adapter_capabilities
#define bmwlink_adapter_has_capability link_adapter_has_capability
#define bmwlink_transport_is_valid link_transport_is_valid
#define bmwlink_elm327_protocol_definition_count link_elm327_protocol_definition_count
#define bmwlink_elm327_protocol_definition_at link_elm327_protocol_definition_at
#define bmwlink_elm327_protocol_definition link_elm327_protocol_definition
#define bmwlink_isotp_can_data_length_is_valid link_isotp_can_data_length_is_valid
#define bmwlink_uds_standard_service_count link_uds_standard_service_count
#define bmwlink_uds_standard_service_find link_uds_standard_service_find
#define bmwlink_doip_build_diagnostic_message link_doip_build_diagnostic_message
#define bmwlink_doip_decode_diagnostic_message link_doip_decode_diagnostic_message
#define bmwlink_safety_classify link_safety_classify
#define bmwlink_parameter_obd2_definition_count link_parameter_obd2_definition_count
#define bmwlink_parameter_store_init link_parameter_store_init
#define bmwlink_parameter_store_definition_count link_parameter_store_definition_count
#define bmwlink_scheduler_init link_scheduler_init
#define bmwlink_scheduler_next link_scheduler_next
#define bmwlink_telemetry_store_init link_telemetry_store_init
#define bmwlink_telemetry_store_history_count link_telemetry_store_history_count
#define bmwlink_diagnostic_execution_mode_for_adapter link_diagnostic_execution_mode_for_adapter
#define bmwlink_diagnostic_request_supported_by_adapter link_diagnostic_request_supported_by_adapter
#define bmwlink_ecu_probe_profile_is_valid link_ecu_probe_profile_is_valid

#endif
