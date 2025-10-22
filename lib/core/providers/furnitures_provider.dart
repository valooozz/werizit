import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rangement/core/providers/storage_provider.dart';
import 'package:rangement/data/models/furniture.dart';

final furnituresProvider =
    StateNotifierProvider.family<FurnituresNotifier, List<Furniture>, int>(
      (ref, roomId) => FurnituresNotifier(ref, roomId),
    );

class FurnituresNotifier extends BaseStorageNotifier<Furniture> {
  final int roomId;
  FurnituresNotifier(super.ref, this.roomId) {
    loadAll(roomId);
  }

  @override
  Future<void> loadAll(int? roomId) async {
    final list = await dao.getFurnitureByRoom(roomId!);
    state = [...list];
  }

  @override
  Future<void> add(Furniture furniture) async {
    await dao.insertFurniture(furniture);
    await loadAll(furniture.room);
  }

  @override
  Future<void> delete(int furnitureId, int? roomId) async {
    await dao.deleteFurniture(furnitureId);
    await loadAll(roomId);
  }
}
