class Jogador {
  int? id;
  String nickName;
  int cristais;
  int level;
  int amuletos;

  Jogador({
    this.id,
    required this.nickName,
    required this.cristais,
    required this.level,
    required this.amuletos,
  });

  // Convertendo para Map (para inserir no banco)
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'nome': nickName,
      'experiencia': cristais,
      'nivel': level,
      'amuletos': amuletos,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  // Convertendo de Map (vindo do banco)
  factory Jogador.fromMap(Map<String, dynamic> map) {
    return Jogador(
      id: map['id'],
      nickName: map['nome'],
      cristais: map['experiencia'],
      level: map['nivel'],
      amuletos: map['amuletos'],
    );
  }
}
