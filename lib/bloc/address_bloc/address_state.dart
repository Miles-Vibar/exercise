import 'package:address_app/Models/province.dart';
import 'package:address_app/Models/region.dart';
import 'package:equatable/equatable.dart';

import '../../Models/barangay.dart';
import '../../Models/city.dart';

class AddressState extends Equatable {
  final String? region;
  final String? province;
  final String? city;
  final RegionsList? regionsList;
  final List<Province>? provincesList;
  final List<City>? citiesList;
  final List<Barangay>? barangaysList;

  const AddressState({
    required this.region,
    required this.province,
    required this.city,
    required this.regionsList,
    required this.provincesList,
    required this.citiesList,
    required this.barangaysList
  });

  AddressState update({
    final String? region,
    final String? province,
    final String? city,
    final RegionsList? regionsList,
    final List<Province>? provincesList,
    final List<City>? citiesList,
    final List<Barangay>? barangaysList,
  }) =>
      AddressState(
        region: region ?? this.region,
        province: province ?? this.province,
        city: city ?? this.city,
        regionsList: regionsList ?? this.regionsList,
        provincesList: provincesList ?? this.provincesList,
        citiesList: citiesList ?? this.citiesList,
        barangaysList: barangaysList ?? this.barangaysList,
      );

  @override
  // TODO: implement props
  List<Object?> get props => [
        region,
        province,
        city,
        regionsList,
        provincesList,
        citiesList,
        barangaysList,
      ];
}
