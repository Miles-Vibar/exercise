import 'package:address_app/Models/Barangay.dart';
import 'package:address_app/Models/Province.dart';
import 'package:address_app/Models/Region.dart';
import 'package:address_app/Models/StateModel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../Models/City.dart';

class LocationCubit extends Cubit<StateModel> {
  LocationCubit(super.initialState);


  RegionsList? regionsList;
  List<Province>? provincesList;
  List<City>? citiesList;
  List<Barangay>? barangaysList;

  Future<void> getRegions() async {
    if (regionsList == null) {
      await SharedPreferences.getInstance().then((prefs) async {
        print('opened shared preferences');
        final jsonString = prefs.getString('jsonString');

        if (jsonString == null) {
          print('setting jsonString');
          await http.get(Uri.parse('https://raw.githubusercontent.com/tarkiedev1/exercise/refs/heads/main/address_ph.json')).then((r) async {
            regionsList =  RegionsList.fromJson(jsonDecode(r.body));
            filterProvinces(null);
            filterCities(null);
            filterBarangays(null);
            await prefs.setString('jsonString', r.body);
          });
        } else {
          print('getting jsonString');
          regionsList =  RegionsList.fromJson(jsonDecode(jsonString));
          filterProvinces(null);
          filterCities(null);
          filterBarangays(null);
        }

        regionsList = RegionsList(regions: <Region>[]);
        emit(state);
      });
    }
  }

  void filterProvinces(String? region) {
    provincesList = region != null ? regionsList?.regions?.firstWhere((r) => r.name == region).provinces : regionsList?.regions?.expand((r) => r.provinces ?? <Province>[]).toList();
    emit(StateModel(region: state.region, province: null, city: null));
  }

  void filterCities(String? province) {
    citiesList = province != null ? provincesList?.firstWhere((p) => p.name == province).cities : provincesList?.expand((p) => p.cities ?? <City>[]).toList();
    emit(StateModel(region: state.region, province: state.province, city: null));
  }

  void filterBarangays(String? city) {
    barangaysList = city != null ? citiesList?.firstWhere((c) => c.name == city).barangays : citiesList?.expand((c) => c.barangays ?? <Barangay>[]).toList();
    emit(StateModel(region: state.region, province: state.province, city: state.city));
  }
}