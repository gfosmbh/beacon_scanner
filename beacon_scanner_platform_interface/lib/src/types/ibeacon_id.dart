import 'package:meta/meta.dart';

@immutable
class IBeaconId {
  static const String NOT_DEFINED_UUID = '';
  static const int NOT_DEFINED_MAJOR_ID = -1;
  static const int NOT_DEFINED_MINOR_ID = -1;

  /// Empty = not defined
  final String proximityUUID;

  /// -1 = not defined
  final int majorId;

  /// -1 = not defined
  final int minorId;

  const IBeaconId({
    this.proximityUUID = NOT_DEFINED_UUID,
    this.majorId = NOT_DEFINED_MAJOR_ID,
    this.minorId = NOT_DEFINED_MINOR_ID,
  });

  bool get isDefined => proximityUUID != NOT_DEFINED_UUID && majorId == NOT_DEFINED_MAJOR_ID && minorId == NOT_DEFINED_MINOR_ID;

  factory IBeaconId.fromJson(Map<String, dynamic> map) {
    return IBeaconId(
      proximityUUID: (map['proximityUUID'] as String?) ?? NOT_DEFINED_UUID,
      majorId: (map['major'] as int?) ?? NOT_DEFINED_MAJOR_ID,
      minorId: (map['minor'] as int?) ?? NOT_DEFINED_MINOR_ID,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'proximityUUID': this.proximityUUID,
      'major': this.majorId,
      'minor': this.minorId,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is IBeaconId && runtimeType == other.runtimeType && proximityUUID == other.proximityUUID && majorId == other.majorId && minorId == other.minorId;

  @override
  int get hashCode => proximityUUID.hashCode ^ majorId.hashCode ^ minorId.hashCode;

  @override
  String toString() {
    return 'BeaconId{proximityUUID: $proximityUUID, majorId: $majorId, minorId: $minorId}';
  }
}
