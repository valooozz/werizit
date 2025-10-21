import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rangement/core/providers/storage_provider.dart';
import 'package:rangement/data/models/shelf.dart';

final shelvesProvider = StateNotifierProvider<ShelvesNotifier, List<Shelf>>(
  (ref) => ShelvesNotifier(ref),
);

class ShelvesNotifier extends BaseStorageNotifier<Shelf> {
  ShelvesNotifier(Ref ref) : super(ref);

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
  Future<void> delete(int shelfId, int? furnitureId) async {
    await dao.deleteShelf(shelfId);
    await loadAll(furnitureId);
  }
}
