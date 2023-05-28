import 'package:flutter/foundation.dart';

import 'ibeacon_id.dart';

@immutable
class Beacon {
  /// Id of Beacon
  final IBeaconId id;

  /// The mac address of beacon
  final String? macAddress;

  /// The proximity of beacon
  final Proximity proximity;

  /// The rssi of beacon
  final int rssi;

  /// The transmission power of beacon
  final int? txPower;

  /// The accuracy of distance of beacon in meter.
  final double accuracy;

  const Beacon({
    required this.id,
    required this.rssi,
    required this.accuracy,
    this.macAddress,
    this.proximity = Proximity.unknown,
    this.txPower,
  });

  factory Beacon.fromJson(dynamic json) => Beacon(
    id: IBeaconId.fromJson(json),
    macAddress: json['macAddress'] as String?,
    rssi: json['rssi'] as int,
    txPower: json['txPower'] as int?,
    accuracy: json['accuracy'] as double,
    proximity: Proximity.values.firstWhere((e) => describeEnum(e) == json['proximity'], orElse: () => Proximity.unknown),
  );

  /// Serialize current instance object into [Map].
  Map<String, dynamic> toJson() => <String, dynamic>{
        'proximityUUID': id.proximityUUID,
        'major': id.majorId,
        'minor': id.minorId,
        'rssi': rssi,
        'accuracy': accuracy,
        'proximity': describeEnum(proximity),
        'txPower': txPower,
        'macAddress': macAddress,
      };

  @override
  bool operator ==(Object other) => identical(this, other) || other is Beacon && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Beacon{id: $id, macAddress: $macAddress, proximity: $proximity, rssi: $rssi, txPower: $txPower, accuracy: $accuracy}';
  }
}

/// Enum for iBeacon-proximity
enum Proximity { unknown, immediate, near, far }
