import 'package:rangement/data/models/item.dart';

class ItemsState {
  final List<Item> shelfItems;
  final List<Item> boxItems;
  final String shelfName;

  ItemsState({
    required this.shelfItems,
    required this.boxItems,
    required this.shelfName,
  });

  ItemsState copyWith({
    List<Item>? shelfItems,
    List<Item>? boxItems,
    String? shelfName,
  }) {
    return ItemsState(
      shelfItems: shelfItems ?? this.shelfItems,
      boxItems: boxItems ?? this.boxItems,
      shelfName: shelfName ?? this.shelfName,
    );
  }
}
