abstract class Storage {
  final int id;
  final String name;

  const Storage({required this.id, required this.name});

  Map<String, dynamic> toMap() => {'id': id, 'name': name};
}
