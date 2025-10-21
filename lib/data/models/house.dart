import 'package:rangement/data/models/storage.dart';

class House extends Storage {
  const House({super.id, required super.name});

  factory House.fromMap(Map<String, dynamic> map) =>
      House(id: map['id'], name: map['name']);
}
