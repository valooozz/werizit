import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rangement/core/providers/furnitures_provider.dart';
import 'package:rangement/core/providers/rooms_provider.dart';
import 'package:rangement/data/db/dao.dart';
import 'package:rangement/data/db/mock_dao.dart';
import 'package:rangement/data/models/furniture.dart';
import 'package:rangement/data/models/room.dart';
import 'package:rangement/presentation/screens/storage_screen.dart';

import 'furniture_screen.dart';

class RoomScreen extends ConsumerWidget {
  final Room room;
  final dao = kIsWeb ? MockDAO() : DAO();

  RoomScreen({super.key, required this.room});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StorageScreen<Furniture>(
      title: room.name,
      provider: furnituresProvider(room.id!),
      onAdd: (name) async => await ref
          .read(furnituresProvider(room.id!).notifier)
          .add(Furniture(name: name, room: room.id!)),
      onDelete: () async => await ref
          .read(roomsProvider(room.id!).notifier)
          .delete(room.id!, room.house),
      onRename: (newName) async => await ref
          .read(roomsProvider(room.id!).notifier)
          .rename(room.id!, newName, room.house),
      onTap: (furniture) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FurnitureScreen(furniture: furniture),
          ),
        );
      },
    );
  }
}
