import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rangement/core/providers/items_provider.dart';
import 'package:rangement/data/models/item_info.dart';

class ItemInfoDialog extends ConsumerWidget {
  final int itemId;
  final ItemInfo itemInfo;
  final List<Widget>? actions;

  const ItemInfoDialog({
    super.key,
    required this.itemId,
    required this.itemInfo,
    this.actions,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allItems = ref.watch(itemsProvider);
    final item = allItems.where((i) => i.id == itemId).first;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // AppBar-like row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (actions != null) ...actions!,
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            // Content
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildInfoRow(itemInfo.house),
                  const Icon(Icons.keyboard_double_arrow_down),
                  _buildInfoRow(itemInfo.room),
                  const Icon(Icons.keyboard_double_arrow_down),
                  _buildInfoRow(itemInfo.furniture),
                  const Icon(Icons.keyboard_double_arrow_down),
                  _buildInfoRow(itemInfo.shelf),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String text) {
    return Text(text, style: const TextStyle(fontSize: 18));
  }
}
