class Barangay {
  final int? id;
  final String name;

  const Barangay({
    required this.id,
    required this.name,
  });

  factory Barangay.fromJson(Map<String, dynamic> json) {
    return Barangay(id: json['id'], name: json['name']);
  }

  factory Barangay.fromJsonList(String json) {
    return Barangay(id: null, name: json);
  }

  Map<String, Object?> toJson(int foreignKey) => {
        'id': id,
        'name': name,
        'city_id': foreignKey,
      };

  Barangay copy({
    int? id,
    String? name,
  }) =>
      Barangay(
        id: id,
        name: name ?? this.name,
      );
}
