import 'City.dart';

class Province {
  final String name;
  final List<City>? cities;

  Province({required this.name, required this.cities});

  factory Province.fromJson(Map<String, dynamic> json) {
    return Province(name: json['name'], cities: json['city'] != null ? List<City>.from(json['city'].map((x) => City.fromJson(x))) : null);
  }
}