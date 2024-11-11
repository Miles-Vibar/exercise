import 'dart:io';

import 'package:address_app/Models/barangay.dart';
import 'package:address_app/Models/province.dart';
import 'package:address_app/Models/region.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../Models/city.dart';
import 'address_event.dart';
import 'address_state.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  AddressBloc() : super(
    const AddressState(
      region: null,
      province: null,
      city: null,
      regionsList: null,
      provincesList: null,
      citiesList: null,
      barangaysList: null,
    )
  ) {
    on<GetAllEvent>((event, emit) async {
      if (state.regionsList == null) {
        await getApplicationDocumentsDirectory().then((value) {
          final file = File('${value.path}/address.json');

          file.exists().then((value) {
            if (value) {
              getAll(file);
            } else {
              file.create(recursive: true).then((file) {
                getAll(file);
              });
            }
          });
        });
      }
    });
    on<GetProvincesEvent>((event, emit) => filterProvinces(event.region));
    on<GetCitiesEvent>((event, emit) => filterCities(event.province));
    on<GetBarangaysEvent>((event, emit) => filterBarangays(event.city));
  }

  void getAll(File file) {
    file.readAsString().then((jsonString) async {
      if (jsonString.isEmpty) {
        await http
            .get(Uri.parse(
            'https://raw.githubusercontent.com/tarkiedev1/exercise/refs/heads/main/address_ph.json'))
            .then((r) async {
          await file.writeAsString(r.body);
          emit(state.update(
            regionsList: RegionsList.fromJson(jsonDecode(r.body)),
          ));
          filterProvinces(state.region);
        });
      } else {
        emit(state.update(
          regionsList: RegionsList.fromJson(jsonDecode(jsonString)),
        ));
        filterProvinces(state.region);
      }
    });
  }

  void filterProvinces(String? region) {
    emit(state.update(
        region: region,
        province: null,
        city: null,
        provincesList: region != null
            ? state.regionsList?.regions
                ?.firstWhere((r) => r.name == region)
                .provinces
            : state.regionsList?.regions
                ?.expand((r) => r.provinces ?? <Province>[])
                .toList()));
    filterCities(state.province);
  }

  void filterCities(String? province) {
    emit(state.update(
        province: province,
        city: null,
        citiesList: province != null
            ? state.provincesList?.firstWhere((p) => p.name == province).cities
            : state.provincesList
                ?.expand((p) => p.cities ?? <City>[])
                .toList()));
    filterBarangays(state.city);
  }

  void filterBarangays(String? city) {
    emit(state.update(
        city: city,
        barangaysList: city != null
            ? state.citiesList?.firstWhere((c) => c.name == city).barangays
            : state.citiesList
                ?.expand((c) => c.barangays ?? <Barangay>[])
                .toList()));
    print('region: ${state.region}; p: ${state.province}; c: ${state.city}');
  }
}

class LocationCubit extends Cubit<AddressState> {
  LocationCubit(super.initialState);

  RegionsList? regionsList;
  List<Province>? provincesList;
  List<City>? citiesList;
  List<Barangay>? barangaysList;

  Future<void> getRegions() async {
    if (regionsList == null) {
      await SharedPreferences.getInstance().then((prefs) async {
        final jsonString = prefs.getString('jsonString');

        if (jsonString == null) {
          await http
              .get(Uri.parse(
              'https://raw.githubusercontent.com/tarkiedev1/exercise/refs/heads/main/address_ph.json'))
              .then((r) async {
            regionsList = RegionsList.fromJson(jsonDecode(r.body));
            await prefs.setString('jsonString', r.body);
          });
        } else {
          regionsList = RegionsList.fromJson(jsonDecode(jsonString));
        }

        emit(state);
      });
    }
  }
}