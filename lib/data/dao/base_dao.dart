import 'package:werizit/data/models/furniture/furniture_draft.dart';
import 'package:werizit/data/models/house/house_draft.dart';
import 'package:werizit/data/models/room/room_draft.dart';
import 'package:werizit/data/models/shelf/shelf_draft.dart';
import 'package:werizit/data/models/thing/item_draft.dart';
import 'package:werizit/data/models/thing/item_info.dart';
import 'package:werizit/data/models/thing/trip.dart';
import 'package:werizit/data/models/thing/trip_draft.dart';

import '../models/furniture/furniture.dart';
import '../models/house/house.dart';
import '../models/room/room.dart';
import '../models/shelf/shelf.dart';
import '../models/thing/item.dart';

abstract class BaseDAO {
  // HOUSE
  Future<int> insertHouse(HouseDraft house);
  Future<List<House>> getHouses();
  Future<int> renameHouse(int houseId, String newName);
  Future<int> deleteHouse(int houseId);
  Future<String> getHouseName(int houseId);

  // ROOM
  Future<int> insertRoom(RoomDraft room);
  Future<List<Room>> getRooms();
  Future<List<Room>> getRoomsByHouse(int houseId);
  Future<int> renameRoom(int roomId, String newName);
  Future<int> deleteRoom(int roomId);
  Future<String> getRoomName(int roomId);

  // FURNITURE
  Future<int> insertFurniture(FurnitureDraft f);
  Future<List<Furniture>> getFurnitures();
  Future<List<Furniture>> getFurnituresByRoom(int roomId);
  Future<int> renameFurniture(int furnitureId, String newName);
  Future<int> deleteFurniture(int furnitureId);
  Future<String> getFurnitureName(int furnitureId);

  // SHELF
  Future<int> insertShelf(ShelfDraft shelf);
  Future<List<Shelf>> getShelves();
  Future<List<Shelf>> getShelvesByFurniture(int furnitureId);
  Future<int> renameShelf(int shelfId, String newName);
  Future<int> deleteShelf(int shelfId);
  Future<String> getShelfName(int sheldIf);

  // ITEM
  Future<int> insertItem(ItemDraft item);
  Future<List<Item>> getItems();
  // Future<List<Item>> getItemsByShelf(int shelfId);
  Future<int> renameItem(int itemId, String newName);
  Future<int> deleteItem(int itemId);
  Future<List<Item>> searchItems(String searchText);
  Future<ItemInfo> getItemInfo(int itemId);
  Future<void> putItemsIntoBox(List<int> itemIds);
  Future<List<Item>> getItemsFromBox();
  Future<void> dropItemsFromBox(List<int> itemIds, int shelfId);
  Future<void> takeItem(int itemId);
  Future<void> untakeItem(int itemId);
  Future<void> untakeAllItems();

  // TRIP
  Future<int> insertTrip(TripDraft trip);
  Future<List<Trip>> getTrips();
  Future<int> renameTrip(int tripId, String newName);
  Future<int> deleteTrip(int tripId);
  Future<void> unlinkItem(int itemId);
  Future<List<int>> getTripsByItem(int itemId);
  Future<void> updateSelectedTrips(List<int> tripIdsToSelect);

  // TRIP/ITEM
  Future<void> linkTripsToItems(List<int> tripIds, List<int> itemIds);
  Future<void> unlinkTripsFromItems(List<int> tripIds, List<int> itemIds);
}
