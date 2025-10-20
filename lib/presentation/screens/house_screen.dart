import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rangement/data/db/dao.dart';
import 'package:rangement/data/db/mock_dao.dart';
import 'package:rangement/data/models/house.dart';
import 'package:rangement/data/models/room.dart';
import 'package:rangement/presentation/screens/room_screen.dart';
import 'package:rangement/presentation/widgets/cards/storage_card.dart';

class HouseScreen extends StatefulWidget {
  final House house;

  const HouseScreen({super.key, required this.house});

  @override
  State<HouseScreen> createState() => _HouseScreenState();
}

class _HouseScreenState extends State<HouseScreen> {
  final dao = kIsWeb ? MockDAO() : DAO();
  List<Room> rooms = [];

  @override
  void initState() {
    super.initState();
    _loadRooms();
  }

  Future<void> _loadRooms() async {
    final data = await dao.getRoomsByHouse(widget.house.id);
    setState(() => rooms = data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.house.name)),
      body: ListView.builder(
        itemCount: rooms.length,
        itemBuilder: (context, index) {
          final room = rooms[index];
          return StorageCard(
            storage: room,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => RoomScreen(room: room)),
            ),
          );
        },
      ),
    );
  }
}
