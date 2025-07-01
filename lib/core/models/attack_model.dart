import 'creature_model.dart';
import '../enums/elemento_enum.dart';

class Attack {
  String name;
  int base_damage; 
  List<Elemento> elementos;
  
  Attack(this.name, this.base_damage, this.elementos);

  // Cria um Map com os Multiplicadores de Dano de CADA ELEMENTO
  static final Map<Elemento, Map<Elemento, double>> _multiplicadores = {
    Elemento.fogo: {
      Elemento.agua: 0.5,
      Elemento.terra: 1.5,
      Elemento.ar: 0.5,
      Elemento.fogo: 1.0,
      Elemento.nulo: 2.0,
    },
    Elemento.agua: {
      Elemento.fogo: 2.0,
      Elemento.terra: 0.5,
      Elemento.ar: 1.0,
      Elemento.agua: 1.0,
      Elemento.nulo: 2.0,
    },
    Elemento.ar: {
      Elemento.fogo: 2.0,
      Elemento.terra: 1.0,
      Elemento.ar: 1.0,
      Elemento.agua: 1.0,
      Elemento.nulo: 2.0,
    },
    Elemento.terra: {
      Elemento.fogo: 0.75,
      Elemento.terra: 1.0,
      Elemento.ar: 1.0,
      Elemento.agua: 2.0,
      Elemento.nulo: 2.0,
    },
    Elemento.nulo: {
      Elemento.fogo: 1.0,
      Elemento.agua: 1.0,
      Elemento.terra: 1.0,
      Elemento.ar: 1.0,
      Elemento.nulo: 1.0,
    }
  };
  
  double GetDamageMultiplier(Creature creature_) {
    double total = 0.0; // Inicia a Variável com o Total da Multiplicação com 0
    for(Elemento elemento in elementos){ // Adiciona a possibilidade de um ataque ter VÁRIOS elementos
      int elementosCount = creature_.elementos.length; // Pega o Número de Elementos na Criatura
      for (Elemento elemento_ in creature_.elementos) { // Para CADA Elemento na Criatura:
        double mult = _multiplicadores[elemento]?[elemento_] ?? 1.0; // Se Existir na Tabela _multiplicadores, pegue o valor, se não, pegue o valor 1.0
        total += mult * (1 / elementosCount); // Adiciona ao Total de acordo com a Fórmula no GDD  
      }
    }

  return total;
}

  // Calcula o Dano Total  
  int calcDamage(Creature creature_) {
    double mult = GetDamageMultiplier(creature_); // Multiplica o Dano Base com o Elemental
    return (base_damage * mult).round(); // Arredonda para Inteiro
  }

  // Transforma em Dicionário (Útil para usar com JSON)
  Map<String, dynamic> toMap() {
      return {
        'name': name,
        'base_damage': base_damage,
        'elementos': elementos.map((e) => e.index).toList(), // Salva como Lista de Indexes
      };
    }

  // A Partir de um Map transformar em um Attack (Quando receber do SQFlite)
  factory Attack.fromMap(Map<String, dynamic> map) {
    return Attack(
      map['name'] as String,
      map['base_damage'] as int,
      (map['elementos'] as List).map((i) => Elemento.values[i]).toList(),
    );
  }
}