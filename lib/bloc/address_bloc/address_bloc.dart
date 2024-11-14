import 'package:address_app/models/barangay.dart';
import 'package:address_app/models/province.dart';
import 'package:address_app/models/region.dart';
import 'package:address_app/database/address_sqlite_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../models/city.dart';
import 'address_event.dart';
import 'address_state.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  AddressSqliteDatabase db = AddressSqliteDatabase.instance;

  AddressBloc()
      : super(const AddressState(
          isLoading: null,
          region: null,
          province: null,
          city: null,
          barangay: null,
          regionsList: null,
          provincesList: null,
          citiesList: null,
          barangaysList: null,
        )) {
    on<GetAllEvent>((event, emit) async {
      await db.getAll().then((value) async {
        print(event.toString());
        emit(state.update(isLoading: true));
        if (value.regions?.isEmpty ?? false) {
          print('empty');
          await http
              .get(Uri.parse(
                  'https://raw.githubusercontent.com/tarkiedev1/exercise/refs/heads/main/address_ph.json'))
              .then((r) async {
            emit(state.update(
              isLoading: true,
              regionsList: RegionsList.fromJson(jsonDecode(r.body)),
            ));
            filterProvinces(state.region);

            for (Region region in state.regionsList?.regions ?? <Region>[]) {
              final r = await db.addRegion(region.copy());

              for (Province province in state.regionsList?.regions!
                      .firstWhere((r) => r.name == region.name)
                      .provinces ??
                  <Province>[]) {
                final p = await db.addProvince(province, r.id!);

                for (City city in state.provincesList
                        ?.firstWhere((p) => p.name == province.name)
                        .cities ??
                    <City>[]) {
                  final c = await db.addCity(city, p.id!);

                  for (Barangay barangay in state.citiesList
                          ?.firstWhere((c) => c.name == city.name)
                          .barangays ??
                      <Barangay>[]) {
                    final b = await db.addBarangay(barangay, c.id!);
                    print(b.name);
                  }
                }
              }
            }
            emit(state.update());
          });
        }
        emit(state.update(regionsList:await db.getAll()));
        filterProvinces(state.region);
      });
    });
    on<GetProvincesEvent>((event, emit) => filterProvinces(event.region));
    on<GetCitiesEvent>((event, emit) => filterCities(event.province));
    on<GetBarangaysEvent>((event, emit) => filterBarangays(event.city));
    on<InsertMissingFieldsEvent>(
        (event, emit) => insertMissingFields(event.barangay));
  }

  void filterProvinces(String? region) {
    emit(state.update(
        region: region,
        provincesList: region != null
            ? state.regionsList?.regions
                ?.firstWhere((r) => r.name == region)
                .provinces
            : state.regionsList?.regions
                ?.expand((r) => r.provinces ?? <Province>[])
                .toList()));
    filterCities(null);
  }

  void filterCities(String? province) {
    emit(state.update(
      region: province == null ? null : getRegion(province),
      province: province,
      city: null,
      barangay: null,
      citiesList: province != null
          ? state.provincesList?.firstWhere((p) => p.name == province).cities
          : state.provincesList?.expand((c) => c.cities ?? <City>[]).toList(),
    ));
    filterBarangays(null);
  }

  String? getRegion(String? province) => state.regionsList?.regions
      ?.firstWhere((r) => r.provinces!.map((p) => p.name).contains(province))
      .name;

  String? getProvince(String? city) => state.provincesList
      ?.firstWhere((p) => p.cities!.map((c) => c.name).contains(city))
      .name;

  void filterBarangays(String? city) {
    final province = city == null ? null : getProvince(city);

    emit(state.update(
      region: city == null ? null : getRegion(province),
      province: province,
      city: city,
      barangay: null,
      barangaysList: city != null
          ? state.citiesList?.firstWhere((c) => c.name == city).barangays
          : state.citiesList
              ?.expand((c) => c.barangays ?? <Barangay>[])
              .toList(),
    ));
  }

  void insertMissingFields(String barangay) {
    final city = state.citiesList
        ?.firstWhere((c) => c.barangays!.map((b) => b.name).contains(barangay))
        .name;
    final province = getProvince(city);
    final region = getRegion(province);

    emit(state.update(
      region: region,
      province: province,
      city: city,
      barangay: barangay,
      barangaysList:
          state.citiesList?.firstWhere((c) => c.name == city).barangays,
    ));
  }

  @override
  Future<void> close() {
    // TODO: implement close
    return super.close();
  }
}
