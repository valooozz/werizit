import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rangement/core/states/items_state.dart';
import 'package:rangement/data/db/dao.dart';
import 'package:rangement/data/db/mock_dao.dart';
import 'package:rangement/data/models/item.dart';

final itemsProvider = StateNotifierProvider<ItemsNotifier, ItemsState>((ref) {
  return ItemsNotifier(ref);
});

class ItemsNotifier extends StateNotifier<ItemsState> {
  final Ref ref;
  final dao = kIsWeb ? MockDAO() : DAO();

  ItemsNotifier(this.ref) : super(ItemsState(shelfItems: [], boxItems: []));

  Future<void> loadItems(int shelfId) async {
    final fetched = await dao.getItemsByShelf(shelfId);
    final boxItems = await dao.getItemsFromBox();
    state = state.copyWith(shelfItems: fetched, boxItems: boxItems);
  }

  Future<void> addItem(Item item) async {
    await dao.insertItem(item);
    await loadItems(item.shelf ?? 0);
  }

  Future<void> renameItem(int itemId, String newName, int shelfId) async {
    await dao.renameItem(itemId, newName);
    await loadItems(shelfId);
  }

  Future<void> deleteItem(int itemId, int shelfId) async {
    await dao.deleteItem(itemId);
    await loadItems(shelfId);
  }

  Future<void> putItemsIntoBox(List<int> itemIds, int shelfId) async {
    await dao.putItemsIntoBox(itemIds);
    await loadItems(shelfId);
  }

  Future<void> dropItemsFromBox(List<int> itemIds, int shelfId) async {
    await dao.dropItemsFromBox(itemIds, shelfId);
    await loadItems(shelfId);
  }

  List<Item> get itemsInBox => state.boxItems;
  List<Item> get itemsOnShelf => state.shelfItems;
}
