import 'package:flutter/material.dart';
import 'package:rangement/data/models/item.dart';

class ItemCard extends StatelessWidget {
  final Item item;
  final VoidCallback? onTap;

  const ItemCard({super.key, required this.item, this.onTap});

  void _showInfoDialog() {
    showDialog(
      context: this.context,
      builder: (context) => AlertDialog(
        title: Text(item.name),
        content: Column(children: [Text('Maison : ${item.name}')]),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(
          item.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text("ID: ${item.id}"),
        onTap: onTap,
      ),
    );
  }
}
