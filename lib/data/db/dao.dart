import 'package:rangement/data/db/base_dao.dart';
import 'package:rangement/data/models/item_info.dart';

import '../models/furniture.dart';
import '../models/house.dart';
import '../models/item.dart';
import '../models/room.dart';
import '../models/shelf.dart';
import 'database_helper.dart';

class DAO implements BaseDAO {
  final dbHelper = DatabaseHelper.instance;

  // ---------- HOUSE ----------
  @override
  Future<int> insertHouse(House house) async =>
      await dbHelper.insert('House', house.toMap());

  @override
  Future<List<House>> getHouses() async {
    final maps = await dbHelper.queryAll('House');
    return maps.map((m) => House.fromMap(m)).toList();
  }

  // ---------- ROOM ----------
  @override
  Future<int> insertRoom(Room room) async =>
      await dbHelper.insert('Room', room.toMap());

  @override
  Future<List<Room>> getRoomsByHouse(int houseId) async {
    final db = await dbHelper.database;
    final maps = await db.query(
      'Room',
      where: 'house = ?',
      whereArgs: [houseId],
    );
    return maps.map((m) => Room.fromMap(m)).toList();
  }

  // ---------- FURNITURE ----------
  @override
  Future<int> insertFurniture(Furniture f) async =>
      await dbHelper.insert('Furniture', f.toMap());

  @override
  Future<List<Furniture>> getFurnitureByRoom(int roomId) async {
    final db = await dbHelper.database;
    final maps = await db.query(
      'Furniture',
      where: 'room = ?',
      whereArgs: [roomId],
    );
    return maps.map((m) => Furniture.fromMap(m)).toList();
  }

  // ---------- SHELF ----------
  @override
  Future<int> insertShelf(Shelf shelf) async =>
      await dbHelper.insert('Shelf', shelf.toMap());

  @override
  Future<List<Shelf>> getShelvesByFurniture(int furnitureId) async {
    final db = await dbHelper.database;
    final maps = await db.query(
      'Shelf',
      where: 'furniture = ?',
      whereArgs: [furnitureId],
    );
    return maps.map((m) => Shelf.fromMap(m)).toList();
  }

  // ---------- ITEM ----------
  @override
  Future<int> insertItem(Item obj) async =>
      await dbHelper.insert('ObjectItem', obj.toMap());

  @override
  Future<List<Item>> getItemsByShelf(int shelfId) async {
    final db = await dbHelper.database;
    final maps = await db.query(
      'Item',
      where: 'shelf = ?',
      whereArgs: [shelfId],
    );
    return maps.map((m) => Item.fromMap(m)).toList();
  }

  @override
  Future<List<Item>> searchItems(String searchText) async {
    final db = await dbHelper.database;
    final maps = await db.query(
      'Item',
      where: 'name LIKE ?',
      whereArgs: ['%$searchText%'],
    );
    return maps.map((m) => Item.fromMap(m)).toList();
  }

  @override
  Future<ItemInfo> getItemInfo(int itemId) async {
    final db = await dbHelper.database;
    final maps = await db.rawQuery('''
      SELECT 
        I.id as id, 
        I.name as name, 
        H.name as house, 
        R.name as room, 
        F.name as furniture, 
        S.name as shelf 
      FROM Item I 
      INNER JOIN Shelf S ON I.shelf = S.id
      INNER JOIN Furniture F ON S.furniture = F.id 
      INNER JOIN Room R ON F.room = R.id
      INNER JOIN House H ON R.house = H.id
      WHERE I.id = $itemId
      ''');
    return maps.map((m) => ItemInfo.fromMap(m)).toList().first;
  }
}
