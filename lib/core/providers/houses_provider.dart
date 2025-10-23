import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rangement/core/providers/dao_provider.dart';
import 'package:rangement/data/models/house.dart';

import 'storages_provider.dart';

final housesProvider = StateNotifierProvider<HousesNotifier, Map<int, House>>(
  (ref) => HousesNotifier(dao: ref.read(daoProvider)),
);

class HousesNotifier extends StorageNotifier<House> {
  HousesNotifier({required super.dao});

  @override
  Future<List<House>> loadFromDb() => dao.getHouses();

  @override
  Future<int> insertToDb(House item) => dao.insertHouse(item);

  @override
  Future<void> renameInDb(int id, String newName) =>
      dao.renameHouse(id, newName);

  @override
  Future<void> deleteFromDb(int id) => dao.deleteHouse(id);
}
