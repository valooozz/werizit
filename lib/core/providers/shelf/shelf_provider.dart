import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:werizit/data/models/shelf/shelf.dart';
import 'package:werizit/data/models/shelf/shelf_draft.dart';

import '../storage_provider.dart';

final shelfProvider = AsyncNotifierProvider<ShelfNotifier, Map<int, Shelf>>(
  ShelfNotifier.new,
);

class ShelfNotifier extends StorageNotifier<Shelf, ShelfDraft> {
  @override
  Future<List<Shelf>> loadFromDb() => dao.getShelves();

  @override
  Future<int> insertToDb(ShelfDraft item) => dao.insertShelf(item);

  @override
  Future<void> renameInDb(int id, String newName) =>
      dao.renameShelf(id, newName);

  @override
  Future<void> deleteFromDb(int id) => dao.deleteShelf(id);

  @override
  Shelf fromDraft(ShelfDraft draft, int id) =>
      Shelf(id: id, name: draft.name, furniture: draft.furniture);
}
