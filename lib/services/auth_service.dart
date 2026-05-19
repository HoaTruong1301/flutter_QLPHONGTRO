import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _userEmailKey = 'user_email';
  static const String _usersDbKey = 'registered_users'; // Giả lập DB lưu users

  // Hàm Đăng ký
  Future<bool> signUp(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Lấy danh sách users hiện tại
    String? usersJson = prefs.getString(_usersDbKey);
    Map<String, dynamic> users = usersJson != null ? jsonDecode(usersJson) : {};

    // Kiểm tra email đã tồn tại chưa
    if (users.containsKey(email)) return false;

    // Thêm user mới
    users[email] = password;
    await prefs.setString(_usersDbKey, jsonEncode(users));
    return true;
  }

  // Hàm Đăng nhập
  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final prefs = await SharedPreferences.getInstance();

    // Tài khoản admin mặc định
    if (email == 'admin@gmail.com' && password == '123456') {
      await _saveSession(email);
      return true;
    }

    // Kiểm tra trong "DB" giả lập
    String? usersJson = prefs.getString(_usersDbKey);
    if (usersJson != null) {
      Map<String, dynamic> users = jsonDecode(usersJson);
      if (users.containsKey(email) && users[email] == password) {
        await _saveSession(email);
        return true;
      }
    }
    return false;
  }

  Future<void> _saveSession(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, true);
    await prefs.setString(_userEmailKey, email);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, false);
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }
}
