import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:werizit/data/models/room.dart';

import '../storage_provider.dart';

final roomProvider = AsyncNotifierProvider<RoomNotifier, Map<int, Room>>(
  RoomNotifier.new,
);

class RoomNotifier extends StorageNotifier<Room> {
  @override
  Future<List<Room>> loadFromDb() => dao.getRooms();

  @override
  Future<int> insertToDb(Room item) => dao.insertRoom(item);

  @override
  Future<void> renameInDb(int id, String newName) =>
      dao.renameRoom(id, newName);

  @override
  Future<void> deleteFromDb(int id) => dao.deleteRoom(id);
}
