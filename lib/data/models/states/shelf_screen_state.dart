import 'package:werizit/data/models/item.dart';
import 'package:werizit/data/models/shelf.dart';

class ShelfScreenState {
  final Shelf shelf;
  final List<Item> shelfItems;
  final List<Item> boxItems;

  ShelfScreenState({
    required this.shelf,
    required this.shelfItems,
    required this.boxItems,
  });
}
