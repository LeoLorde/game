import '../enums/elemento_enum.dart';

// Cria um Map com os Multiplicadores de Dano de CADA ELEMENTO
// Relocalizando para facilitar Acesso Geral
class ElementMap {
  static final Map<Elemento, Map<Elemento, double>> multiplicadores = {
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
}