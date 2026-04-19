import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:werizit/core/providers/furniture/furniture_provider.dart';
import 'package:werizit/data/models/furniture.dart';

final furnitureByIdProvider = Provider.family<AsyncValue<Furniture>, int>((
  ref,
  id,
) {
  final furnituresAsync = ref.watch(furnitureProvider);

  return furnituresAsync.whenData((furnitures) {
    final furniture = furnitures[id];
    if (furniture == null) {
      throw Exception("Furniture not found");
    }
    return furniture;
  });
});

final furnituresByRoomProvider = Provider.family<List<Furniture>, int>((
  ref,
  roomId,
) {
  final furnitures = ref.watch(furnitureProvider).valueOrNull ?? {};

  return furnitures.values.where((r) => r.room == roomId).toList();
});
