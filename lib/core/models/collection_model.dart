class CollectionCard {
  final int? id;
  final int creatureId;
  int level;
  double xp;
  int vida;

  CollectionCard({
    this.id,
    required this.creatureId,
    required this.level,
    required this.xp,
    required this.vida,
  });

  /// Converte o objeto em Map para CRUD
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'creatureId': creatureId,
      'level': level,
      'xp': xp,
      'vida': vida,
    };
  }

  /// Reconstrói o objeto a partir do Map do banco
  factory CollectionCard.fromMap(Map<String, dynamic> map) {
    return CollectionCard(
      id: map['id'] as int?,
      creatureId: map['creatureId'] as int,
      level: map['level'] as int,
      xp: (map['xp'] as num).toDouble(),
      vida: map['vida'] as int,
    );
  }
}
