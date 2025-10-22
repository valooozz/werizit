import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rangement/core/providers/houses_provider.dart';
import 'package:rangement/core/providers/rooms_provider.dart';
import 'package:rangement/data/db/dao.dart';
import 'package:rangement/data/db/mock_dao.dart';
import 'package:rangement/data/models/house.dart';
import 'package:rangement/data/models/room.dart';
import 'package:rangement/presentation/screens/storage_screen.dart';

import 'room_screen.dart';

class HouseScreen extends ConsumerWidget {
  final House house;
  final dao = kIsWeb ? MockDAO() : DAO();

  HouseScreen({super.key, required this.house});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StorageScreen<Room>(
      title: house.name,
      provider: roomsProvider(house.id!),
      onAdd: (name) async => await ref
          .read(roomsProvider(house.id!).notifier)
          .add(Room(name: name, house: house.id!)),
      onDelete: () async =>
          await ref.read(housesProvider.notifier).delete(house.id!, 0),
      onTap: (room) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => RoomScreen(room: room)),
        );
      },
    );
  }
}
