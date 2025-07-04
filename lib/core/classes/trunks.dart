import 'package:game/core/classes/generate_letter.dart';

import '../models/creature_model.dart';
import '../enums/elemento_enum.dart';
import 'element_map.dart';
import 'dart:convert';
import '../models/attack_model.dart';
import 'dart:math';

class Trunk {
  int raridade_bau = 0;
  int nivel = 0;

  int receber_ouro() {
    if (nivel == 5) {
      // jogador recebe tanto de ouro...
    }
    return 0;
  }

  int receber_talismanes() {
    if (nivel == 5) {
      // jogador recebe tanto de talismanes...
    }
    return 0;
  }

  void gerarCartas() {
    for (int i = 1; i < 3; i++) {
      int carta_recebida = GenerateLetter().retornarfds();
      int colecao = carta_recebida;
      print("Carta $i recebida: $colecao");
    }
  }
}