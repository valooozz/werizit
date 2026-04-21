import 'package:werizit/data/models/thing/thing.dart';

class Trip implements Thing {
  @override
  final int id;
  @override
  final String name;
  final bool selected;
  final List<int> itemIds;

  const Trip({
    required this.id,
    required this.name,
    required this.selected,
    required this.itemIds,
  });

  factory Trip.fromMap(Map<String, dynamic> map) {
    final itemIdsString = map['itemIds'] as String?;
    final itemIds = itemIdsString != null
        ? itemIdsString.split(',').map(int.parse).toList()
        : <int>[];
    return Trip(
      id: map['id'],
      name: map['name'],
      selected: map['selected'] == 0 ? false : true,
      itemIds: itemIds,
    );
  }

  Map<String, dynamic> toMap() => {'name': name, 'selected': selected ? 1 : 0};

  Trip copyWith({int? id, String? name, bool? selected, List<int>? itemIds}) {
    return Trip(
      id: id ?? this.id,
      name: name ?? this.name,
      selected: selected ?? this.selected,
      itemIds: itemIds ?? this.itemIds,
    );
  }
}
