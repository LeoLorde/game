import 'package:flutter/material.dart';
import 'package:flame/flame.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:game/database/dao/loja_dao.dart';
import 'package:game/database/seed/store_seed.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'presentation/screens/tela_carregamento.dart';
import 'package:game/application/audio/audio_manager.dart';
import 'package:game/database/app_database.dart' as database;

// Plugin global para notificações
final FlutterLocalNotificationsPlugin notificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o áudio de background do jogo
  AudioManager.instance.init();

  // Flame fullscreen
  await Flame.device.fullScreen();

  // Inicializa Timezone
  tz.initializeTimeZones();

  // Define o timezone local usando flutter_timezone
  final String localTimeZone = await FlutterTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(localTimeZone));

  // Configurações de inicialização das notificações
  var androidSettings = const AndroidInitializationSettings(
    '@mipmap/ic_launcher',
  );
  var iosSettings = const DarwinInitializationSettings();
  var initSettings = InitializationSettings(
    android: androidSettings,
    iOS: iosSettings,
  );

  await notificationsPlugin.initialize(initSettings);

  // LOJA

  // final Database db = await database.AppDatabase.instance.getDatabase();

  // final lojaDao = LojaDao(db);

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const TelaCarregamento(),
    ),
  );
}
