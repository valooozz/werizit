import 'package:flutter/material.dart';
import 'package:rangement/data/models/storage.dart';

class StorageCard extends StatelessWidget {
  final Storage storage;
  final VoidCallback onTap;

  const StorageCard({super.key, required this.storage, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: ListTile(
        title: Text(
          storage.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
