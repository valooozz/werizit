import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rangement/core/providers/dao_provider.dart';
import 'package:rangement/data/models/furniture.dart';

import 'storage_provider.dart';

final furnituresProvider =
    StateNotifierProvider<FurnituresNotifier, Map<int, Furniture>>(
      (ref) => FurnituresNotifier(dao: ref.read(daoProvider)),
    );

class FurnituresNotifier extends StorageNotifier<Furniture> {
  FurnituresNotifier({required super.dao});

  @override
  Future<List<Furniture>> loadFromDb(int? parentId) async {
    if (parentId != null) {
      return await dao.getFurnitureByRoom(parentId);
    } else {
      return [];
    }
  }

  @override
  Future<int> insertToDb(Furniture item) => dao.insertFurniture(item);

  @override
  Future<void> renameInDb(int id, String newName) =>
      dao.renameFurniture(id, newName);

  @override
  Future<void> deleteFromDb(int id) => dao.deleteFurniture(id);

  List<Furniture> furnituresForRoom(int roomId) =>
      state.values.where((f) => f.room == roomId).toList();
}
