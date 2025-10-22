import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rangement/core/providers/dao_provider.dart';
import 'package:rangement/data/models/room.dart';

import 'storage_provider.dart';

final roomsProvider = StateNotifierProvider<RoomsNotifier, Map<int, Room>>(
  (ref) => RoomsNotifier(dao: ref.read(daoProvider)),
);

class RoomsNotifier extends StorageNotifier<Room> {
  RoomsNotifier({required super.dao});

  @override
  Future<List<Room>> loadFromDb(int? parentId) async {
    return await dao.getRoomsByHouse(parentId!);
  }

  @override
  Future<int> insertToDb(Room item) => dao.insertRoom(item);

  @override
  Future<void> renameInDb(int id, String newName) =>
      dao.renameRoom(id, newName);

  @override
  Future<void> deleteFromDb(int id) => dao.deleteRoom(id);

  /// Récupérer les rooms associées à un house précis depuis l'état
  List<Room> roomsForHouse(int houseId) =>
      state.values.where((r) => r.house == houseId).toList();
}
