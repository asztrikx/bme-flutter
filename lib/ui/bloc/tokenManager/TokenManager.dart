import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokeManager {
  final _shared = GetIt.I<SharedPreferences>();
  static const _key = "TOKEN";
  String? _token = null;
  bool remember = false;
  
  String? get token {
    _token ??= _shared.getString(_key);
    return _token;
  }

  bool hasSavedToken() {
    return _shared.containsKey(_key);
  }

  Future<void> clearSaved() async {
    //await _shared.remove(_key);
    await _shared.clear();
  }

  setToken(String token, bool save) async {
    _token = token;
    if (save) {
      await _shared.setString(_key, token);
    }
  }
}
