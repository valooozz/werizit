import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rangement/core/providers/furnitures_provider.dart';
import 'package:rangement/core/providers/rooms_provider.dart';
import 'package:rangement/data/models/furniture.dart';
import 'package:rangement/presentation/screens/storage_screen.dart';

import 'furniture_screen.dart';

class RoomScreen extends ConsumerWidget {
  final int roomId;

  const RoomScreen({super.key, required this.roomId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final furnituresNotifier = ref.read(furnituresProvider.notifier);
    final roomsNotifier = ref.read(roomsProvider.notifier);

    final room = ref
        .watch(roomsProvider)
        .values
        .where((r) => r.id == roomId)
        .first;

    final furnitures = ref
        .watch(furnituresProvider)
        .values
        .where((furniture) => furniture.room == room.id)
        .toList();

    if (furnitures.isEmpty) {
      furnituresNotifier.load();
    }

    return StorageScreen<Furniture>(
      parentStorage: room,
      storages: furnitures,
      onAdd: (name) async =>
          await furnituresNotifier.add(Furniture(name: name, room: room.id!)),
      onRename: (newName) async =>
          await roomsNotifier.rename(room.id!, newName),
      onDelete: () async => await roomsNotifier.remove(room.id!),
      onTap: (furniture) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FurnitureScreen(furnitureId: furniture.id!),
          ),
        );
      },
    );
  }
}
