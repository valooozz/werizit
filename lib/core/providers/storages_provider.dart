import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rangement/data/db/base_dao.dart';
import 'package:rangement/data/models/storage.dart';

abstract class StorageNotifier<T extends Storage>
    extends StateNotifier<Map<int, T>> {
  final BaseDAO dao;

  StorageNotifier({required this.dao}) : super({});

  /// Charge tous les items ou, si parentId est fourni, ceux du parent
  Future<void> load() async {
    final storages = await loadFromDb();
    state = {for (var storage in storages) storage.id!: storage};
  }

  /// Doit être implémentée par chaque type pour charger depuis la DB
  Future<List<T>> loadFromDb();

  Future<void> add(T item) async {
    final newId = await insertToDb(item);
    final newItem = item.copyWith(id: newId) as T;
    state = {...state, newId: newItem};
  }

  Future<void> rename(int id, String newName) async {
    final item = state[id];
    if (item != null) {
      await renameInDb(id, newName);
      state = {...state, id: item.copyWith(name: newName) as T};
    }
  }

  Future<void> remove(int id) async {
    await deleteFromDb(id);
    final newState = {...state}..remove(id);
    state = newState;
  }

  Future<int> insertToDb(T item);
  Future<void> renameInDb(int id, String newName);
  Future<void> deleteFromDb(int id);
}
