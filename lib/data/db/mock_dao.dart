import 'package:rangement/data/db/base_dao.dart';

import '../models/furniture.dart';
import '../models/house.dart';
import '../models/item.dart';
import '../models/room.dart';
import '../models/shelf.dart';

class MockDAO implements BaseDAO {
  // Stockage en mémoire
  final List<House> _houses = [House(id: 1, name: 'Maison Test')];

  final Map<int, List<Room>> _rooms = {
    1: [Room(id: 1, name: 'Salon', house: 1)],
  };

  final Map<int, List<Furniture>> _furniture = {
    1: [Furniture(id: 1, name: 'Canapé', room: 1)],
  };

  final Map<int, List<Shelf>> _shelves = {
    1: [Shelf(id: 1, name: 'Étagère 1', furniture: 1)],
  };

  final Map<int, List<Item>> _items = {
    1: [Item(id: 1, name: 'Livre', shelf: 1)],
  };

  // ---------- HOUSE ----------
  @override
  Future<int> insertHouse(House house) async {
    _houses.add(house);
    return house.id;
  }

  @override
  Future<List<House>> getHouses() async => _houses;

  // ---------- ROOM ----------
  @override
  Future<int> insertRoom(Room room) async {
    _rooms.putIfAbsent(room.house, () => []).add(room);
    return room.id;
  }

  @override
  Future<List<Room>> getRoomsByHouse(int houseId) async =>
      _rooms[houseId] ?? [];

  // ---------- FURNITURE ----------
  @override
  Future<int> insertFurniture(Furniture f) async {
    _furniture.putIfAbsent(f.room, () => []).add(f);
    return f.id;
  }

  @override
  Future<List<Furniture>> getFurnitureByRoom(int roomId) async =>
      _furniture[roomId] ?? [];

  // ---------- SHELF ----------
  @override
  Future<int> insertShelf(Shelf shelf) async {
    _shelves.putIfAbsent(shelf.furniture, () => []).add(shelf);
    return shelf.id;
  }

  @override
  Future<List<Shelf>> getShelvesByFurniture(int furnitureId) async =>
      _shelves[furnitureId] ?? [];

  // ---------- ITEM ----------
  @override
  Future<int> insertItem(Item obj) async {
    _items.putIfAbsent(obj.shelf, () => []).add(obj);
    return obj.id;
  }

  @override
  Future<List<Item>> getItemsByShelf(int shelfId) async =>
      _items[shelfId] ?? [];
}
