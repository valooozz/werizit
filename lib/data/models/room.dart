import 'package:rangement/data/models/storage.dart';

class Room extends Storage {
  final int house;
  const Room({required super.id, required super.name, required this.house});

  factory Room.fromMap(Map<String, dynamic> map) =>
      Room(id: map['id'], name: map['name'], house: map['house']);

  @override
  Map<String, dynamic> toMap() => {...super.toMap(), 'house': house};
}
