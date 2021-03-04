import 'dart:convert';

import 'package:app/models/http_exception.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;

  static const baseURL = 'https://identitytoolkit.googleapis.com/v1';

  Future<void> _authenticate(String email, String password, String path) async {
    final url = '$baseURL/$path';

    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true
          }));
      final data = json.decode(response.body);
      if (data['error'] != null) {
        throw HttpException(message: data['error']['message']);
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password,
        'accounts:signUp?key=AIzaSyAOilNYhU1KiYtVZ3746ccqSIQzMS-harY');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password,
        'accounts:signInWithPassword?key=AIzaSyAOilNYhU1KiYtVZ3746ccqSIQzMS-harY');
  }
}
