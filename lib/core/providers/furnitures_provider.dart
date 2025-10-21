import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rangement/core/providers/storage_provider.dart';
import 'package:rangement/data/models/furniture.dart';

final furnituresProvider =
    StateNotifierProvider<FurnituresNotifier, List<Furniture>>(
      (ref) => FurnituresNotifier(ref),
    );

class FurnituresNotifier extends BaseStorageNotifier<Furniture> {
  FurnituresNotifier(Ref ref) : super(ref);

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
