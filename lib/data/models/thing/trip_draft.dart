import 'package:werizit/data/models/thing/thing_draft.dart';

class TripDraft implements ThingDraft {
  @override
  final String name;
  final bool selected;

  const TripDraft({required this.name, required this.selected});

  factory TripDraft.fromMap(Map<String, dynamic> map) {
    return TripDraft(
      name: map['name'],
      selected: map['selected'] == 0 ? false : true,
    );
  }

  Map<String, dynamic> toMap() => {'name': name, 'selected': selected ? 1 : 0};

  TripDraft copyWith({String? name, bool? selected}) {
    return TripDraft(
      name: name ?? this.name,
      selected: selected ?? this.selected,
    );
  }
}
