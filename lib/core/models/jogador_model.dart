class Jogador {
  int? id;
  String nickName;
  int cristais;
  int level;
  int amuletos;
  int cartas;
  int? xp;

  Jogador({
    this.id,
    required this.nickName,
    required this.cristais,
    required this.level,
    required this.amuletos,
    required this.cartas,
    this.xp,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'id': id,
      'nickName': nickName,
      'cristais': cristais,
      'level': level,
      'amuletos': amuletos,
      'cartas': cartas,
      'xp': xp,
    };
    return map;
  }

  factory Jogador.fromMap(Map<String, dynamic> map) {
    return Jogador(
      id: map['id'],
      nickName: map['nickName'],
      cristais: map['cristais'],
      level: map['level'],
      amuletos: map['amuletos'],
      cartas: map['cartas'],
      xp: map['xp'],
    );
  }
}
