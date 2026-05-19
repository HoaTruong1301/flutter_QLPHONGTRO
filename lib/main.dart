import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/phong_provider.dart';
import 'providers/khach_thue_provider.dart';
import 'providers/hoa_don_provider.dart';
import 'providers/thu_chi_provider.dart';
import 'providers/hop_dong_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/main_screen.dart';
import 'services/auth_service.dart';

void main() async {
  // BẮT BUỘC: Khởi tạo các dịch vụ hệ thống (Database, SharedPreferences...)
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PhongProvider()),
        ChangeNotifierProvider(create: (_) => KhachThueProvider()),
        ChangeNotifierProvider(create: (_) => HoaDonProvider()),
        ChangeNotifierProvider(create: (_) => ThuChiProvider()),
        ChangeNotifierProvider(create: (_) => HopDongProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quản Lý Phòng Trọ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: FutureBuilder<bool>(
        future: AuthService().isLoggedIn(),
        builder: (context, snapshot) {
          // Hiển thị màn hình chờ trong khi kiểm tra login
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          // Nếu đã đăng nhập thì vào MainScreen, ngược lại vào Login
          if (snapshot.data == true) {
            return const MainScreen();
          }
          return const LoginScreen();
        },
      ),
    );
  }
}
