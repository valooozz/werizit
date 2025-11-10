import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rangement/core/providers/dao_provider.dart';
import 'package:rangement/data/dao/base_dao.dart';
import 'package:rangement/data/models/item.dart';

final itemsProvider = StateNotifierProvider<ItemsNotifier, List<Item>>(
  (ref) => ItemsNotifier(dao: ref.read(daoProvider)),
);

class ItemsNotifier extends StateNotifier<List<Item>> {
  final BaseDAO dao;

  ItemsNotifier({required this.dao}) : super([]);

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

  Future<void> deleteItems(List<int> itemIds) async {
    for (final itemId in itemIds) {
      await dao.deleteItem(itemId);
    }
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

  Future<void> linkItemWithTrips(int itemId, List<int> tripIds) async {
    await dao.unlinkItem(itemId);
    await dao.linkItemToTrips(itemId, tripIds);
    await loadItems();
  }
}
