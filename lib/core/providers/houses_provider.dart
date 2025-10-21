import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rangement/core/providers/storage_provider.dart';
import 'package:rangement/data/db/dao.dart';
import 'package:rangement/data/db/mock_dao.dart';
import 'package:rangement/data/models/house.dart';

final dao = kIsWeb ? MockDAO() : DAO();

final housesProvider = StateNotifierProvider<HousesNotifier, List<House>>(
  (ref) => HousesNotifier(ref),
);

class HousesNotifier extends BaseStorageNotifier<House> {
  HousesNotifier(Ref ref) : super(ref) {
    loadAll(0);
  }

  @override
  Future<void> loadAll(int? _) async {
    final list = await dao.getHouses();
    state = [...list];
  }

  @override
  Future<void> add(House house) async {
    await dao.insertHouse(house);
    await loadAll(0);
  }

  @override
  Future<void> delete(int houseId, int? _) async {
    await dao.deleteHouse(houseId);
    await loadAll(0);
  }
}
