import 'package:rangement/data/db/base_dao.dart';
import 'package:rangement/data/models/furniture.dart';
import 'package:rangement/data/models/house.dart';
import 'package:rangement/data/models/item.dart';
import 'package:rangement/data/models/item_info.dart';
import 'package:rangement/data/models/room.dart';
import 'package:rangement/data/models/shelf.dart';

/// Mock DAO en mémoire avec jeu de données de démonstration.
class MockDAO implements BaseDAO {
  final _houses = <int, House>{};
  final _rooms = <int, Room>{};
  final _furniture = <int, Furniture>{};
  final _shelves = <int, Shelf>{};
  final _items = <int, Item>{};

  int _nextId = 1;
  int _generateId() => _nextId++;

  MockDAO() {
    _populateDemoData();
  }

  void _populateDemoData() {
    // ---------- Maisons ----------
    final house1 = House(id: _generateId(), name: 'Maison principale');
    final house2 = House(id: _generateId(), name: 'Appartement de vacances');
    _houses[house1.id!] = house1;
    _houses[house2.id!] = house2;

    // ---------- Pièces ----------
    final salon = Room(id: _generateId(), name: 'Salon', house: house1.id!);
    final cuisine = Room(id: _generateId(), name: 'Cuisine', house: house1.id!);
    final chambre = Room(id: _generateId(), name: 'Chambre', house: house2.id!);
    _rooms[salon.id!] = salon;
    _rooms[cuisine.id!] = cuisine;
    _rooms[chambre.id!] = chambre;

    // ---------- Meubles ----------
    final meubleTv = Furniture(
      id: _generateId(),
      name: 'Meuble TV',
      room: salon.id!,
    );
    final placard = Furniture(
      id: _generateId(),
      name: 'Placard',
      room: cuisine.id!,
    );
    final commode = Furniture(
      id: _generateId(),
      name: 'Commode',
      room: chambre.id!,
    );
    _furniture[meubleTv.id!] = meubleTv;
    _furniture[placard.id!] = placard;
    _furniture[commode.id!] = commode;

    // ---------- Étagères ----------
    final etagereTv1 = Shelf(
      id: _generateId(),
      name: 'Étagère supérieure',
      furniture: meubleTv.id!,
    );
    final etagereTv2 = Shelf(
      id: _generateId(),
      name: 'Étagère inférieure',
      furniture: meubleTv.id!,
    );
    final etagerePlacard = Shelf(
      id: _generateId(),
      name: 'Étagère du haut',
      furniture: placard.id!,
    );
    final tiroirCommode = Shelf(
      id: _generateId(),
      name: 'Tiroir principal',
      furniture: commode.id!,
    );
    _shelves[etagereTv1.id!] = etagereTv1;
    _shelves[etagereTv2.id!] = etagereTv2;
    _shelves[etagerePlacard.id!] = etagerePlacard;
    _shelves[tiroirCommode.id!] = tiroirCommode;

    // ---------- Items ----------
    final items = [
      Item(id: _generateId(), name: 'Télécommande', shelf: etagereTv1.id!),
      Item(id: _generateId(), name: 'Console de jeux', shelf: etagereTv2.id!),
      Item(
        id: _generateId(),
        name: 'Livre de recettes',
        shelf: etagerePlacard.id!,
      ),
      Item(id: _generateId(), name: 'Boîte à bijoux', shelf: tiroirCommode.id!),
      Item(id: _generateId(), name: 'Câble HDMI', shelf: etagereTv2.id!),
    ];
    for (final i in items) {
      _items[i.id!] = i;
    }
  }

  // ---------- HOUSE ----------
  @override
  Future<int> insertHouse(House house) async {
    final id = _generateId();
    _houses[id] = house.copyWith(id: id);
    return id;
  }

  @override
  Future<List<House>> getHouses() async => _houses.values.toList();

  @override
  Future<int> renameHouse(int houseId, String newName) async {
    final h = _houses[houseId];
    if (h == null) return 0;
    _houses[houseId] = h.copyWith(name: newName);
    return 1;
  }

  @override
  Future<int> deleteHouse(int houseId) async {
    _houses.remove(houseId);
    _rooms.removeWhere((_, r) => r.house == houseId);
    _furniture.removeWhere((_, f) => _rooms[f.room]?.house == houseId);
    _shelves.removeWhere((_, s) => _furniture[s.furniture]?.room == houseId);
    _items.removeWhere((_, i) => _shelves[i.shelf]?.furniture == houseId);
    return 1;
  }

  @override
  Future<String> getHouseName(int houseId) async {
    return _houses[houseId]?.name ?? 'Unknown';
  }

  // ---------- ROOM ----------
  @override
  Future<int> insertRoom(Room room) async {
    final id = _generateId();
    _rooms[id] = room.copyWith(id: id);
    return id;
  }

  @override
  Future<List<Room>> getRooms() async => _rooms.values.toList();

  @override
  Future<List<Room>> getRoomsByHouse(int houseId) async {
    return _rooms.values.where((r) => r.house == houseId).toList();
  }

