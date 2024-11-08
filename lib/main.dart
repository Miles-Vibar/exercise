import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AddressPage(),
    );
  }
}

class AddressPage extends StatefulWidget {
  const AddressPage({super.key});

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  RegionsList regionsList = RegionsList(regions: <Region>[]);
  List<Province>? provincesList;

  Future<void> getProvinces() async {
    var response = await http.get(Uri.parse('https://raw.githubusercontent.com/tarkiedev1/exercise/refs/heads/main/address_ph.json'));

    setState(() {
      if (regionsList.regions!.isEmpty) {
        regionsList = RegionsList.fromJson(jsonDecode(response.body));
      }
      provincesList = regionsList.regions?.expand((r) => r.provinces ?? <Province>[]).toList();
    });
  }

  void filterProvinces(String region) {
    setState(() {
      print(provincesList?.length);
      provincesList = null;
      provincesList = regionsList.regions?.firstWhere((r) => r.name == region).provinces;
      print(provincesList?.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Address'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            DropDownWidget(location: regionsList.regions , function: getProvinces(), onChanged: (String value) => filterProvinces(value),),
            const SizedBox(height: 4.0,),
            DropDownWidget(location: provincesList, function: getProvinces(), onChanged: (String value) {
            },),
            const SizedBox(height: 4.0,),
          ],
        ),
      ),
    );
  }
}

class DropDownWidget extends StatefulWidget {
  const DropDownWidget({super.key, required this.location, required this.function, required this.onChanged});

  final List<dynamic>? location;
  final void function;
  final ValueChanged<String> onChanged;

  @override
  State<DropDownWidget> createState() => _DropDownWidgetState();
}

class _DropDownWidgetState extends State<DropDownWidget> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      items: widget.location?.map((location) {
        return DropdownMenuItem(
          value: location.name,
          child: Text(location.name),
        );
      }).toList() ?? [' '].map((region) {
        return DropdownMenuItem(
          value: region,
          child: Text(region),
        );
      }).toList(),
      isExpanded: true,
      onChanged: (value) => widget.onChanged(value as String ?? ''),
      onTap: () { if (widget.location == null) widget.function; },
      decoration: const InputDecoration(
        label: Text('Region'),
      ),
    );
  }
}

class RegionsList {
  List<Region>? regions;

  RegionsList({this.regions});

  factory RegionsList.fromJson(List<dynamic> json) {

    return RegionsList(regions: List<Region>.from(json.map((x) => Region.fromJson(x))));
  }
}

class Region {
  final String id;
  final String name;
  final List<Province>? provinces;

  Region({required this.id, required this.name, required this.provinces});

  factory Region.fromJson(Map<String, dynamic> json) {
    return Region(id: json['id'], name: json['name'], provinces: json['province'] != null ? List<Province>.from(json['province'].map((x) => Province.fromJson(x))) : null);
  }
}

class Province {
  final String name;
  final List<City>? cities;

  Province({required this.name, required this.cities});

  factory Province.fromJson(Map<String, dynamic> json) {
    return Province(name: json['name'], cities: json['city'] != null ? List<City>.from(json['city'].map((x) => City.fromJson(x))) : null);
  }
}

class City {
  final String name;
  final List<String> barangays;

  City({required this.name, required this.barangays});

  factory City.fromJson(Map<String, dynamic> json) {
    return City(name: json['name'], barangays: List.from(json['barangay']));
  }
}