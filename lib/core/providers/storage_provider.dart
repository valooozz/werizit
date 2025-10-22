import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rangement/data/db/base_dao.dart';
import 'package:rangement/data/db/dao.dart';
import 'package:rangement/data/db/mock_dao.dart';
import 'package:rangement/data/models/storage.dart';

abstract class BaseStorageNotifier<T extends Storage>
    extends StateNotifier<List<T>> {
  final Ref ref;
  final BaseDAO dao = kIsWeb ? MockDAO() : DAO();

  BaseStorageNotifier(this.ref) : super([]);

  Future<void> loadAll(int? parentId);

  Future<void> add(T storage);

  Future<void> rename(int storageId, String newName, int? parentId);

  Future<void> delete(int storageId, int? parentId);
}
