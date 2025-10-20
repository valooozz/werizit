import 'package:flutter/material.dart';
import 'package:rangement/data/models/storage.dart';
import 'package:rangement/presentation/widgets/cards/storage_card.dart';

class StorageScreen<T extends Storage> extends StatefulWidget {
  final String title;
  final Future<List<T>> Function() fetchItems;
  final Future<void> Function(String name) onAdd;
  final void Function(T item)? onTap;

  const StorageScreen({
    super.key,
    required this.title,
    required this.fetchItems,
    required this.onAdd,
    this.onTap,
  });

  @override
  State<StorageScreen<T>> createState() => _StorageScreenState<T>();
}

class _StorageScreenState<T extends Storage> extends State<StorageScreen<T>> {
  late Future<List<T>> _futureItems;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() {
    setState(() {
      _futureItems = widget.fetchItems();
    });
  }

  void _showAddDialog() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Ajouter ${widget.title.toLowerCase()}"),
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
              await widget.onAdd(controller.text);
              Navigator.pop(context);
              _refresh();
            },
            child: const Text("Ajouter"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: FutureBuilder<List<T>>(
        future: _futureItems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Erreur : ${snapshot.error}"));
          }

          final items = snapshot.data ?? [];
          if (items.isEmpty) {
            return const Center(child: Text("Aucun élément pour le moment."));
          }

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return StorageCard(
                storage: item,
                onTap: () => widget.onTap?.call(item),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
