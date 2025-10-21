class Item {
  final int? id;
  final String name;
  final int shelf;

  const Item({this.id, required this.name, required this.shelf});

  factory Item.fromMap(Map<String, dynamic> map) =>
      Item(id: map['id'], name: map['name'], shelf: map['shelf']);

  Map<String, dynamic> toMap() => {'name': name, 'shelf': shelf};
}
