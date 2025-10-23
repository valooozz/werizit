import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rangement/data/db/dao.dart';
import 'package:rangement/data/db/mock_dao.dart';
import 'package:rangement/data/models/item.dart';

final itemsProvider = StateNotifierProvider<ItemsNotifier, List<Item>>((ref) {
  return ItemsNotifier();
});

class ItemsNotifier extends StateNotifier<List<Item>> {
  final dao = kIsWeb ? MockDAO() : DAO();

  ItemsNotifier() : super([]);

  Future<void> loadItems() async {
    state = await dao.getItems();
  }

  Future<void> addItem(Item item) async {
    await dao.insertItem(item);
    await loadItems();
  }

  Future<void> renameItem(int itemId, String newName) async {
    await dao.renameItem(itemId, newName);
    await loadItems();
  }

  Future<void> deleteItem(int itemId) async {
    await dao.deleteItem(itemId);
    await loadItems();
  }

  Future<void> putItemsIntoBox(List<int> itemIds) async {
    await dao.putItemsIntoBox(itemIds);
    await loadItems();
  }

  Future<void> dropItemsFromBox(List<int> itemIds, int shelfId) async {
    await dao.dropItemsFromBox(itemIds, shelfId);
    await loadItems();
  }
}
