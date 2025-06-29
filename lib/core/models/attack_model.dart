import 'creature_model.dart';
import '../enums/elemento_enum.dart';

class Attack {
  int base_damage;
  Elemento elemento;
  
  Attack(this.base_damage, this.elemento);

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

 /* MULTIPLICA / COMBINA TODOS OS ELEMENTOS EM UM ÚNICO MULTIPLICADOR

  double GetDamageMultiplier(Creature creature_)
  {
    double total = 1.0;
    for(Elemento elemento_ in creature_.elementos)
    {
      total *= _multiplicadores[elemento]?[elemento_] ?? 1.0;
    }
    return total;
  }

  */

  // COPIANDO MAIS PARECIDO COM O QUE TEM NO GDD

  double GetDamageMultiplier(Creature creature_) {
    int elementosCount = creature_.elementos.length;
    double total = 0.0;

    for (Elemento elemento_ in creature_.elementos) {
      double mult = _multiplicadores[elemento]?[elemento_] ?? 1.0;
      total += mult * (1 / elementosCount); 
  }

  return total;
}

  int CalcDamage(Creature creature_) {
    double mult = GetDamageMultiplier(creature_);
    return (base_damage * mult).round();
}
}