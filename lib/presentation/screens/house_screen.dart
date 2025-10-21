import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rangement/data/db/dao.dart';
import 'package:rangement/data/db/mock_dao.dart';
import 'package:rangement/data/models/house.dart';
import 'package:rangement/data/models/room.dart';
import 'package:rangement/presentation/screens/storage_screen.dart';

import 'room_screen.dart';

class HouseScreen extends StatelessWidget {
  final House house;
  final dao = kIsWeb ? MockDAO() : DAO();

  HouseScreen({super.key, required this.house});

  @override
  Widget build(BuildContext context) {
    return StorageScreen<Room>(
      title: house.name,
      fetchItems: () => dao.getRoomsByHouse(house.id!),
      onAdd: (name) => dao.insertRoom(Room(name: name, house: house.id!)),
      onTap: (room) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => RoomScreen(room: room)),
        );
      },
    );
  }
}
