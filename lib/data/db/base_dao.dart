import 'package:rangement/data/models/item_info.dart';

import '../models/furniture.dart';
import '../models/house.dart';
import '../models/item.dart';
import '../models/room.dart';
import '../models/shelf.dart';

abstract class BaseDAO {
  // HOUSE
  Future<int> insertHouse(House house);
  Future<List<House>> getHouses();
  Future<int> deleteHouse(int houseId);

  // ROOM
  Future<int> insertRoom(Room room);
  Future<List<Room>> getRoomsByHouse(int houseId);
  Future<int> deleteRoom(int roomId);

  // FURNITURE
  Future<int> insertFurniture(Furniture f);
  Future<List<Furniture>> getFurnitureByRoom(int roomId);
  Future<int> deleteFurniture(int furnitureId);

  // SHELF
  Future<int> insertShelf(Shelf shelf);
  Future<List<Shelf>> getShelvesByFurniture(int furnitureId);
  Future<int> deleteShelf(int shelfId);

  // ITEM
  Future<int> insertItem(Item obj);
  Future<List<Item>> getItemsByShelf(int shelfId);
  Future<int> deleteItem(int itemId);
  Future<List<Item>> searchItems(String searchText);
  Future<ItemInfo> getItemInfo(int itemId);
}
