import 'barangay.dart';

class City {
  final int? id;
  final String name;
  final List<Barangay>? barangays;

  const City({
    required this.id,
    required this.name,
    required this.barangays,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'],
      name: json['name'],
      barangays: json['barangay'] != null
          ? List<Barangay>.from(
              json['barangay'].map((x) => x is String ? Barangay.fromJsonList(x) : Barangay.fromJson(x)))
          : null,
    );
  }

  Map<String, Object?> toJson(int foreignKey) => {
    'id': id,
    'name': name,
    'province_id': foreignKey,
  };

  City copy({
    int? id,
    String? name,
    List<Barangay>? barangays,
  }) =>
      City(
        id: id,
        name: name ?? this.name,
        barangays: barangays,
      );
}
