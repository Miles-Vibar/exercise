import 'province.dart';

class Region {
  final int? id;
  final String name;
  final List<Province>? provinces;

  const Region({
    required this.id,
    required this.name,
    required this.provinces,
  });

  factory Region.fromJson(Map<String, dynamic> json) {
    return Region(
      id: int.tryParse(json['id'].toString() ?? ''),
      name: json['name'],
      provinces: json['province'] != null
          ? List<Province>.from(
              json['province'].map((x) => Province.fromJson(x)))
          : null,
    );
  }

  Map<String, Object?> toJson() => {
        'id': id,
        'name': name,
      };

  Region copy({
    int? id,
    String? name,
    List<Province>? provinces,
  }) =>
      Region(
        id: id,
        name: name ?? this.name,
        provinces: provinces,
      );
}

class RegionsList {
  List<Region>? regions;

  RegionsList({this.regions});

  factory RegionsList.fromJson(List<dynamic> json) {
    return RegionsList(
        regions: List<Region>.from(json.map((x) => Region.fromJson(x))));
  }
}
