import 'package:werizit/data/models/thing/thing.dart';

class Item implements Thing {
  @override
  final int id;
  @override
  final String name;
  final int? shelf;
  final bool taken;

  // ================================
  // shelf = -1 => Item in Box
  // shelf = -2 => Item in Wardrobe
  // ================================

  const Item({
    required this.id,
    required this.name,
    required this.shelf,
    required this.taken,
  });

  factory Item.fromMap(Map<String, dynamic> map) => Item(
    id: map['id'],
    name: map['name'],
    shelf: map['shelf'],
    taken: map['taken'] == 0 ? false : true,
  );

  Map<String, dynamic> toMap() => {
    'name': name,
    'shelf': shelf,
    'taken': taken ? 1 : 0,
  };

  Item copyWith({int? id, String? name, int? shelf, bool? taken}) {
    return Item(
      id: id ?? this.id,
      name: name ?? this.name,
      shelf: shelf ?? this.shelf,
      taken: taken ?? this.taken,
    );
  }
}
