import 'Province.dart';

class Region {
  final String id;
  final String name;
  final List<Province>? provinces;

  Region({required this.id, required this.name, required this.provinces});

  factory Region.fromJson(Map<String, dynamic> json) {
    return Region(id: json['id'], name: json['name'], provinces: json['province'] != null ? List<Province>.from(json['province'].map((x) => Province.fromJson(x))) : null);
  }
}

class RegionsList {
  List<Region>? regions;

  RegionsList({this.regions});

  factory RegionsList.fromJson(List<dynamic> json) {

    return RegionsList(regions: List<Region>.from(json.map((x) => Region.fromJson(x))));
  }
}