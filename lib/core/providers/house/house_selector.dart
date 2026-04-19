import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:werizit/core/providers/house/house_provider.dart';
import 'package:werizit/data/models/house.dart';

final houseByIdProvider = Provider.family<House?, int>((ref, id) {
  final houses = ref.watch(houseProvider).valueOrNull;
  return houses?[id];
});

final housesListProvider = Provider<List<House>>((ref) {
  return ref.watch(houseProvider).valueOrNull?.values.toList() ?? [];
});
