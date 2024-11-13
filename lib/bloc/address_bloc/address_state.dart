import 'package:address_app/models/province.dart';
import 'package:address_app/models/region.dart';
import 'package:equatable/equatable.dart';

import '../../models/barangay.dart';
import '../../models/city.dart';

class AddressState extends Equatable {
  final bool? isLoading;
  final String? region;
  final String? province;
  final String? city;
  final String? barangay;
  final RegionsList? regionsList;
  final List<Province>? provincesList;
  final List<City>? citiesList;
  final List<Barangay>? barangaysList;

  const AddressState({
    required this.isLoading,
    required this.region,
    required this.province,
    required this.city,
    required this.barangay,
    required this.regionsList,
    required this.provincesList,
    required this.citiesList,
    required this.barangaysList
  });

  AddressState update({
    final bool isLoading = false,
    final String? region,
    final String? province,
    final String? city,
    final String? barangay,
    final RegionsList? regionsList,
    final List<Province>? provincesList,
    final List<City>? citiesList,
    final List<Barangay>? barangaysList,
  }) =>
      AddressState(
        isLoading: isLoading,
        region: region,
        province: province,
        city: city,
        barangay: barangay,
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
        barangay,
        regionsList,
        provincesList,
        citiesList,
        barangaysList,
      ];
}
