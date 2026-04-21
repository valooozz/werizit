import 'package:werizit/data/models/thing/thing_draft.dart';

class ItemDraft implements ThingDraft {
  @override
  final String name;
  final int? shelf;
  final bool taken;

  // ================================
  // shelf = -1 => Item in Box
  // shelf = -2 => Item in Wardrobe
  // ================================

  const ItemDraft({
    required this.name,
    required this.shelf,
    required this.taken,
  });

  factory ItemDraft.fromMap(Map<String, dynamic> map) => ItemDraft(
    name: map['name'],
    shelf: map['shelf'],
    taken: map['taken'] == 0 ? false : true,
  );

  Map<String, dynamic> toMap() => {
    'name': name,
    'shelf': shelf,
    'taken': taken ? 1 : 0,
  };

  ItemDraft copyWith({String? name, int? shelf, bool? taken}) {
    return ItemDraft(
      name: name ?? this.name,
      shelf: shelf ?? this.shelf,
      taken: taken ?? this.taken,
    );
  }
}
