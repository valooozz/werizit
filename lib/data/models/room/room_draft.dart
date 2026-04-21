import 'package:werizit/data/models/storage/storage_draft.dart';

class RoomDraft extends StorageDraft {
  final int house;
  const RoomDraft({required super.name, required this.house});

  factory RoomDraft.fromMap(Map<String, dynamic> map) =>
      RoomDraft(name: map['name'], house: map['house']);

  @override
  Map<String, dynamic> toMap() => {...super.toMap(), 'house': house};

  @override
  RoomDraft copyWith({String? name, int? parentId}) {
    return RoomDraft(name: name ?? this.name, house: parentId ?? house);
  }
}
