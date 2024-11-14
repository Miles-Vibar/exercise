import 'package:address_app/models/barangay.dart';
import 'package:address_app/models/city.dart';
import 'package:sqflite/sqflite.dart';

import '../models/province.dart';
import '../models/region.dart';

class AddressSqliteDatabase {
  static final AddressSqliteDatabase instance = AddressSqliteDatabase
      ._internal();

  static Database? _database;

  AddressSqliteDatabase._internal();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _init();
    return _database!;
  }

  Future<Database> _init() async {
    final dbPath = await getDatabasesPath();
    final path = '$dbPath/address.db';

    return await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute(
            'CREATE TABLE regions (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL)'
        );
        await db.execute(
            'CREATE TABLE provinces (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, region_id INTEGER, FOREIGN KEY (region_id) REFERENCES regions (id))'
        );
        await db.execute(
            'CREATE TABLE cities (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, province_id INTEGER, FOREIGN KEY (province_id) REFERENCES provinces (id))'
        );
        await db.execute(
            'CREATE TABLE barangays (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, city_id INTEGER, FOREIGN KEY (city_id) REFERENCES cities (id))'
        );
      },
    );
  }

  Future<Region> addRegion(Region region) async {
    final db = await instance.database;

    final id = await db.transaction((t) async =>
    await t.insert('regions', region.toJson()));
    return region.copy(id: id);
  }

  Future<Province> addProvince(Province province, int foreignKey) async {
    final db = await instance.database;
    final id = await db.insert('provinces', province.toJson(foreignKey));

    return province.copy(id: id);
  }

  Future<City> addCity(City city, int foreignKey) async {
    final db = await instance.database;
    final id = await db.transaction((t) async =>
    await t.insert('cities', city.toJson(foreignKey)));

    return city.copy(id: id);
  }

  Future<Barangay> addBarangay(Barangay barangay, int foreignKey) async {
    final db = await instance.database;
    final id = await db.transaction((t) async =>
    await t.insert('barangays', barangay.toJson(foreignKey)));

    return barangay.copy(id: id);
  }

  Future<RegionsList> getAll() async {
    final db = await instance.database;
    // TODO: turn to list of Maps;
    final barangaysJson = await db.query('barangays');
    final citiesJson = await db.query('cities');
    final provincesJson = await db.query('provinces');
    final json = (await db.query('regions')).map((r) => {
      'id': r['id'],
      'name': r['name'],
      'province': provincesJson.where((p) => p['region_id'] == r['id']).map((p) => {
        'id': p['id'],
        'name': p['name'],
        'city': citiesJson.where((c) => c['province_id'] == p['id']).map((c) => {
          'id': c['id'],
          'name': c['name'],
          'barangay': barangaysJson.where((b) => b['city_id'] == c['id']),
        }).toList()
      }).toList(),
    }).toList();

    return RegionsList.fromJson(json);
  }
}