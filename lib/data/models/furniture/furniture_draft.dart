import 'package:werizit/data/models/storage/storage_draft.dart';

class FurnitureDraft extends StorageDraft {
  final int room;
  const FurnitureDraft({required super.name, required this.room});

  factory FurnitureDraft.fromMap(Map<String, dynamic> map) =>
      FurnitureDraft(name: map['name'], room: map['room']);

  @override
  Map<String, dynamic> toMap() => {...super.toMap(), 'room': room};

  @override
  FurnitureDraft copyWith({String? name, int? parentId}) {
    return FurnitureDraft(name: name ?? this.name, room: parentId ?? room);
  }
}
