import 'package:meta/meta.dart';

@immutable
class BeaconId {
  static const String NOT_DEFINED_UUID = '';
  static const int NOT_DEFINED_MAJOR_ID = -1;
  static const int NOT_DEFINED_MINOR_ID = -1;

  /// Empty = not defined
  final String proximityUUID;

  /// -1 = not defined
  final int majorId;

  /// -1 = not defined
  final int minorId;

  const BeaconId({
    this.proximityUUID = NOT_DEFINED_UUID,
    this.majorId = NOT_DEFINED_MAJOR_ID,
    this.minorId = NOT_DEFINED_MINOR_ID,
  });

  bool get isDefined => proximityUUID != NOT_DEFINED_UUID && majorId == NOT_DEFINED_MAJOR_ID && minorId == NOT_DEFINED_MINOR_ID;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BeaconId && runtimeType == other.runtimeType && proximityUUID == other.proximityUUID && majorId == other.majorId && minorId == other.minorId;

  @override
  int get hashCode => proximityUUID.hashCode ^ majorId.hashCode ^ minorId.hashCode;

  @override
  String toString() {
    return 'BeaconId{proximityUUID: $proximityUUID, majorId: $majorId, minorId: $minorId}';
  }
}

@immutable
class Region {
  final String identifier;
  final BeaconId? beaconId;

  const Region({
    required this.identifier,
    this.beaconId,
  });

  @override
  bool operator ==(Object other) => identical(this, other) || other is Region && runtimeType == other.runtimeType && identifier == other.identifier;

  @override
  int get hashCode => identifier.hashCode;

  @override
  String toString() {
    return 'Region{identifier: $identifier, beaconId: $beaconId}';
  }
}

@immutable
class Beacon {
  /// Id of Beacon
  final BeaconId id;

  /// The mac address of beacon
  final String? macAddress;

  /// The proximity of beacon
  final Proximity? proximity;

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
    this.proximity,
    this.txPower,
  });

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

@immutable
class ScanResult {
  final Region region;
  final List<Beacon> beacons;

  const ScanResult(this.region, this.beacons);
}
