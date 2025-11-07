class Trip {
  final int? id;
  final String name;

  const Trip({this.id, required this.name});

  factory Trip.fromMap(Map<String, dynamic> map) =>
      Trip(id: map['id'], name: map['name']);

  Map<String, dynamic> toMap() => {'name': name};

  Trip copyWith({int? id, String? name}) {
    return Trip(id: id ?? this.id, name: name ?? this.name);
  }
}
