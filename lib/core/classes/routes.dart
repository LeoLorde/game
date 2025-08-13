import 'package:flutter/material.dart';
import 'package:game/presentation/screens/init_page/tela_inicial.dart';
import 'package:game/presentation/screens/tela_principal.dart';


class Routes {
  static Map<String, Widget Function(BuildContext)> list = <String, WidgetBuilder>{
    '/home': (_) => const TelaInicial()
  };

  static String initial = '/home';
  static GlobalKey<NavigatorState>? navigatorKey = GlobalKey<NavigatorState>();

}


