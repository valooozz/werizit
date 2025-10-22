import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rangement/core/providers/dao_provider.dart';
import 'package:rangement/data/models/shelf.dart';

import 'storage_provider.dart';

final shelvesProvider = StateNotifierProvider<ShelvesNotifier, Map<int, Shelf>>(
  (ref) => ShelvesNotifier(dao: ref.read(daoProvider)),
);

class ShelvesNotifier extends StorageNotifier<Shelf> {
  ShelvesNotifier({required super.dao});

  @override
  Future<List<Shelf>> loadFromDb(int? parentId) async {
    return await dao.getShelvesByFurniture(parentId!);
  }

  @override
  Future<int> insertToDb(Shelf item) => dao.insertShelf(item);

  @override
  Future<void> renameInDb(int id, String newName) =>
      dao.renameShelf(id, newName);

  @override
  Future<void> deleteFromDb(int id) => dao.deleteShelf(id);

  List<Shelf> shelvesForFurniture(int furnitureId) =>
      state.values.where((s) => s.furniture == furnitureId).toList();
}
