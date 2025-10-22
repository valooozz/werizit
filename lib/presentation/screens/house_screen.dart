import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rangement/core/providers/house_provider.dart';
import 'package:rangement/core/providers/room_provider.dart';
import 'package:rangement/data/models/house.dart';
import 'package:rangement/data/models/room.dart';
import 'package:rangement/presentation/screens/storage_screen.dart';

import 'room_screen.dart';

class HouseScreen extends ConsumerWidget {
  final House house;

  const HouseScreen({super.key, required this.house});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roomsNotifier = ref.read(roomsProvider.notifier);
    final houseNotifier = ref.read(housesProvider.notifier);

    final rooms = ref
        .watch(roomsProvider)
        .values
        .where((room) => room.house == house.id)
        .toList();

    if (rooms.isEmpty) {
      roomsNotifier.load(house.id);
    }

    return StorageScreen<Room>(
      parentStorage: house,
      storages: rooms,
      onAdd: (name) async =>
          await roomsNotifier.add(Room(name: name, house: house.id!)),
      onRename: (newName) async =>
          await houseNotifier.rename(house.id!, newName),
      onDelete: () async => await houseNotifier.remove(house.id!),
      onTap: (room) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => RoomScreen(room: room)),
        );
      },
    );
  }
}
