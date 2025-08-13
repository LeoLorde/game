class Loja {
  int? id;
  String tipo;
  int preco;
  int? itemId;
  String? spriteFile;
  int? raridade;
  int quantidade;

  Loja({
    this.id,
    required this.tipo,
    required this.preco,
    this.itemId,
    this.spriteFile,
    this.raridade,
    this.quantidade = 1,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'tipo': tipo,
      'preco': preco,
      'item_id': itemId,
      'spriteFile': spriteFile,
      'raridade': raridade,
      'quantidade': quantidade,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  factory Loja.fromMap(Map<String, dynamic> map) {
    return Loja(
      id: map['id'],
      tipo: map['tipo'],
      preco: map['preco'],
      itemId: map['item_id'],
      spriteFile: map['spriteFile'],
      raridade: map['raridade'],
      quantidade: map['quantidade'] ?? 1,
    );
  }
}
