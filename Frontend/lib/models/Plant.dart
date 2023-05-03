class Plant {
  final int id;
  final String latin;
  final List<String> common;
  final String plantPhoto;
  final String category;
  final String health;

  Plant({
    required this.id,
    required this.latin,
    required this.common,
    required this.plantPhoto,
    required this.category,
    required this.health,
  });

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
      id: json['id'],
      latin: json['latin'],
      common: List<String>.from(json['common']),
      plantPhoto: json['plant_photo'],
      category: json['category'],
      health: json['health'],
    );
  }
}
