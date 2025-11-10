import 'package:rangement/data/models/thing.dart';

class Trip implements Thing {
  @override
  final int? id;
  @override
  final String name;
  final List<int>? itemIds;

  const Trip({this.id, required this.name, this.itemIds});

  factory Trip.fromMap(Map<String, dynamic> map) {
    final itemIdsString = map['itemIds'] as String?;
    final itemIds = itemIdsString != null
        ? itemIdsString.split(',').map(int.parse).toList()
        : <int>[];
    return Trip(id: map['id'], name: map['name'], itemIds: itemIds);
  }

  Map<String, dynamic> toMap() => {'name': name};

  Trip copyWith({int? id, String? name}) {
    return Trip(id: id ?? this.id, name: name ?? this.name, itemIds: []);
  }
}
