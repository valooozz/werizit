import 'package:werizit/data/models/storage/storage.dart';

class House extends Storage {
  const House({required super.id, required super.name});

  factory House.fromMap(Map<String, dynamic> map) =>
      House(id: map['id'], name: map['name']);

  @override
  House copyWith({int? id, String? name, int? parentId}) {
    return House(id: id ?? this.id, name: name ?? this.name);
  }
}
