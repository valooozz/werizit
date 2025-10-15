class Item {
  final int id;
  final String name;
  final int shelf;

  const Item({required this.id, required this.name, required this.shelf});

  factory Item.fromMap(Map<String, dynamic> map) =>
      Item(id: map['id'], name: map['name'], shelf: map['shelf']);

  Map<String, dynamic> toMap() => {'id': id, 'name': name, 'shelf': shelf};
}
