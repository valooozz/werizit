import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rangement/core/providers/storage_provider.dart';
import 'package:rangement/data/models/room.dart';

final roomsProvider =
    StateNotifierProvider.family<RoomsNotifier, List<Room>, int>(
      (ref, houseId) => RoomsNotifier(ref, houseId),
    );

class RoomsNotifier extends BaseStorageNotifier<Room> {
  final int houseId;
  RoomsNotifier(super.ref, this.houseId) {
    loadAll(houseId);
  }

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
  Future<void> rename(int roomId, String newName, int? parentId) async {
    await dao.renameRoom(roomId, newName);
    await loadAll(parentId);
  }

  @override
  Future<void> delete(int roomId, int? houseId) async {
    await dao.deleteRoom(roomId);
    await loadAll(houseId);
  }
}
