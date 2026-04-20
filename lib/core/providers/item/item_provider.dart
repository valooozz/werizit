import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:werizit/core/providers/dao_provider.dart';
import 'package:werizit/data/dao/base_dao.dart';
import 'package:werizit/data/models/item.dart';

final itemProvider = AsyncNotifierProvider<ItemNotifier, Map<int, Item>>(
  ItemNotifier.new,
);

class ItemNotifier extends AsyncNotifier<Map<int, Item>> {
  late final BaseDAO dao;

  @override
  Future<Map<int, Item>> build() async {
    dao = ref.read(daoProvider);
    final items = await dao.getItems();
    return {for (final item in items) item.id!: item};
  }

  Future<void> add(Item item) async {
    final current = state.value ?? {};

    final newId = await dao.insertItem(item);
    final newItem = item.copyWith(id: newId);

    state = AsyncData({...current, newId: newItem});
  }

  Future<void> rename(int id, String newName) async {
    final current = state.value ?? {};
    final item = current[id];
    if (item == null) return;

    await dao.renameItem(id, newName);

    state = AsyncData({...current, id: item.copyWith(name: newName)});
  }

  Future<void> remove(int id) async {
    final current = state.value ?? {};

    await dao.deleteItem(id);

    final updated = {...current}..remove(id);
    state = AsyncData(updated);
  }

  Future<void> removeSeveral(List<int> ids) async {
    final current = state.value ?? {};

    for (final id in ids) {
      await dao.deleteItem(id);
    }

    final updated = {...current}
      ..removeWhere((itemId, _) => ids.contains(itemId));

    state = AsyncData(updated);
  }

  Future<void> putIntoBox(List<int> ids) async {
    final current = state.value ?? {};

    await dao.putItemsIntoBox(ids);

    final updated = {
      for (final entry in current.entries)
        entry.key: ids.contains(entry.key)
            ? entry.value.copyWith(shelf: -1)
            : entry.value,
    };

    state = AsyncData(updated);
  }

  Future<void> dropFromBox(List<int> ids, int shelfId) async {
    final current = state.value ?? {};

    await dao.dropItemsFromBox(ids, shelfId);

    final updated = {
      for (final entry in current.entries)
        entry.key: ids.contains(entry.key)
            ? entry.value.copyWith(shelf: shelfId)
            : entry.value,
    };

    state = AsyncData(updated);
  }

  Future<void> take(int id) async {
    final current = state.value ?? {};
    final item = current[id];
    if (item == null) return;

    await dao.takeItem(id);

    state = AsyncData({...current, id: item.copyWith(taken: true)});
  }

  Future<void> untake(int id) async {
    final current = state.value ?? {};
    final item = current[id];
    if (item == null) return;

    await dao.untakeItem(id);

    state = AsyncData({...current, id: item.copyWith(taken: false)});
  }

  Future<void> untakeAll() async {
    final current = state.value ?? {};

    await dao.untakeAllItems();

    final updated = {
      for (final entry in current.entries)
        entry.key: entry.value.copyWith(taken: false),
    };

    state = AsyncData(updated);
  }
}
