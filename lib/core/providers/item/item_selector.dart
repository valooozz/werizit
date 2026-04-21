import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:werizit/core/providers/dao_provider.dart';
import 'package:werizit/core/providers/item/item_provider.dart';
import 'package:werizit/data/models/thing/item.dart';
import 'package:werizit/data/models/thing/item_info.dart';

final itemByIdProvider = Provider.family<AsyncValue<Item>, int>((ref, id) {
  final itemsAsync = ref.watch(itemProvider);

  return itemsAsync.whenData((items) {
    final item = items[id];
    if (item == null) {
      throw Exception("Item not found");
    }
    return item;
  });
});

final itemsByIdProvider = Provider.family<AsyncValue<List<Item>>, List<int>>((
  ref,
  ids,
) {
  final itemsAsync = ref.watch(itemProvider);

  return itemsAsync.whenData((allItems) {
    return allItems.values.where((item) => ids.contains(item.id)).toList();
  });
});

final itemInfoByIdProvider = FutureProvider.family<ItemInfo, int>((
  ref,
  id,
) async {
  final items = await ref.watch(itemProvider.future);

  final item = items[id];
  if (item == null) {
    throw Exception("Item not found");
  }

  if (item.shelf == -1) {
    return ItemInfo(
      id: id,
      name: item.name,
      house: '',
      room: '',
      furniture: '',
      shelf: 'box',
    );
  }

  if (item.shelf == -2) {
    return ItemInfo(
      id: id,
      name: item.name,
      house: '',
      room: '',
      furniture: '',
      shelf: 'wardrobe',
    );
  }

  return ref.read(daoProvider).getItemInfo(id);
});

final itemsByShelfProvider = Provider.family<AsyncValue<List<Item>>, int>((
  ref,
  shelfId,
) {
  final itemsAsync = ref.watch(itemProvider);

  return itemsAsync.whenData(
    (items) => items.values.where((item) => item.shelf == shelfId).toList(),
  );
});

final itemsInBoxProvider = Provider<AsyncValue<List<Item>>>((ref) {
  final itemsAsync = ref.watch(itemProvider);

  return itemsAsync.whenData(
    (items) => items.values.where((item) => item.shelf == -1).toList(),
  );
});