  @override
  Future<int> renameRoom(int roomId, String newName) async {
    final r = _rooms[roomId];
    if (r == null) return 0;
    _rooms[roomId] = r.copyWith(name: newName);
    return 1;
  }

  @override
  Future<int> deleteRoom(int roomId) async {
    _rooms.remove(roomId);
    _furniture.removeWhere((_, f) => f.room == roomId);
    _shelves.removeWhere((_, s) => _furniture[s.furniture]?.room == roomId);
    _items.removeWhere((_, i) => _shelves[i.shelf]?.furniture == roomId);
    return 1;
  }

  @override
  Future<String> getRoomName(int roomId) async =>
      _rooms[roomId]?.name ?? 'Unknown';

  // ---------- FURNITURE ----------
  @override
  Future<int> insertFurniture(Furniture f) async {
    final id = _generateId();
    _furniture[id] = f.copyWith(id: id);
    return id;
  }

  @override
  Future<List<Furniture>> getFurnitures() async => _furniture.values.toList();

  @override
  Future<List<Furniture>> getFurnituresByRoom(int roomId) async =>
      _furniture.values.where((f) => f.room == roomId).toList();

  @override
  Future<int> renameFurniture(int furnitureId, String newName) async {
    final f = _furniture[furnitureId];
    if (f == null) return 0;
    _furniture[furnitureId] = f.copyWith(name: newName);
    return 1;
  }

  @override
  Future<int> deleteFurniture(int furnitureId) async {
    _furniture.remove(furnitureId);
    _shelves.removeWhere((_, s) => s.furniture == furnitureId);
    _items.removeWhere((_, i) => _shelves[i.shelf]?.furniture == furnitureId);
    return 1;
  }

  @override
  Future<String> getFurnitureName(int furnitureId) async =>
      _furniture[furnitureId]?.name ?? 'Unknown';

  // ---------- SHELF ----------
  @override
  Future<int> insertShelf(Shelf shelf) async {
    final id = _generateId();
    _shelves[id] = shelf.copyWith(id: id);
    return id;
  }

  @override
  Future<List<Shelf>> getShelves() async => _shelves.values.toList();

  @override
  Future<List<Shelf>> getShelvesByFurniture(int furnitureId) async =>
      _shelves.values.where((s) => s.furniture == furnitureId).toList();

  @override
  Future<int> renameShelf(int shelfId, String newName) async {
    final s = _shelves[shelfId];
    if (s == null) return 0;
    _shelves[shelfId] = s.copyWith(name: newName);
    return 1;
  }

  @override
  Future<int> deleteShelf(int shelfId) async {
    _shelves.remove(shelfId);
    _items.removeWhere((_, i) => i.shelf == shelfId);
    return 1;
  }

  @override
  Future<String> getShelfName(int shelfId) async =>
      _shelves[shelfId]?.name ?? 'Unknown';

  // ---------- ITEM ----------
  @override
  Future<int> insertItem(Item obj) async {
    final id = _generateId();
    _items[id] = obj.copyWith(id: id);
    return id;
  }

  @override
  Future<List<Item>> getItems() async => _items.values.toList();

  @override
  Future<List<Item>> getItemsByShelf(int shelfId) async =>
      _items.values.where((i) => i.shelf == shelfId).toList();

  @override
  Future<int> renameItem(int itemId, String newName) async {
    final i = _items[itemId];
    if (i == null) return 0;
    _items[itemId] = i.copyWith(name: newName);
    return 1;
  }

  @override
  Future<int> deleteItem(int itemId) async {
    _items.remove(itemId);
    return 1;
  }

  @override
  Future<List<Item>> searchItems(String searchText) async => _items.values
      .where((i) => i.name.toLowerCase().contains(searchText.toLowerCase()))
      .toList();

  @override
  Future<ItemInfo> getItemInfo(int itemId) async {
    final i = _items[itemId];
    if (i == null) throw Exception('Item not found');

    final shelf = i.shelf != null ? _shelves[i.shelf] : null;
    final furniture = shelf != null ? _furniture[shelf.furniture] : null;
    final room = furniture != null ? _rooms[furniture.room] : null;
    final house = room != null ? _houses[room.house] : null;

    return ItemInfo(
      id: i.id!,
      name: i.name,
      house: house?.name ?? '-',
      room: room?.name ?? '-',
      furniture: furniture?.name ?? '-',
      shelf: shelf?.name ?? '-',
    );
  }

  @override
  Future<void> putItemsIntoBox(List<int> itemIds) async {
    for (final id in itemIds) {
      final i = _items[id];
      if (i != null) _items[id] = i.copyWith(shelf: -1);
    }
  }

  @override
  Future<List<Item>> getItemsFromBox() async =>
      _items.values.where((i) => i.shelf == -1).toList();

  @override
  Future<void> dropItemsFromBox(List<int> itemIds, int shelfId) async {
    for (final id in itemIds) {
      final i = _items[id];
      if (i != null) _items[id] = i.copyWith(shelf: shelfId);
    }
  }
}
