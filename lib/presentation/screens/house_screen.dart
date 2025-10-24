import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rangement/core/providers/houses_provider.dart';
import 'package:rangement/core/providers/rooms_provider.dart';
import 'package:rangement/data/models/house.dart';
import 'package:rangement/data/models/room.dart';
import 'package:rangement/presentation/screens/storage_screen.dart';

import 'room_screen.dart';

class HouseScreen extends ConsumerWidget {
  final int houseId;

  const HouseScreen({super.key, required this.houseId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roomsNotifier = ref.read(roomsProvider.notifier);
    final houseNotifier = ref.read(housesProvider.notifier);

    final house = ref
        .watch(housesProvider)
        .values
        .firstWhere((h) => h.id == houseId, orElse: () => House(name: ''));

    final rooms = ref
        .watch(roomsProvider)
        .values
        .where((room) => room.house == house.id)
        .toList();

    if (rooms.isEmpty) {
      roomsNotifier.load();
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
          MaterialPageRoute(builder: (_) => RoomScreen(roomId: room.id!)),
        );
      },
    );
  }
}
