import 'package:meta/meta.dart';

import 'ibeacon_id.dart';

/// Class for managing for ranging and monitoring region scanning.
@immutable
class Region {
  /// Class for managing for ranging and monitoring region scanning.
  final String identifier;

  /// ID of Beacon (UUID, Major, Minor)
  final IBeaconId beaconId;

  const Region({
    required this.identifier,
    required this.beaconId,
  });

  @override
  bool operator ==(Object other) => identical(this, other) || other is Region && runtimeType == other.runtimeType && identifier == other.identifier;

  @override
  int get hashCode => identifier.hashCode;

  @override
  String toString() {
    return 'Region{identifier: $identifier, beaconId: $beaconId}';
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'identifier': this.identifier,
      ...this.beaconId.toJson(),
    };
  }

  factory Region.fromJson(Map<String, dynamic> json) {
    return Region(
      identifier: json['identifier'] as String,
      beaconId: IBeaconId.fromJson(json),
    );
  }
}
