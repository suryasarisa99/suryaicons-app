// singleton class

import 'package:suryaicons_app/main.dart';

class Options {
  static final Options _instance = Options._internal();

  factory Options() {
    return _instance;
  }

  Options._internal();

  static String _copyType = 'Svg';

  static String get copyType => prefs?.getString('copyType') ?? _copyType;
  static set copyType(String value) {
    _copyType = value;
    prefs?.setString('copyType', value);
  }
}
