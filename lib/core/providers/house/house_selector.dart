import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:werizit/core/providers/house/house_provider.dart';
import 'package:werizit/data/models/house/house.dart';

final houseByIdProvider = Provider.family<AsyncValue<House>, int>((ref, id) {
  final housesAsync = ref.watch(houseProvider);

  return housesAsync.whenData((houses) {
    final house = houses[id];
    if (house == null) {
      throw Exception("House not found");
    }
    return house;
  });
});

final housesListProvider = Provider<List<House>>((ref) {
  return ref.watch(houseProvider).valueOrNull?.values.toList() ?? [];
});
