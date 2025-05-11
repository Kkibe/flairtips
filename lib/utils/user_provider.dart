import 'package:flutter/foundation.dart';
import 'package:flairtips/models/user.dart';
import 'package:flairtips/utils/api_service.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  User? get user => _user;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  Future<void> loadUser() async {
    final savedUser = await getSavedUser(); // comes from api_service.dart
    if (savedUser != null) {
      _user = savedUser;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _user = null;
    await logoutUser(); // centralized cleanup from api_service.dart
    notifyListeners();
  }
}
