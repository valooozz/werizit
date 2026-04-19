import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:werizit/core/providers/room/room_provider.dart';
import 'package:werizit/data/models/room.dart';

final roomByIdProvider = Provider.family<Room?, int>((ref, id) {
  final rooms = ref.watch(roomProvider).valueOrNull;
  return rooms?[id];
});

final roomsByHouseProvider = Provider.family<List<Room>, int>((ref, houseId) {
  final rooms = ref.watch(roomProvider).valueOrNull ?? {};

  return rooms.values.where((r) => r.house == houseId).toList();
});
