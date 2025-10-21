import 'dart:async';

import 'package:rangement/data/db/base_dao.dart';
import 'package:rangement/data/models/item_info.dart';

import '../models/furniture.dart';
import '../models/house.dart';
import '../models/item.dart';
import '../models/room.dart';
import '../models/shelf.dart';

class MockDAO implements BaseDAO {
  // Stockage en mémoire
  final List<House> _houses = [
    House(id: 1, name: 'Paris'),
    House(id: 2, name: 'Yvré'),
  ];

  final Map<int, List<Room>> _rooms = {
    1: [Room(id: 1, name: 'Chambre', house: 1)],
    2: [
      Room(id: 2, name: 'Chambre', house: 2),
      Room(id: 3, name: 'Salle de bain', house: 2),
    ],
  };

  final Map<int, List<Furniture>> _furniture = {
    1: [Furniture(id: 1, name: 'Bureau', room: 1)],
    2: [Furniture(id: 2, name: 'Armoire', room: 2)],
  };

  final Map<int, List<Shelf>> _shelves = {
    1: [Shelf(id: 1, name: 'Tiroir 1', furniture: 1)],
  };

  final Map<int, List<Item>> _items = {
    1: [Item(id: 1, name: 'Casque Bose', shelf: 1)],
  };

  // ---------- HOUSE ----------
  @override
  Future<int> insertHouse(House house) async {
    _houses.add(house);
    return 0;
  }

  @override
  Future<List<House>> getHouses() async => _houses;

  // ---------- ROOM ----------
  @override
  Future<int> insertRoom(Room room) async {
    _rooms.putIfAbsent(room.house, () => []).add(room);
    return 0;
  }

  @override
  Future<List<Room>> getRoomsByHouse(int houseId) async =>
      _rooms[houseId] ?? [];

  // ---------- FURNITURE ----------
  @override
  Future<int> insertFurniture(Furniture f) async {
    _furniture.putIfAbsent(f.room, () => []).add(f);
    return 0;
  }

  @override
  Future<List<Furniture>> getFurnitureByRoom(int roomId) async =>
      _furniture[roomId] ?? [];

  // ---------- SHELF ----------
  @override
  Future<int> insertShelf(Shelf shelf) async {
    _shelves.putIfAbsent(shelf.furniture, () => []).add(shelf);
    return 0;
  }

  @override
  Future<List<Shelf>> getShelvesByFurniture(int furnitureId) async =>
      _shelves[furnitureId] ?? [];

  // ---------- ITEM ----------
  @override
  Future<int> insertItem(Item obj) async {
    _items.putIfAbsent(obj.shelf, () => []).add(obj);
    return 0;
  }

  @override
  Future<int> deleteItem(int itemId) async {
    _items.clear();
    return 0;
  }

  @override
  Future<List<Item>> getItemsByShelf(int shelfId) async =>
      _items[shelfId] ?? [];

  @override
  Future<List<Item>> searchItems(String searchText) async => _items[1] ?? [];

  @override
  Future<ItemInfo> getItemInfo(int itemId) async => Future.value(
    ItemInfo(
      id: 0,
      name: "Casque Bose",
      house: "Paris",
      room: "Chambre",
      furniture: "Bureau",
      shelf: "Tiroir 1",
    ),
  );
}
