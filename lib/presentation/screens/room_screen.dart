import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
      title: "Meubles de ${room.name}",
      fetchItems: () => dao.getFurnitureByRoom(room.id),
      onAdd: (name) =>
          dao.insertFurniture(Furniture(id: 0, name: name, room: room.id)),
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
