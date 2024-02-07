import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final settingsChangeProvider =
    ChangeNotifierProvider<SettingsChangeNotifier>((ref) {
  return SettingsChangeNotifier();
});

class SettingsChangeNotifier extends ChangeNotifier {
  final Settings _settings = Settings();

  void toggle() {
    _settings.toggle();
    notifyListeners();
  }

  bool get orderByName => _settings.orderAfterName;
}

class Settings {
  Settings({this.orderAfterName = true});

  bool orderAfterName;

  void toggle() {
    orderAfterName = !orderAfterName;
  }
}
