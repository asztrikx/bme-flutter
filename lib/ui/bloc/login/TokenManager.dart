import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokeManager {
  var _shared = GetIt.I.get<SharedPreferences>();
  static const key = "TOKEN";

  TokeManager() {
  }

  String? get token {
    return _shared.getString(key) ?? null;
  }

  set token(String? token) {
    if (token == null) {
      _shared.remove(key);
    } else {
      _shared.setString(key, token);
    }
  }
}
