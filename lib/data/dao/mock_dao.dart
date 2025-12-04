import 'dart:math';

import 'package:werizit/data/dao/base_dao.dart';
import 'package:werizit/data/dao/mock_data.dart';
import 'package:werizit/data/models/furniture.dart';
import 'package:werizit/data/models/house.dart';
import 'package:werizit/data/models/item.dart';
import 'package:werizit/data/models/item_info.dart';
import 'package:werizit/data/models/room.dart';
import 'package:werizit/data/models/shelf.dart';

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
    final house3 = House(id: _generateId(), name: 'Chalet à la montagne');
    _houses[house1.id!] = house1;
    _houses[house2.id!] = house2;
    _houses[house3.id!] = house3;

    // ---------- Pièces ----------
    final salon = Room(id: _generateId(), name: 'Salon', house: house1.id!);
    final cuisine = Room(id: _generateId(), name: 'Cuisine', house: house1.id!);
    final chambre = Room(
      id: _generateId(),
      name: 'Chambre principale',
      house: house1.id!,
    );
    final salleDeBain = Room(
      id: _generateId(),
      name: 'Salle de bain',
      house: house1.id!,
    );
    final bureau = Room(id: _generateId(), name: 'Bureau', house: house1.id!);

    final salonVac = Room(id: _generateId(), name: 'Salon', house: house2.id!);
    final cuisineVac = Room(
      id: _generateId(),
      name: 'Cuisine',
      house: house2.id!,
    );
    final chambreVac = Room(
      id: _generateId(),
      name: 'Chambre',
      house: house2.id!,
    );

    final salonChalet = Room(
      id: _generateId(),
      name: 'Salon rustique',
      house: house3.id!,
    );
    final chambreChalet = Room(
      id: _generateId(),
      name: 'Chambre d\'hôte',
      house: house3.id!,
    );
    final cuisineChalet = Room(
      id: _generateId(),
      name: 'Cuisine boisée',
      house: house3.id!,
    );

    final rooms = [
      salon,
      cuisine,
      chambre,
      salleDeBain,
      bureau,
      salonVac,
      cuisineVac,
      chambreVac,
      salonChalet,
      chambreChalet,
      cuisineChalet,
    ];
    for (final r in rooms) {
      _rooms[r.id!] = r;
    }

    // ---------- Meubles ----------
    final meubles = [
      Furniture(id: _generateId(), name: 'Meuble TV', room: salon.id!),
      Furniture(id: _generateId(), name: 'Bibliothèque', room: salon.id!),
      Furniture(id: _generateId(), name: 'Canapé avec coffre', room: salon.id!),
      Furniture(
        id: _generateId(),
        name: 'Placard de cuisine',
        room: cuisine.id!,
      ),
      Furniture(id: _generateId(), name: 'Buffet', room: cuisine.id!),
      Furniture(id: _generateId(), name: 'Commode', room: chambre.id!),
      Furniture(id: _generateId(), name: 'Table de chevet', room: chambre.id!),
      Furniture(id: _generateId(), name: 'Armoire', room: chambre.id!),
      Furniture(
        id: _generateId(),
        name: 'Meuble sous lavabo',
        room: salleDeBain.id!,
      ),
      Furniture(id: _generateId(), name: 'Bureau principal', room: bureau.id!),
      Furniture(id: _generateId(), name: 'Étagère murale', room: bureau.id!),
      Furniture(id: _generateId(), name: 'Buffet de salon', room: salonVac.id!),
      Furniture(id: _generateId(), name: 'Placard mural', room: cuisineVac.id!),
      Furniture(
        id: _generateId(),
        name: 'Commode en bois',
        room: chambreVac.id!,
      ),
      Furniture(
        id: _generateId(),
        name: 'Meuble TV rustique',
        room: salonChalet.id!,
      ),
      Furniture(
        id: _generateId(),
        name: 'Placard bois',
        room: cuisineChalet.id!,
      ),
      Furniture(
        id: _generateId(),
        name: 'Armoire ancienne',
        room: chambreChalet.id!,
      ),
    ];
    for (final f in meubles) {
      _furniture[f.id!] = f;
    }

    // ---------- Étagères / Tiroirs ----------
    final shelves = <Shelf>[
      // Salon maison principale
      Shelf(
        id: _generateId(),
        name: 'Étagère supérieure',
        furniture: meubles[0].id!,
      ),
      Shelf(
        id: _generateId(),
        name: 'Étagère inférieure',
        furniture: meubles[0].id!,
      ),
      Shelf(
        id: _generateId(),
        name: 'Rayon du haut',
        furniture: meubles[1].id!,
      ),
      Shelf(id: _generateId(), name: 'Rayon du bas', furniture: meubles[1].id!),
      Shelf(
        id: _generateId(),
        name: 'Coffre principal',
        furniture: meubles[2].id!,
      ),

      // Cuisine maison principale
      Shelf(
        id: _generateId(),
        name: 'Placard du haut',
        furniture: meubles[3].id!,
      ),
      Shelf(
        id: _generateId(),
        name: 'Placard du bas',
        furniture: meubles[3].id!,
      ),
      Shelf(
        id: _generateId(),
        name: 'Tiroir à couverts',
        furniture: meubles[4].id!,
      ),
      Shelf(
        id: _generateId(),
        name: 'Tiroir à nappes',
        furniture: meubles[4].id!,
      ),

      // Chambre principale
      Shelf(
        id: _generateId(),
        name: 'Tiroir principal',
        furniture: meubles[5].id!,
      ),
      Shelf(
        id: _generateId(),
        name: 'Tiroir supérieur',
        furniture: meubles[6].id!,
      ),
      Shelf(
        id: _generateId(),
        name: 'Espace penderie',
        furniture: meubles[7].id!,
      ),

      // Bureau
      Shelf(
        id: _generateId(),
        name: 'Tiroir du bureau',
        furniture: meubles[9].id!,
      ),
      Shelf(
        id: _generateId(),
        name: 'Étagère documents',
        furniture: meubles[10].id!,
      ),

      // Appartement de vacances
      Shelf(
        id: _generateId(),
        name: 'Tiroir principal',
        furniture: meubles[12].id!,
      ),
      Shelf(
        id: _generateId(),
        name: 'Rayon du haut',
        furniture: meubles[11].id!,
      ),
      Shelf(
        id: _generateId(),
        name: 'Espace penderie',
        furniture: meubles[14].id!,
      ),

      // Chalet
      Shelf(id: _generateId(), name: 'Étagère TV', furniture: meubles[14].id!),
      Shelf(
        id: _generateId(),
        name: 'Tiroir cuisine',
        furniture: meubles[15].id!,
      ),
      Shelf(
        id: _generateId(),
        name: 'Penderie bois',
        furniture: meubles[16].id!,
      ),
    ];

    for (final s in shelves) {
      _shelves[s.id!] = s;
    }

    // ---------- Items ----------

    final items = <Item>[];
    final shelfIds = shelves.map((s) => s.id!).toList();
    final random = Random();

    for (final name in itemNames) {
      final shelfId = shelfIds[random.nextInt(shelfIds.length)];
      items.add(Item(id: _generateId(), name: name, shelf: shelfId));
    }

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
  Future<List<House>> getHouses() async =>
      _houses.values.toList()
        ..sort((house1, house2) => house1.name.compareTo(house2.name));

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
  Future<List<Room>> getRooms() async =>
      _rooms.values.toList()
        ..sort((room1, room2) => room1.name.compareTo(room2.name));

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
  Future<List<Furniture>> getFurnitures() async => _furniture.values.toList()
    ..sort(
      (furniture1, furniture2) => furniture1.name.compareTo(furniture2.name),
    );

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
  Future<List<Shelf>> getShelves() async =>
      _shelves.values.toList()
        ..sort((shelf1, shelf2) => shelf1.name.compareTo(shelf2.name));

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
  Future<List<Item>> getItems() async =>
      _items.values.toList()
        ..sort((item1, item2) => item1.name.compareTo(item2.name));

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
