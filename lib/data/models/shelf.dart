import 'package:rangement/data/models/storage.dart';

class Shelf extends Storage {
  final int furniture;
  const Shelf({
    required super.id,
    required super.name,
    required this.furniture,
  });

  factory Shelf.fromMap(Map<String, dynamic> map) =>
      Shelf(id: map['id'], name: map['name'], furniture: map['furniture']);

  @override
  Map<String, dynamic> toMap() => {...super.toMap(), 'furniture': furniture};
}
