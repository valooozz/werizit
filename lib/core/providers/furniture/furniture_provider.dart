import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:werizit/data/models/furniture/furniture.dart';
import 'package:werizit/data/models/furniture/furniture_draft.dart';

import '../storage_provider.dart';

final furnitureProvider =
    AsyncNotifierProvider<FurnitureNotifier, Map<int, Furniture>>(
      FurnitureNotifier.new,
    );

class FurnitureNotifier extends StorageNotifier<Furniture, FurnitureDraft> {
  @override
  Future<List<Furniture>> loadFromDb() => dao.getFurnitures();

  @override
  Future<int> insertToDb(FurnitureDraft item) => dao.insertFurniture(item);

  @override
  Future<void> renameInDb(int id, String newName) =>
      dao.renameFurniture(id, newName);

  @override
  Future<void> deleteFromDb(int id) => dao.deleteFurniture(id);

  @override
  Furniture fromDraft(FurnitureDraft draft, int id) =>
      Furniture(id: id, name: draft.name, room: draft.room);
}
