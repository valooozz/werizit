import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rangement/core/providers/storage_provider.dart';
import 'package:rangement/data/models/room.dart';

final roomsProvider = StateNotifierProvider<RoomsNotifier, List<Room>>(
  (ref) => RoomsNotifier(ref),
);

class RoomsNotifier extends BaseStorageNotifier<Room> {
  RoomsNotifier(Ref ref) : super(ref);

  @override
  Future<void> loadAll(int? houseId) async {
    final list = await dao.getRoomsByHouse(houseId!);
    state = [...list];
  }

  @override
  Future<void> add(Room room) async {
    await dao.insertRoom(room);
    await loadAll(room.house);
  }

  @override
  Future<void> delete(int roomId, int? houseId) async {
    await dao.deleteRoom(roomId);
    await loadAll(houseId);
  }
}
