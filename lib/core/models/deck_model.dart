import 'dart:convert';

class DeckModel {
  int? id;
  String name;
  List<int> cardIds;

  DeckModel({this.id, required this.name, required this.cardIds});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'card_ids': jsonEncode(cardIds)};
  }

  factory DeckModel.fromMap(Map<String, dynamic> map) {
    return DeckModel(
      id: map['id'] as int,
      name: map['name'] as String,
      cardIds: List<int>.from(jsonDecode(map['card_ids'] as String)),
    );
  }
}
