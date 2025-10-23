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

  @override
  Future<int> renameHouse(int houseId, String newName) async {
    return await dbHelper.update('House', {'name': newName}, houseId);
  }

  @override
  Future<int> deleteHouse(int houseId) async {
    return await dbHelper.delete('House', houseId);
  }

  @override
  Future<String> getHouseName(int houseId) async {
    final db = await dbHelper.database;
    final result = await db.query(
      'House',
      where: 'id = ?',
      whereArgs: [houseId],
    );
    return House.fromMap(result.first).name;
  }

  // ---------- ROOM ----------
  @override
  Future<int> insertRoom(Room room) async =>
      await dbHelper.insert('Room', room.toMap());

  @override
  Future<List<Room>> getRooms() async {
    final maps = await dbHelper.queryAll('Room');
    return maps.map((m) => Room.fromMap(m)).toList();
  }

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

  @override
  Future<int> renameRoom(int roomId, String newName) async {
    return await dbHelper.update('Room', {'name': newName}, roomId);
  }

  @override
  Future<int> deleteRoom(int roomId) async {
    return await dbHelper.delete('Room', roomId);
  }

  @override
  Future<String> getRoomName(int roomId) async {
    final db = await dbHelper.database;
    final result = await db.query('Room', where: 'id = ?', whereArgs: [roomId]);
    return Room.fromMap(result.first).name;
  }

  // ---------- FURNITURE ----------
  @override
  Future<int> insertFurniture(Furniture f) async =>
      await dbHelper.insert('Furniture', f.toMap());

  @override
  Future<List<Furniture>> getFurnitures() async {
    final maps = await dbHelper.queryAll('Furniture');
    return maps.map((m) => Furniture.fromMap(m)).toList();
  }

  @override
  Future<List<Furniture>> getFurnituresByRoom(int roomId) async {
    final db = await dbHelper.database;
    final maps = await db.query(
      'Furniture',
      where: 'room = ?',
      whereArgs: [roomId],
    );
    return maps.map((m) => Furniture.fromMap(m)).toList();
  }

  @override
  Future<int> renameFurniture(int furnitureId, String newName) async {
    return await dbHelper.update('Furniture', {'name': newName}, furnitureId);
  }

  @override
  Future<int> deleteFurniture(int furnitureId) async {
    return await dbHelper.delete('Furniture', furnitureId);
  }

  @override
  Future<String> getFurnitureName(int furnitureId) async {
    final db = await dbHelper.database;
    final result = await db.query(
      'Furniture',
      where: 'id = ?',
      whereArgs: [furnitureId],
    );
    return Room.fromMap(result.first).name;
  }

  // ---------- SHELF ----------
  @override
  Future<int> insertShelf(Shelf shelf) async =>
      await dbHelper.insert('Shelf', shelf.toMap());

  @override
  Future<List<Shelf>> getShelves() async {
    final maps = await dbHelper.queryAll('Shelf');
    return maps.map((m) => Shelf.fromMap(m)).toList();
  }

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

  @override
  Future<int> renameShelf(int shelfId, String newName) async {
    return await dbHelper.update('Shelf', {'name': newName}, shelfId);
  }

  @override
  Future<int> deleteShelf(int shelfId) async {
    return await dbHelper.delete('Shelf', shelfId);
  }

  @override
  Future<String> getShelfName(int shelfId) async {
    final db = await dbHelper.database;
    final result = await db.query(
      'Shelf',
      where: 'id = ?',
      whereArgs: [shelfId],
    );
    return Room.fromMap(result.first).name;
  }

  // ---------- ITEM ----------
  @override
  Future<int> insertItem(Item obj) async =>
      await dbHelper.insert('Item', obj.toMap());

  @override
  Future<List<Item>> getItems() async {
    final maps = await dbHelper.queryAll('Item');
    return maps.map((m) => Item.fromMap(m)).toList();
  }

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
  Future<int> renameItem(int itemId, String newName) async {
    return await dbHelper.update('Item', {'name': newName}, itemId);
  }

  @override
  Future<int> deleteItem(int itemId) async =>
      await dbHelper.delete('Item', itemId);

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

  @override
  Future<void> putItemsIntoBox(List<int> itemIds) async {
    final db = await dbHelper.database;
    await db.update(
      'Item',
      {'shelf': null},
      where: 'id IN ?',
      whereArgs: itemIds,
    );
  }

  @override
  Future<List<Item>> getItemsFromBox() async {
    final db = await dbHelper.database;
    final maps = await db.query('Item', where: 'shelf IS NULL');
    return maps.map((m) => Item.fromMap(m)).toList();
  }

  @override
  Future<void> dropItemsFromBox(List<int> itemIds, int shelfId) async {
    final db = await dbHelper.database;
    await db.update(
      'Item',
      {'shelf': shelfId},
      where: 'id IN ?',
      whereArgs: itemIds,
    );
  }
}
