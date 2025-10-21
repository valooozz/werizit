import 'package:rangement/data/models/storage.dart';

class Furniture extends Storage {
  final int room;
  const Furniture({super.id, required super.name, required this.room});

  factory Furniture.fromMap(Map<String, dynamic> map) =>
      Furniture(id: map['id'], name: map['name'], room: map['room']);

  @override
  Map<String, dynamic> toMap() => {...super.toMap(), 'room': room};
}
