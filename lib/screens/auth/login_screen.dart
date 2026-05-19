import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../main_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController(text: 'admin@gmail.com');
  final _passController = TextEditingController(text: '123456');
  bool _isLoading = false;
  final _authService = AuthService();

  void _handleLogin() async {
    setState(() => _isLoading = true);
    final success = await _authService.login(_emailController.text, _passController.text);
    setState(() => _isLoading = false);

    if (success && mounted) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tài khoản hoặc mật khẩu không đúng!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.blue[800]!, Colors.blue[400]!])
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 100),
              const Icon(Icons.home_work_rounded, size: 100, color: Colors.white),
              const Text("PHÒNG TRỌ APP", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        TextField(controller: _emailController, decoration: const InputDecoration(labelText: "Email", prefixIcon: Icon(Icons.email))),
                        const SizedBox(height: 16),
                        TextField(controller: _passController, obscureText: true, decoration: const InputDecoration(labelText: "Mật khẩu", prefixIcon: Icon(Icons.lock))),
                        const SizedBox(height: 32),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50), shape: const StadiumBorder()),
                          onPressed: _isLoading ? null : _handleLogin,
                          child: _isLoading ? const CircularProgressIndicator() : const Text("ĐĂNG NHẬP"),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const SignupScreen()));
                          },
                          child: const Text("Chưa có tài khoản? Đăng ký ngay"),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
