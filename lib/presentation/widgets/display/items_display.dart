import 'package:flutter/material.dart';
import 'package:rangement/data/models/item.dart';
import 'package:rangement/presentation/widgets/cards/item_card.dart';

class ItemsDisplay extends StatelessWidget {
  const ItemsDisplay({
    super.key,
    required this.items,
    required this.isSelectionMode,
    this.selectedItems,
    this.onToggleSelection,
    this.onItemLongPress,
  });

  final List<Item> items;
  final bool isSelectionMode;
  final Set<int>? selectedItems;
  final Function(int)? onToggleSelection;
  final Function(int)? onItemLongPress;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final isSelected = selectedItems == null
            ? false
            : selectedItems!.contains(item.id);

        return ItemCard(
          item: item,
          isSelected: isSelected,
          isSelectionMode: isSelectionMode,
          onToggleSelection: () => onToggleSelection!(item.id!),
          onLongPress: onItemLongPress != null
              ? () => onItemLongPress!(item.id!)
              : null,
        );
      },
    );
  }
}
