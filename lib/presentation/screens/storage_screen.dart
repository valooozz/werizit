import 'package:flutter/material.dart';
import 'package:rangement/core/utils/snackbar_utils.dart';
import 'package:rangement/data/models/storage.dart';
import 'package:rangement/presentation/screens/base_screen.dart';
import 'package:rangement/presentation/screens/search_screen.dart';
import 'package:rangement/presentation/widgets/cards/storage_card.dart';

class StorageScreen<T extends Storage> extends StatefulWidget {
  final String title;
  final Future<List<T>> Function() fetchItems;
  final Future<void> Function(String name) onAdd;
  final void Function(T item)? onTap;
  final void Function()? onBack;

  const StorageScreen({
    super.key,
    required this.title,
    required this.fetchItems,
    required this.onAdd,
    this.onTap,
    this.onBack,
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
        title: Text("Ajouter dans '${widget.title}'"),
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
              if (!mounted) return;
              Navigator.pop(context);
              showAppSnackBar('Élément de rangement ajouté !');
              _refresh();
            },
            child: const Text("Ajouter"),
          ),
        ],
      ),
    );
  }

  void _openSearchScreen() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => SearchScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: widget.title,
      onAdd: _showAddDialog,
      onSearch: _openSearchScreen,
      onBack: widget.onBack,
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
            return const Center(child: Text("Aucun élément pour le moment"));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 300,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 2,
            ),
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
    );
  }
}
