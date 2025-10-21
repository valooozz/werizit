import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rangement/data/db/dao.dart';
import 'package:rangement/data/db/mock_dao.dart';
import 'package:rangement/data/models/item.dart';
import 'package:rangement/data/models/shelf.dart';
import 'package:rangement/presentation/screens/base_screen.dart';
import 'package:rangement/presentation/screens/search_screen.dart';
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
    _refresh();
  }

  Future<void> _refresh() async {
    final data = await dao.getItemsByShelf(widget.shelf.id!);
    setState(() => items = data);
  }

  void _addItem() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Ajouter dans '${widget.shelf.name}'"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "Nom"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annuler"),
          ),
          TextButton(
            onPressed: () async {
              if (controller.text.isEmpty) return;
              await dao.insertItem(
                Item(name: controller.text, shelf: widget.shelf.id!),
              );
              if (!mounted) return;
              Navigator.pop(context);
              _refresh();
            },
            child: const Text("Ajouter"),
          ),
        ],
      ),
    );
  }

  void _search() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => SearchScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: widget.shelf.name,
      onAdd: _addItem,
      onSearch: _search,
      body: items.isEmpty
          ? Center(child: Text("Aucun objet à cet étage"))
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ItemsDisplay(items: items),
            ),
    );
  }
}
