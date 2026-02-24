import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:werizit/core/providers/dao_provider.dart';
import 'package:werizit/data/models/room.dart';

import 'storages_provider.dart';

final roomsProvider = StateNotifierProvider<RoomsNotifier, Map<int, Room>>(
  (ref) => RoomsNotifier(dao: ref.read(daoProvider)),
);

class RoomsNotifier extends StorageNotifier<Room> {
  RoomsNotifier({required super.dao});

  @override
  Future<List<Room>> loadFromDb() async {
    return await dao.getRooms();
  }

  @override
  Future<int> insertToDb(Room item) => dao.insertRoom(item);

  @override
  Future<void> renameInDb(int id, String newName) =>
      dao.renameRoom(id, newName);

  @override
  Future<void> deleteFromDb(int id) => dao.deleteRoom(id);

  List<Room> roomsForHouse(int houseId) =>
      state.values.where((r) => r.house == houseId).toList();
}
