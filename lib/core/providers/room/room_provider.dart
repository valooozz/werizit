import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:werizit/data/models/room/room.dart';
import 'package:werizit/data/models/room/room_draft.dart';

import '../storage_provider.dart';

final roomProvider = AsyncNotifierProvider<RoomNotifier, Map<int, Room>>(
  RoomNotifier.new,
);

class RoomNotifier extends StorageNotifier<Room, RoomDraft> {
  @override
  Future<List<Room>> loadFromDb() => dao.getRooms();

  @override
  Future<int> insertToDb(RoomDraft item) => dao.insertRoom(item);

  @override
  Future<void> renameInDb(int id, String newName) =>
      dao.renameRoom(id, newName);

  @override
  Future<void> deleteFromDb(int id) => dao.deleteRoom(id);

  @override
  Room fromDraft(RoomDraft draft, int id) =>
      Room(id: id, name: draft.name, house: draft.house);
}
