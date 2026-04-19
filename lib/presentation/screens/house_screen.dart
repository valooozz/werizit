import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:werizit/core/providers/house/house_provider.dart';
import 'package:werizit/core/providers/house/house_selector.dart';
import 'package:werizit/core/providers/room/room_provider.dart';
import 'package:werizit/core/providers/room/room_selector.dart';
import 'package:werizit/data/models/room.dart';
import 'package:werizit/presentation/screens/storage_screen.dart';

import 'room_screen.dart';

class HouseScreen extends ConsumerWidget {
  final int houseId;

  const HouseScreen({super.key, required this.houseId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final houseAsync = ref.watch(houseByIdProvider(houseId));

    return houseAsync.when(
      data: (house) {
        final rooms = ref.watch(roomsByHouseProvider(house.id!));

        return StorageScreen<Room>(
          parentStorage: house,
          storages: rooms,
          onAdd: (name) => ref
              .read(roomProvider.notifier)
              .add(Room(name: name, house: house.id!)),
          onRename: (newName) =>
              ref.read(houseProvider.notifier).rename(house.id!, newName),
          onDelete: () => ref.read(houseProvider.notifier).remove(house.id!),
          onTap: (room) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => RoomScreen(roomId: room.id!)),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Text("Erreur de chargement"),
    );
  }
}
