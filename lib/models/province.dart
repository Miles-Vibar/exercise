import 'city.dart';

class Province {
  final int? id;
  final String name;
  final List<City>? cities;

  const Province({
    required this.id,
    required this.name,
    required this.cities,
  });

  factory Province.fromJson(Map<String, dynamic> json) {
    return Province(
      id: int.tryParse(json['id'] ?? ''),
      name: json['name'],
      cities: json['city'] != null
          ? List<City>.from(json['city'].map((x) => City.fromJson(x)))
          : null,
    );
  }

  Map<String, Object?> toJson(int foreignKey) => {
        'id': id,
        'name': name,
        'region_id': foreignKey,
      };

  Province copy({
    int? id,
    String? name,
    List<City>? cities,
  }) =>
      Province(
        id: id,
        name: name ?? this.name,
        cities: cities,
      );
}
