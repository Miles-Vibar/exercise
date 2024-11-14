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
            'CREATE TABLE regions (id INTEGER PRIMARY KEY AUTOINCREMENT, region_id TEXT NOT NULL, name TEXT NOT NULL)'
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

  Future<void> addAll(List<Region> regions) async {
    final db = await instance.database;
    int regionIndex = 0;
    int provinceIndex = 0;
    int cityIndex = 0;

    await db.transaction((t) async {
      final batch = t.batch();
      for (Region r in regions) {
        regionIndex++;
        batch.insert('regions', r.toJson());

        for (Province p in r.provinces!) {
          provinceIndex++;
          batch.insert('provinces', p.toJson(regionIndex));

          for (City c in p.cities!) {
            cityIndex++;
            batch.insert('cities', c.toJson(provinceIndex));

            for (Barangay b in c.barangays!) {
              batch.insert('barangays', b.toJson(cityIndex));
            }
          }
        }
      }

      await batch.commit();
    });
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