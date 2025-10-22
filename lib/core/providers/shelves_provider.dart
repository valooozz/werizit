import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rangement/core/providers/storage_provider.dart';
import 'package:rangement/data/models/shelf.dart';

final shelvesProvider =
    StateNotifierProvider.family<ShelvesNotifier, List<Shelf>, int>(
      (ref, furnitureId) => ShelvesNotifier(ref, furnitureId),
    );

class ShelvesNotifier extends BaseStorageNotifier<Shelf> {
  final int furnitureId;
  ShelvesNotifier(super.ref, this.furnitureId) {
    loadAll(furnitureId);
  }

  @override
  Future<void> loadAll(int? furnitureId) async {
    final list = await dao.getShelvesByFurniture(furnitureId!);
    state = [...list];
  }

  @override
  Future<void> add(Shelf shelf) async {
    await dao.insertShelf(shelf);
    await loadAll(shelf.furniture);
  }

  @override
  Future<void> rename(int shelfId, String newName, int? furnitureId) async {
    await dao.renameShelf(shelfId, newName);
    await loadAll(furnitureId);
  }

  @override
  Future<void> delete(int shelfId, int? furnitureId) async {
    await dao.deleteShelf(shelfId);
    await loadAll(furnitureId);
  }
}
