import 'package:meta/meta.dart';

import 'beacon.dart';
import 'region.dart';

@immutable
class ScanResult {
  final Region region;
  final List<Beacon> beacons;

  const ScanResult({
    required this.region,
    required this.beacons,
  });

  Map<String, dynamic> toJson() {
    return {
      'region': this.region,
      'beacons': this.beacons.map((e) => e.toJson()).toList(),
    };
  }

  factory ScanResult.fromJson(dynamic json) {
    return ScanResult(
      region: Region.fromJson(json['region']),
      beacons: (json['beacons'] as List<dynamic>).map((e) => Beacon.fromJson(e)).toList(),
    );
  }
}
