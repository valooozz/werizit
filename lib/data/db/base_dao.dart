import '../models/furniture.dart';
import '../models/house.dart';
import '../models/item.dart';
import '../models/room.dart';
import '../models/shelf.dart';

abstract class BaseDAO {
  // HOUSE
  Future<int> insertHouse(House house);
  Future<List<House>> getHouses();

  // ROOM
  Future<int> insertRoom(Room room);
  Future<List<Room>> getRoomsByHouse(int houseId);

  // FURNITURE
  Future<int> insertFurniture(Furniture f);
  Future<List<Furniture>> getFurnitureByRoom(int roomId);

  // SHELF
  Future<int> insertShelf(Shelf shelf);
  Future<List<Shelf>> getShelvesByFurniture(int furnitureId);

  // ITEM
  Future<int> insertItem(Item obj);
  Future<List<Item>> getItemsByShelf(int shelfId);
}
