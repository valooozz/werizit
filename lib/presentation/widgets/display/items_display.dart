import 'package:flutter/material.dart';
import 'package:rangement/data/models/item.dart';
import 'package:rangement/presentation/widgets/cards/item_card.dart';

class ItemsDisplay extends StatelessWidget {
  const ItemsDisplay({super.key, required this.items});

  final List<Item> items;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return ItemCard(item: item);
      },
    );
  }
}
