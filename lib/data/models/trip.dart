import 'package:werizit/data/models/thing.dart';

class Trip implements Thing {
  @override
  final int? id;
  @override
  final String name;
  final bool selected;
  final List<int>? itemIds;

  const Trip({
    this.id,
    required this.name,
    this.selected = false,
    this.itemIds,
  });

  factory Trip.fromMap(Map<String, dynamic> map) {
    final itemIdsString = map['itemIds'] as String?;
    final itemIds = itemIdsString != null
        ? itemIdsString.split(',').map(int.parse).toList()
        : <int>[];
    return Trip(
      id: map['id'],
      name: map['name'],
      selected: map['selected'],
      itemIds: itemIds,
    );
  }

  Map<String, dynamic> toMap() => {'name': name, 'selected': false};

  Trip copyWith({int? id, String? name, bool? selected}) {
    return Trip(
      id: id ?? this.id,
      name: name ?? this.name,
      selected: selected ?? this.selected,
      itemIds: [],
    );
  }
}
