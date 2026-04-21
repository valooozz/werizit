import 'package:werizit/data/models/shelf/shelf.dart';
import 'package:werizit/data/models/thing/item.dart';

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
