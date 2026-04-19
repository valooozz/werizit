import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:werizit/data/models/shelf.dart';

import '../storages_provider.dart';

final shelfProvider = AsyncNotifierProvider<ShelfNotifier, Map<int, Shelf>>(
  ShelfNotifier.new,
);

class ShelfNotifier extends StorageNotifier<Shelf> {
  @override
  Future<List<Shelf>> loadFromDb() => dao.getShelves();

  @override
  Future<int> insertToDb(Shelf item) => dao.insertShelf(item);

  @override
  Future<void> renameInDb(int id, String newName) =>
      dao.renameShelf(id, newName);

  @override
  Future<void> deleteFromDb(int id) => dao.deleteShelf(id);
}
