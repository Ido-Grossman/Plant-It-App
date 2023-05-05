class PlantDetails {
  final int idOfUser;
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
  final Map<String, dynamic> disease;
  final String lastWatering;
  final String nickname;
  final int user;

  PlantDetails({
    required this.idOfUser,
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
    required this.disease,
    required this.lastWatering,
    required this.nickname,
    required this.user,
  });

  factory PlantDetails.fromJson(Map<String, dynamic> json) {
    return PlantDetails(
      idOfUser: json['id'],
      id: json['plant']['id'],
      common: List<String>.from(json['plant']['common']),
      use: List<String>.from(json['plant']['use']),
      latin: json['plant']['latin'],
      family: json['plant']['family'],
      category: json['plant']['category'],
      origin: json['plant']['origin'],
      climate: json['plant']['climate'],
      toleratedLight: json['plant']['toleratedlight'],
      idealLight: json['plant']['idealight'],
      watering: json['plant']['watering'],
      waterDuration: json['plant']['water_duration'],
      minCelsius: json['plant']['mincelsius'],
      maxCelsius: json['plant']['maxcelsius'],
      minFahrenheit: json['plant']['minfahrenheit'],
      maxFahrenheit: json['plant']['maxfahrenheit'],
      plantPhoto: json['plant']['plant_photo'],
      disease: json['disease'],
      lastWatering: json['last_watering'],
      nickname: json['nickname'],
      user: json['user'],
    );
  }
}
