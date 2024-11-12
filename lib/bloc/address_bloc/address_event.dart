abstract class AddressEvent { }

class GetAllEvent extends AddressEvent { }

class GetProvincesEvent extends AddressEvent {
  final String? region;

  GetProvincesEvent({required this.region});
}

class GetCitiesEvent extends AddressEvent {
  final String? province;

  GetCitiesEvent({required this.province});
}

class GetBarangaysEvent extends AddressEvent {
  final String? city;

  GetBarangaysEvent({required this.city});
}

class InsertMissingFieldsEvent extends AddressEvent {
  final String barangay;

  InsertMissingFieldsEvent({required this.barangay});
}