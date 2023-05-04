import 'dart:convert';

class PlantInfo {
  final int id;
  final List<String> common;
  final List<String> use;
  final String latin;
  final String family;
  final String category;
  final String origin;
  final String climate;
  final String toleratedlight;
  final String idealight;
  final String watering;
  final int waterDuration;
  final int minCelsius;
  final int maxCelsius;
  final int minFahrenheit;
  final int maxFahrenheit;
  final String plantPhoto;

  PlantInfo({
    required this.id,
    required this.common,
    required this.use,
    required this.latin,
    required this.family,
    required this.category,
    required this.origin,
    required this.climate,
    required this.toleratedlight,
    required this.idealight,
    required this.watering,
    required this.waterDuration,
    required this.minCelsius,
    required this.maxCelsius,
    required this.minFahrenheit,
    required this.maxFahrenheit,
    required this.plantPhoto,
  });

  factory PlantInfo.fromJson(Map<String, dynamic> json) {
    return PlantInfo(
      id: json['id'],
      common: List<String>.from(json['common']),
      use: List<String>.from(json['use']),
      latin: json['latin'],
      family: json['family'],
      category: json['category'],
      origin: json['origin'],
      climate: json['climate'],
      toleratedlight: json['toleratedlight'],
      idealight: json['idealight'],
      watering: json['watering'],
      waterDuration: json['water_duration'],
      minCelsius: json['mincelsius'],
      maxCelsius: json['maxcelsius'],
      minFahrenheit: json['minfahrenheit'],
      maxFahrenheit: json['maxfahrenheit'],
      plantPhoto: json['plant_photo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'common': common,
      'use': use,
      'latin': latin,
      'family': family,
      'category': category,
      'origin': origin,
      'climate': climate,
      'toleratedlight': toleratedlight,
      'idealight': idealight,
      'watering': watering,
      'water_duration': waterDuration,
      'mincelsius': minCelsius,
      'maxcelsius': maxCelsius,
      'minfahrenheit': minFahrenheit,
      'maxfahrenheit': maxFahrenheit,
      'plant_photo': plantPhoto,
    };
  }

  String toJsonString() {
    return json.encode(toJson());
  }

  factory PlantInfo.fromJsonString(String jsonString) {
    return PlantInfo.fromJson(json.decode(jsonString));
  }
}
