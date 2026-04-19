import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:werizit/data/models/furniture.dart';

import '../storages_provider.dart';

final furnitureProvider =
    AsyncNotifierProvider<FurnitureNotifier, Map<int, Furniture>>(
      FurnitureNotifier.new,
    );

class FurnitureNotifier extends StorageNotifier<Furniture> {
  @override
  Future<List<Furniture>> loadFromDb() => dao.getFurnitures();

  @override
  Future<int> insertToDb(Furniture item) => dao.insertFurniture(item);

  @override
  Future<void> renameInDb(int id, String newName) =>
      dao.renameFurniture(id, newName);

  @override
  Future<void> deleteFromDb(int id) => dao.deleteFurniture(id);
}
