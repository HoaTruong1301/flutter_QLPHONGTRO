import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:qlphongtro/main.dart';
import 'package:qlphongtro/providers/phong_provider.dart';
import 'package:qlphongtro/providers/khach_thue_provider.dart';
import 'package:qlphongtro/providers/hoa_don_provider.dart';
import 'package:qlphongtro/providers/thu_chi_provider.dart';
import 'package:qlphongtro/providers/hop_dong_provider.dart';

void main() {
  testWidgets('App load smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
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

    // Initial load will show a loader or LoginScreen
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
