import 'package:equatable/equatable.dart';
import 'package:surf_study_jam/surf_study_jam.dart';

/// Data transfer object representing geolocation point.
class ChatGeolocationDto extends Equatable {
  /// Latitude, in degrees.
  final double latitude;

  /// Longitude, in degrees.
  final double longitude;

  /// Constructor for [ChatGeolocationDto].
  const ChatGeolocationDto({
    required this.latitude,
    required this.longitude,
  });

  /// Named constructor for converting DTO from [StudyJamClient].
  ChatGeolocationDto.fromGeoPoint(List<double> geopoint)
      : latitude = geopoint[0],
        longitude = geopoint[1];
  @override
  String toString() =>
      'ChatGeolocationDto(latitude: $latitude, longitude: $longitude)';

  /// Transforms dto to `List`.
  List<double> toGeopoint() => [latitude, longitude];

  @override
  List<Object?> get props => [latitude, longitude];
}
