import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rangement/data/db/dao.dart';
import 'package:rangement/data/db/mock_dao.dart';
import 'package:rangement/data/models/furniture.dart';
import 'package:rangement/data/models/shelf.dart';
import 'package:rangement/presentation/screens/shelf_screen.dart';
import 'package:rangement/presentation/widgets/cards/storage_card.dart';

class FurnitureScreen extends StatefulWidget {
  final Furniture furniture;
  const FurnitureScreen({super.key, required this.furniture});

  @override
  State<FurnitureScreen> createState() => _FurnitureScreenState();
}

class _FurnitureScreenState extends State<FurnitureScreen> {
  final dao = kIsWeb ? MockDAO() : DAO();
  List<Shelf> shelves = [];

  @override
  void initState() {
    super.initState();
    _loadShelves();
  }

  Future<void> _loadShelves() async {
    final data = await dao.getShelvesByFurniture(widget.furniture.id);
    setState(() => shelves = data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.furniture.name)),
      body: ListView.builder(
        itemCount: shelves.length,
        itemBuilder: (context, index) {
          final shelf = shelves[index];
          return StorageCard(
            storage: shelf,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ShelfScreen(shelf: shelf)),
            ),
          );
        },
      ),
    );
  }
}
