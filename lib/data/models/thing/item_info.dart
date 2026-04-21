class ItemInfo {
  final int id;
  final String name;
  final String house;
  final String room;
  final String furniture;
  final String shelf;

  const ItemInfo({
    required this.id,
    required this.name,
    required this.house,
    required this.room,
    required this.furniture,
    required this.shelf,
  });

  factory ItemInfo.fromMap(Map<String, dynamic> map) => ItemInfo(
    id: map['id'],
    name: map['name'],
    house: map['house'],
    room: map['room'],
    furniture: map['furniture'],
    shelf: map['shelf'],
  );

  Map<String, dynamic> toMap() => {'id': id, 'name': name, 'shelf': shelf};
}
