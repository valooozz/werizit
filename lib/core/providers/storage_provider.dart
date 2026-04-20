import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:werizit/core/providers/dao_provider.dart';
import 'package:werizit/data/dao/base_dao.dart';
import 'package:werizit/data/models/storage.dart';

abstract class StorageNotifier<T extends Storage>
    extends AsyncNotifier<Map<int, T>> {
  late final BaseDAO dao;

  @override
  Future<Map<int, T>> build() async {
    dao = ref.read(daoProvider);
    final items = await loadFromDb();
    return {for (final item in items) item.id!: item};
  }

  Future<List<T>> loadFromDb();
  Future<int> insertToDb(T item);
  Future<void> renameInDb(int id, String newName);
  Future<void> deleteFromDb(int id);

  Future<void> add(T item) async {
    final current = state.value ?? {};

    final newId = await insertToDb(item);
    final newItem = item.copyWith(id: newId) as T;

    state = AsyncData({...current, newId: newItem});
  }

  Future<void> rename(int id, String newName) async {
    final current = state.value ?? {};
    final item = current[id];
    if (item == null) return;

    await renameInDb(id, newName);

    state = AsyncData({...current, id: item.copyWith(name: newName) as T});
  }

  Future<void> remove(int id) async {
    final current = state.value ?? {};

    await deleteFromDb(id);

    final updated = {...current}..remove(id);
    state = AsyncData(updated);
  }
}
