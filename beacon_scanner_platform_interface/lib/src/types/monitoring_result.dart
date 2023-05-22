import 'package:flutter/foundation.dart';

import '../../beacon_scanner_platform_interface.dart';

/// Enum for defining monitoring event type.
enum MonitoringEventType { didEnterRegion, didExitRegion, didDetermineStateForRegion }

/// Enum for defining monitoring state
enum MonitoringState { inside, outside, unknown }


/// Class for managing monitoring result from scanning iBeacon process.
@immutable
class MonitoringResult {
  /// The [MonitoringEventType] of monitoring result
  final MonitoringEventType monitoringEventType;

  /// The [MonitoringState] of monitoring result
  final MonitoringState monitoringState;

  /// The [Region] of ranging result.
  final Region region;

  const MonitoringResult({
    required this.monitoringEventType,
    required this.region,
    this.monitoringState = MonitoringState.unknown,
  });

  /// Constructor for deserialize dynamic json into [MonitoringResult].
  factory MonitoringResult.fromJson(dynamic json) => MonitoringResult(
        monitoringEventType: MonitoringEventType.values.firstWhere((e) => describeEnum(e) == json['event']),
        monitoringState: MonitoringState.values.firstWhere((e) => describeEnum(e) == json['state'], orElse: () => MonitoringState.unknown),
        region: Region.fromJson(json['region']),
      );

  /// Return the serializable of this object into [Map].
  Map<String, dynamic> toJson() => <String, dynamic>{
    'event': describeEnum(monitoringEventType),
    'region': region.toJson(),
    'state': describeEnum(monitoringState),
  };
}
