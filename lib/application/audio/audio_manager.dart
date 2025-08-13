import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/widgets.dart';

class AudioManager with WidgetsBindingObserver {
  AudioManager._();
  static final AudioManager instance = AudioManager._();

  final AudioPlayer _bgm = AudioPlayer(); // música de fundo
  final AudioPlayer _sfx = AudioPlayer(); // efeitos
  final List<String> _bgmStack =
      []; // pilha de trilhas (menu -> batalha -> ...)
  String? _currentBgm;
  bool _initialized = false;
  bool _shouldResume = false;
  double _bgmVolume = 1.0;

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    WidgetsBinding.instance.addObserver(this);

    await _bgm.setReleaseMode(ReleaseMode.loop);
    await _sfx.setReleaseMode(ReleaseMode.stop);
    await _bgm.setVolume(_bgmVolume);
  }

  Future<void> dispose() async {
    WidgetsBinding.instance.removeObserver(this);
    await _bgm.stop();
    await _sfx.stop();
    await _bgm.dispose();
    await _sfx.dispose();
    _bgmStack.clear();
    _currentBgm = null;
    _initialized = false;
  }

  // Toca uma BGM como atual (sem empilhar a anterior)
  Future<void> playBgm(String assetPath) async {
    _currentBgm = assetPath;
    await _bgm.stop();
    await _bgm.play(AssetSource(assetPath));
    _shouldResume = true;
  }

  // Empilha a BGM atual e toca outra
  Future<void> pushBgm(String assetPath) async {
    if (_currentBgm != null) {
      _bgmStack.add(_currentBgm!);
    }
    await playBgm(assetPath);
  }

  // Sai da BGM atual e volta pra anterior
  Future<void> popBgm() async {
    if (_bgmStack.isNotEmpty) {
      final prev = _bgmStack.removeLast();
      await playBgm(prev);
    } else {
      await stopBgm();
    }
  }

  Future<void> stopBgm() async {
    _currentBgm = null;
    _bgmStack.clear();
    await _bgm.stop();
    _shouldResume = false;
  }

  // “Abaixa” a BGM, toca SFX e depois volta o volume
  Future<void> duckAndPlaySfx(String assetPath, {double duckTo = 0.2}) async {
    final prevVol = _bgmVolume;
    await setBgmVolume(duckTo);

    // quando o SFX terminar, restaurar volume
    _sfx.onPlayerComplete.first.then((_) async {
      await setBgmVolume(prevVol);
    });

    await _sfx.stop();
    await _sfx.play(AssetSource(assetPath));
  }

  Future<void> playSfx(String assetPath) async {
    await _sfx.stop();
    await _sfx.play(AssetSource(assetPath));
  }

  Future<void> setBgmVolume(double v) async {
    _bgmVolume = v.clamp(0.0, 1.0);
    await _bgm.setVolume(_bgmVolume);
  }

  // ===== Lifecycle =====
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
        _bgm.pause();
        break;

      case AppLifecycleState.resumed:
        if (_shouldResume && _currentBgm != null) {
          _bgm.resume();
        }
        break;

      case AppLifecycleState.detached:
        // app fechando/encerrando
        stopBgm();
        break;
    }
  }
}
