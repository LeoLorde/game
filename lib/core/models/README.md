# Exemplos de Uso #

## Attack Model ##

Todas as interações com o modelo Attack estão aqui:

### Criando um Ataque ###

```dart
import './attack_model.dart';
import '../enums/elemento_enum.dart';

Attack ataque_ = Attack(
    "Chama Ardente",
    25,
    [Elemento.fogo, Elemento.fogo]
);
```

### Calculando o Dano em uma Criatura ###

```dart
import './attack_model.dart';
import '../enums/elemento_enum.dart';
import 'creature_model.dart';

criatura_de_fogo = Creature(/* EXPLICAÇÃO ABAIXO */);

int damage = ataque_.calcDamage(criatura_de_fogo);
print(damage);
```

### Usando o ToMap() ###

```dart
import './attack_model.dart';

Map<String, dynamic> new_map = ataque_.toMap();
print(new_map);
```

### Usando o FromMap() ###

```dart
import './attack_model.dart';

Attack attack_from_map = Attack.fromMap(new_map);
print(attack_from_map.toMap());
```

## Creature Model ##

Todas as interações com o modelo Creature estão aqui:

### Criando uma Criatura ###

```dart
import './creature_model.dart';
import '../enums/elemento_enum.dart';

Creature criatura_ = Creature(
    100, // Vida (Inteiro)
    1, // Level (Inteiro)
    0.0, // XP (Double)
    [Elemento.fogo, Elemento.terra], // Lista de Elementos (List<ENUM Elemento>)
    Raridade.comum, // Raridade (ENUM Raridade)
    [ // Lista de Ataques (List<Attack>)
        Attack("Chama Ardente", 25, Elemento.fogo), 
        Attack("Espinhos de Terra", 30, Elemento.terra)
    ], 
    "/criatura_de_fogo_e_terra.png" // Nome da Imagem (String)
);
```

### Caminho Completo da Imagem ###

```dart
import './creature_model.dart';
import '../enums/elemento_enum.dart';

String path = creature_.getCompletePath()
```

### Usando o ToMap() ###

```dart
import './creature_model.dart';

Map<String, dynamic> new_map = creature_.toMap();
print(new_map);
```

### Usando o FromMap() ###

```dart
import './creature_model.dart';

Creature creature_from_map = Creature.fromMap(new_map);
print(creature_from_map.toMap());
```
