import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:werizit/core/providers/dao_provider.dart';
import 'package:werizit/data/dao/base_dao.dart';
import 'package:werizit/data/models/trip.dart';

final tripProvider = AsyncNotifierProvider<TripNotifier, Map<int, Trip>>(
  TripNotifier.new,
);

class TripNotifier extends AsyncNotifier<Map<int, Trip>> {
  late final BaseDAO dao;

  @override
  Future<Map<int, Trip>> build() async {
    dao = ref.read(daoProvider);
    final trips = await dao.getTrips();
    return {for (final trip in trips) trip.id!: trip};
  }

  Future<void> add(Trip trip) async {
    final current = state.requireValue;

    final newId = await dao.insertTrip(trip);
    final newTrip = trip.copyWith(id: newId);

    state = AsyncData({...current, newId: newTrip});
  }

  Future<void> rename(int id, String newName) async {
    final current = state.requireValue;
    final trip = current[id];
    if (trip == null) return;

    await dao.renameTrip(id, newName);

    state = AsyncData({...current, id: trip.copyWith(name: newName)});
  }

  Future<void> remove(int id) async {
    final current = state.requireValue;

    await dao.deleteTrip(id);

    final updated = {...current}..remove(id);
    state = AsyncData(updated);
  }

  Future<void> updateTripLinks(
    int tripId,
    List<int> itemIdsToAdd,
    List<int> itemIdsToRemove,
  ) async {
    final current = state.requireValue;
    final trip = current[tripId];
    if (trip == null) return;

    await dao.linkTripsToItems([tripId], itemIdsToAdd);
    await dao.unlinkTripsFromItems([tripId], itemIdsToRemove);

    final updatedItemIds = [...?trip.itemIds];
    updatedItemIds.addAll(itemIdsToAdd);
    updatedItemIds.removeWhere((id) => itemIdsToRemove.contains(id));

    state = AsyncData({
      ...current,
      tripId: trip.copyWith(itemIds: updatedItemIds),
    });
  }

  Future<void> updateItemLinks(
    int itemId,
    List<int> tripsToAdd,
    List<int> tripsToRemove,
  ) async {
    final current = state.requireValue;

    await dao.linkTripsToItems(tripsToAdd, [itemId]);
    await dao.unlinkTripsFromItems(tripsToRemove, [itemId]);

    final updated = {...current};

    for (final tripId in tripsToAdd) {
      final trip = updated[tripId];
      if (trip == null) continue;

      final newItemIds = [...?trip.itemIds];
      newItemIds.add(itemId);

      updated[tripId] = trip.copyWith(itemIds: newItemIds);
    }

    for (final tripId in tripsToRemove) {
      final trip = updated[tripId];
      if (trip == null) continue;

      final newItemIds = [...?trip.itemIds];
      newItemIds.remove(itemId);

      updated[tripId] = trip.copyWith(itemIds: newItemIds);
    }

    state = AsyncData(updated);
  }

  Future<void> updateSelectedTrips(List<int> tripIdsToSelect) async {
    final current = state.requireValue;

    await dao.updateSelectedTrips(tripIdsToSelect);

    final updated = {
      for (final entry in current.entries)
        entry.key: entry.value.copyWith(
          selected: tripIdsToSelect.contains(entry.value.id),
        ),
    };
    state = AsyncData(updated);
  }
}
