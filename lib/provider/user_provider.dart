import 'package:flutter/material.dart';
import 'package:instagram_clone/models/User.dart';
import 'package:instagram_clone/resources/auth_methods.dart';

class UserProvider with ChangeNotifier {
  final AuthMethods _authMethods = AuthMethods();
  User? _user;
  User get getUser => _user!;
  Future<void> refreshUser() async {
    User user = await _authMethods.getUserDetails();
    _user=user;
    notifyListeners();
  }
}
