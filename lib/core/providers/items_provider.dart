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

  Future<void> loadItems({int? shelfId}) async {
    state = await dao.getItemsByShelf(shelfId!);
  }

  Future<void> addItem(Item item) async {
    await dao.insertItem(item);
    await loadItems(shelfId: item.shelf);
  }

  Future<void> renameItem(int itemId, String newName, {int? shelfId}) async {
    await dao.renameItem(itemId, newName);
    await loadItems(shelfId: shelfId);
  }

  Future<void> deleteItem(int itemId, {int? shelfId}) async {
    await dao.deleteItem(itemId);
    await loadItems(shelfId: shelfId);
  }

  Future<void> putItemsIntoBox(List<int> itemIds, {int? shelfId}) async {
    await dao.putItemsIntoBox(itemIds);
    await loadItems(shelfId: shelfId);
  }

  Future<void> dropItemsFromBox(List<int> itemIds, {int? shelfId}) async {
    await dao.dropItemsFromBox(itemIds, shelfId!);
    await loadItems(shelfId: shelfId);
  }
}
