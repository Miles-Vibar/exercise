import 'barangay.dart';

class City {
  final String name;
  final List<Barangay>? barangays;

  const City({
    required this.name,
    required this.barangays,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
        name: json['name'],
        barangays: json['barangay'] != null
            ? List<Barangay>.from(
                json['barangay'].map((x) => Barangay.fromJson(x)))
            : null,
    );
  }
}
