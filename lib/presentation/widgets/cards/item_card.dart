import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rangement/data/db/dao.dart';
import 'package:rangement/data/db/mock_dao.dart';
import 'package:rangement/data/models/item.dart';
import 'package:rangement/data/models/item_info.dart';

class ItemCard extends StatefulWidget {
  final Item item;
  final VoidCallback? onTap;

  const ItemCard({super.key, required this.item, this.onTap});

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  final dao = kIsWeb ? MockDAO() : DAO();
  late ItemInfo _itemInfo;

  void _showInfoDialog() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    _itemInfo = await dao.getItemInfo(widget.item.id);

    if (!mounted) return;

    Navigator.pop(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(widget.item.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_itemInfo.house, style: TextStyle(fontSize: 18)),
            Icon(Icons.keyboard_double_arrow_down),
            Text(_itemInfo.room, style: TextStyle(fontSize: 18)),
            Icon(Icons.keyboard_double_arrow_down),
            Text(_itemInfo.furniture, style: TextStyle(fontSize: 18)),
            Icon(Icons.keyboard_double_arrow_down),
            Text(_itemInfo.shelf, style: TextStyle(fontSize: 18)),
          ],
        ),
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
      child: InkWell(
        onTap: _showInfoDialog,
        borderRadius: BorderRadius.circular(12),
        child: ListTile(
          title: Text(
            widget.item.name,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text("ID: ${widget.item.id}"),
          onTap: widget.onTap,
        ),
      ),
    );
  }
}
