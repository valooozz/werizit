import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rangement/core/providers/furnitures_provider.dart';
import 'package:rangement/data/db/dao.dart';
import 'package:rangement/data/db/mock_dao.dart';
import 'package:rangement/data/models/furniture.dart';
import 'package:rangement/data/models/room.dart';
import 'package:rangement/presentation/screens/storage_screen.dart';

import 'furniture_screen.dart';

class RoomScreen extends StatelessWidget {
  final Room room;
  final dao = kIsWeb ? MockDAO() : DAO();

  RoomScreen({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    return StorageScreen<Furniture>(
      title: room.name,
      provider: StateNotifierProvider<FurnituresNotifier, List<Furniture>>(
        (ref) => FurnituresNotifier(ref)..loadAll(room.id),
      ),
      onAdd: (name) =>
          dao.insertFurniture(Furniture(name: name, room: room.id!)),
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
