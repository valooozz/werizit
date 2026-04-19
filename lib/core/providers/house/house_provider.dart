import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:werizit/core/providers/storages_provider.dart';
import 'package:werizit/data/models/house.dart';

final houseProvider = AsyncNotifierProvider<HouseNotifier, Map<int, House>>(
  HouseNotifier.new,
);

class HouseNotifier extends StorageNotifier<House> {
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
