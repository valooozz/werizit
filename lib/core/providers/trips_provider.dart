import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rangement/core/providers/dao_provider.dart';
import 'package:rangement/data/dao/base_dao.dart';
import 'package:rangement/data/models/trip.dart';

final tripsProvider = StateNotifierProvider<TripsNotifier, List<Trip>>(
  (ref) => TripsNotifier(dao: ref.read(daoProvider)),
);

class TripsNotifier extends StateNotifier<List<Trip>> {
  final BaseDAO dao;
  TripsNotifier({required this.dao}) : super([]) {
    loadTrips();
  }

  Future<void> loadTrips() async {
    state = await dao.getTrips();
  }

  Future<void> addTrip(Trip item) async {
    await dao.insertTrip(item);
    await loadTrips();
  }

  Future<void> renameTrip(int id, String newName) async {
    await dao.renameTrip(id, newName);
    await loadTrips();
  }

  Future<void> deleteTrip(int id) async {
    await dao.deleteTrip(id);
    await loadTrips();
  }

  Future<List<int>> getTripsByItem(int itemId) async {
    return await dao.getTripsByItem(itemId);
  }
}
