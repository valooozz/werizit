import 'package:rangement/data/models/thing.dart';

class Trip implements Thing {
  @override
  final int? id;
  @override
  final String name;

  const Trip({this.id, required this.name});

  factory Trip.fromMap(Map<String, dynamic> map) =>
      Trip(id: map['id'], name: map['name']);

  Map<String, dynamic> toMap() => {'name': name};

  Trip copyWith({int? id, String? name}) {
    return Trip(id: id ?? this.id, name: name ?? this.name);
  }
}
