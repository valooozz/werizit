import 'package:rangement/data/models/item_info.dart';
import 'package:rangement/data/models/trip.dart';

import '../models/furniture.dart';
import '../models/house.dart';
import '../models/item.dart';
import '../models/room.dart';
import '../models/shelf.dart';

abstract class BaseDAO {
  // HOUSE
  Future<int> insertHouse(House house);
  Future<List<House>> getHouses();
  Future<int> renameHouse(int houseId, String newName);
  Future<int> deleteHouse(int houseId);
  Future<String> getHouseName(int houseId);

  // ROOM
  Future<int> insertRoom(Room room);
  Future<List<Room>> getRooms();
  Future<List<Room>> getRoomsByHouse(int houseId);
  Future<int> renameRoom(int roomId, String newName);
  Future<int> deleteRoom(int roomId);
  Future<String> getRoomName(int roomId);

  // FURNITURE
  Future<int> insertFurniture(Furniture f);
  Future<List<Furniture>> getFurnitures();
  Future<List<Furniture>> getFurnituresByRoom(int roomId);
  Future<int> renameFurniture(int furnitureId, String newName);
  Future<int> deleteFurniture(int furnitureId);
  Future<String> getFurnitureName(int furnitureId);

  // SHELF
  Future<int> insertShelf(Shelf shelf);
  Future<List<Shelf>> getShelves();
  Future<List<Shelf>> getShelvesByFurniture(int furnitureId);
  Future<int> renameShelf(int shelfId, String newName);
  Future<int> deleteShelf(int shelfId);
  Future<String> getShelfName(int sheldIf);

  // ITEM
  Future<int> insertItem(Item item);
  Future<List<Item>> getItems();
  Future<List<Item>> getItemsByShelf(int shelfId);
  Future<int> renameItem(int itemId, String newName);
  Future<int> deleteItem(int itemId);
  Future<List<Item>> searchItems(String searchText);
  Future<ItemInfo> getItemInfo(int itemId);
  Future<void> putItemsIntoBox(List<int> itemIds);
  Future<List<Item>> getItemsFromBox();
  Future<void> dropItemsFromBox(List<int> itemIds, int shelfId);

  // TRIP
  Future<int> insertTrip(Trip trip);
  Future<List<Trip>> getTrips();
  Future<int> renameTrip(int tripId, String newName);
  Future<int> deleteTrip(int tripId);
  Future<int> linkTripItem(int tripId, int itemId);
  Future<void> unlinkTripItem(int tripId, int itemId);
}
