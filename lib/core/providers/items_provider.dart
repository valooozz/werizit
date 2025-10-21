import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rangement/data/db/dao.dart';
import 'package:rangement/data/db/mock_dao.dart';
import 'package:rangement/data/models/item.dart';

final itemsProvider = StateNotifierProvider<ItemsNotifier, List<Item>>((ref) {
  return ItemsNotifier(ref);
});

class ItemsNotifier extends StateNotifier<List<Item>> {
  final Ref ref;
  final dao = kIsWeb ? MockDAO() : DAO();

  ItemsNotifier(this.ref) : super([]);

  Future<void> loadItems(int shelfId) async {
    final fetched = await dao.getItemsByShelf(shelfId);
    state = [...fetched];
  }

  Future<void> addItem(Item item) async {
    await dao.insertItem(item);
    await loadItems(item.shelf);
  }

  Future<void> deleteItem(int itemId, int shelfId) async {
    await dao.deleteItem(itemId);
    await loadItems(shelfId);
  }
}
