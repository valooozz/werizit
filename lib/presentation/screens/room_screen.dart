import 'package:flutter/material.dart';
import 'package:rangement/data/db/dao.dart';
import 'package:rangement/data/models/furniture.dart';
import 'package:rangement/data/models/room.dart';
import 'package:rangement/presentation/screens/furniture_screen.dart';
import 'package:rangement/presentation/widgets/cards/storage_card.dart';

class RoomScreen extends StatefulWidget {
  final Room room;
  const RoomScreen({super.key, required this.room});

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  final dao = DAO();
  List<Furniture> furnitures = [];

  @override
  void initState() {
    super.initState();
    _loadFurniture();
  }

  Future<void> _loadFurniture() async {
    final data = await dao.getFurnitureByRoom(widget.room.id);
    setState(() => furnitures = data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.room.name)),
      body: ListView.builder(
        itemCount: furnitures.length,
        itemBuilder: (context, index) {
          final furniture = furnitures[index];
          return StorageCard(
            storage: furniture,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => FurnitureScreen(furniture: furniture),
              ),
            ),
          );
        },
      ),
    );
  }
}
