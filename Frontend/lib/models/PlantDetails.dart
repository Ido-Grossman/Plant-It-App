class PlantDetails {
  final int id;
  final List<String> common;
  final List<String> use;
  final String latin;
  final String family;
  final String category;
  final String origin;
  final String climate;
  final String toleratedLight;
  final String idealLight;
  final String watering;
  final int waterDuration;
  final int minCelsius;
  final int maxCelsius;
  final int minFahrenheit;
  final int maxFahrenheit;
  final String plantPhoto;

  PlantDetails({
    required this.id,
    required this.common,
    required this.use,
    required this.latin,
    required this.family,
    required this.category,
    required this.origin,
    required this.climate,
    required this.toleratedLight,
    required this.idealLight,
    required this.watering,
    required this.waterDuration,
    required this.minCelsius,
    required this.maxCelsius,
    required this.minFahrenheit,
    required this.maxFahrenheit,
    required this.plantPhoto,
  });

  factory PlantDetails.fromJson(Map<String, dynamic> json) {
    return PlantDetails(
      id: json['id'],
      common: List<String>.from(json['common']),
      use: List<String>.from(json['use']),
      latin: json['latin'],
      family: json['family'],
      category: json['category'],
      origin: json['origin'],
      climate: json['climate'],
      toleratedLight: json['toleratedlight'],
      idealLight: json['idealight'],
      watering: json['watering'],
      waterDuration: json['water_duration'],
      minCelsius: json['mincelsius'],
      maxCelsius: json['maxcelsius'],
      minFahrenheit: json['minfahrenheit'],
      maxFahrenheit: json['maxfahrenheit'],
      plantPhoto: json['plant_photo'],
    );
  }
}
