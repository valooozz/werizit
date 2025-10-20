import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rangement/data/db/dao.dart';
import 'package:rangement/data/db/mock_dao.dart';
import 'package:rangement/data/models/item.dart';
import 'package:rangement/data/models/shelf.dart';
import 'package:rangement/presentation/widgets/display/items_display.dart';

class ShelfScreen extends StatefulWidget {
  final Shelf shelf;
  const ShelfScreen({super.key, required this.shelf});

  @override
  State<ShelfScreen> createState() => _ShelfScreenState();
}

class _ShelfScreenState extends State<ShelfScreen> {
  final dao = kIsWeb ? MockDAO() : DAO();
  List<Item> items = [];

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    final data = await dao.getItemsByShelf(widget.shelf.id);
    setState(() => items = data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.shelf.name)),
      body: ItemsDisplay(items: items),
    );
  }
}
