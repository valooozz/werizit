import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:werizit/core/providers/storage_provider.dart';
import 'package:werizit/data/models/house/house.dart';
import 'package:werizit/data/models/house/house_draft.dart';

final houseProvider = AsyncNotifierProvider<HouseNotifier, Map<int, House>>(
  HouseNotifier.new,
);

class HouseNotifier extends StorageNotifier<House, HouseDraft> {
  @override
  Future<List<House>> loadFromDb() => dao.getHouses();

  @override
  Future<int> insertToDb(HouseDraft item) => dao.insertHouse(item);

  @override
  Future<void> renameInDb(int id, String newName) =>
      dao.renameHouse(id, newName);

  @override
  Future<void> deleteFromDb(int id) => dao.deleteHouse(id);

  @override
  House fromDraft(HouseDraft draft, int id) => House(id: id, name: draft.name);
}
