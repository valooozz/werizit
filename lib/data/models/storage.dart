abstract class Storage {
  final int? id;
  final String name;

  const Storage({this.id, required this.name});

  Map<String, dynamic> toMap() => {'name': name};

  Storage copyWith({int? id, String? name, int? parentId});
}
