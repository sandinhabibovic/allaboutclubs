import 'package:allaboutclubs/logic/models/location.dart';
import 'package:allaboutclubs/logic/models/stadium.dart';

class Club {
  final String id;
  final String name;
  final String country;
  final int value;
  final String image;
  final int europeanTitles;
  final Stadium stadium;
  final Location location;

  Club({
    required this.id,
    required this.name,
    required this.country,
    required this.value,
    required this.image,
    required this.europeanTitles,
    required this.stadium,
    required this.location,
  });

  factory Club.fromJson(Map<String, dynamic> json) {
    return Club(
      id: json['id'],
      name: json['name'],
      country: json['country'],
      value: json['value'],
      image: json['image'],
      europeanTitles: json['european_titles'],
      stadium: Stadium.fromJson(json['stadium']),
      location: Location.fromJson(json['location']),
    );
  }
}
