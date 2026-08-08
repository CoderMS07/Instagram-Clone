import 'package:flutter/material.dart';
import 'package:instagram_clone/models/User.dart';
import 'package:instagram_clone/resources/auth_methods.dart';

class UserProvider with ChangeNotifier {
  final AuthMethods _authMethods = AuthMethods();
  User? _user;
  User get getUser => _user!;
  Future<void> refreshUser() async {
  try {
    User user = await AuthMethods().getUserDetails();
    _user = user;
  } catch (e) {
    print('Failed to load user profile: $e');
    _user = null;
  }
  notifyListeners();
}
}
