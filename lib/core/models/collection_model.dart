import 'package:game/core/models/creature_model.dart';

class Collection {
  int id;
  List<Creature> creatures;

  Collection(this.id, this.creatures);

  Map<String, dynamic> toMap() {
    return {'id': id, 'creatures': creatures.map((c) => c.toMap()).toList()};
  }

  factory Collection.fromMap(Map<String, dynamic> map) {
    return Collection(
      map['id'] as int,
      (map['creatures'] as List<dynamic>)
          .map((c) => Creature.fromMap(c as Map<String, dynamic>))
          .toList(),
    );
  }
}
