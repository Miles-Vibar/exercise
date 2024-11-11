class Barangay {
  final String name;

  const Barangay({required this.name,});

  factory Barangay.fromJson(String json) {
    return Barangay(name: json);
  }
}