import 'package:flutter/material.dart';
import 'dashboard/dashboard_screen.dart';
import 'phong/phong_list_screen.dart';
import 'khach_thue/khach_thue_list_screen.dart';
import 'hoa_don/hoa_don_list_screen.dart';
import 'thu_chi/thu_chi_list_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const PhongListScreen(),
    const KhachThueListScreen(),
    const HoaDonListScreen(),
    const ThuChiListScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_rounded), label: 'Tổng quan'),
          BottomNavigationBarItem(icon: Icon(Icons.meeting_room_rounded), label: 'Phòng'),
          BottomNavigationBarItem(icon: Icon(Icons.people_alt_rounded), label: 'Khách'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long_rounded), label: 'Hóa đơn'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_rounded), label: 'Thu chi'),
        ],
      ),
    );
  }
}
