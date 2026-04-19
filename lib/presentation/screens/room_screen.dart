import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:werizit/core/providers/furniture/furniture_provider.dart';
import 'package:werizit/core/providers/furniture/furniture_selector.dart';
import 'package:werizit/core/providers/room/room_provider.dart';
import 'package:werizit/core/providers/room/room_selector.dart';
import 'package:werizit/data/models/furniture.dart';
import 'package:werizit/presentation/screens/storage_screen.dart';

import 'furniture_screen.dart';

class RoomScreen extends ConsumerWidget {
  final int roomId;

  const RoomScreen({super.key, required this.roomId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roomAsync = ref.watch(roomByIdProvider(roomId));

    return roomAsync.when(
      data: (room) {
        final furnitures = ref.watch(furnituresByRoomProvider(room.id!));

        return StorageScreen<Furniture>(
          parentStorage: room,
          storages: furnitures,
          onAdd: (name) => ref
              .read(furnitureProvider.notifier)
              .add(Furniture(name: name, room: room.id!)),
          onRename: (newName) =>
              ref.read(roomProvider.notifier).rename(room.id!, newName),
          onDelete: () => ref.read(roomProvider.notifier).remove(room.id!),
          onTap: (furniture) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => FurnitureScreen(furnitureId: furniture.id!),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Text("Erreur de chargement"),
    );
  }
}
