import 'package:rangement/data/models/item.dart';

class ItemsState {
  final List<Item> shelfItems;
  final List<Item> boxItems;

  ItemsState({required this.shelfItems, required this.boxItems});

  ItemsState copyWith({List<Item>? shelfItems, List<Item>? boxItems}) {
    return ItemsState(
      shelfItems: shelfItems ?? this.shelfItems,
      boxItems: boxItems ?? this.boxItems,
    );
  }
}
