import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:werizit/core/providers/room/room_provider.dart';
import 'package:werizit/data/models/room.dart';

final roomByIdProvider = Provider.family<AsyncValue<Room>, int>((ref, id) {
  final roomsAsync = ref.watch(roomProvider);

  return roomsAsync.whenData((rooms) {
    final room = rooms[id];
    if (room == null) {
      throw Exception("Room not found");
    }
    return room;
  });
});

final roomsByHouseProvider = Provider.family<List<Room>, int>((ref, houseId) {
  final rooms = ref.watch(roomProvider).valueOrNull ?? {};

  return rooms.values.where((r) => r.house == houseId).toList();
});
