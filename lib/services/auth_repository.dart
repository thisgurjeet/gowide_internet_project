import 'package:gowiide_broadband_app/model/user_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  final String loginUrl =
      'https://www.gowidenet.in/admin/api/file/CustomerLogin.php';

  Future<User> login(Map<String, dynamic> body) async {
    try {
      final http.Response response = await http.post(
        Uri.parse(loginUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final User user = User.fromMap(responseData);

        // Store userId in SharedPreferences upon successful login
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userId', user.userId);

        return user;
      } else {
        throw Exception('Failed to login');
      }
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }
}
