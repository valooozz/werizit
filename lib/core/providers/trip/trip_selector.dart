import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:werizit/core/providers/trip/trip_provider.dart';
import 'package:werizit/data/models/thing/trip.dart';

final tripsListProvider = Provider<List<Trip>>((ref) {
  final asyncTrips = ref.watch(tripProvider);

  return asyncTrips.maybeWhen(
    data: (tripsMap) => tripsMap.values.toList(),
    orElse: () => [],
  );
});

final tripByIdProvider = Provider.family<Trip?, int>((ref, id) {
  final trips = ref.watch(tripProvider);
  return trips.maybeWhen(data: (map) => map[id], orElse: () => null);
});

final selectedTripsProvider = Provider<List<Trip>>((ref) {
  final trips = ref.watch(tripsListProvider);
  return trips.where((t) => t.selected).toList();
});

final selectedTripIdsProvider = Provider<List<int>>((ref) {
  final selected = ref.watch(selectedTripsProvider);
  return selected.map((t) => t.id).toList();
});

final tripsByItemIdProvider = Provider.family<List<Trip>, int>((ref, itemId) {
  final trips = ref.watch(tripsListProvider);
  return trips.where((trip) => trip.itemIds.contains(itemId)).toList();
});
