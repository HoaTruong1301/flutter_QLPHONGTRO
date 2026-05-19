import 'package:flutter/material.dart';
import '../data/database_helper.dart';
import '../models/khach_thue_model.dart';

class KhachThueProvider with ChangeNotifier {
  List<KhachThue> _allKhach = [];
  String _searchQuery = "";

  List<KhachThue> get filteredKhach {
    return _allKhach.where((k) {
      final name = k.hoTen.toLowerCase();
      final phone = k.soDienThoai ?? "";
      return name.contains(_searchQuery.toLowerCase()) || phone.contains(_searchQuery);
    }).toList();
  }

  Future<void> fetchKhach() async {
    _allKhach = await DatabaseHelper.instance.getAllKhachThue();
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> addKhach(KhachThue khach) async {
    await DatabaseHelper.instance.insertKhachThue(khach);
    if (khach.phongId != null) {
      await DatabaseHelper.instance.update('phong', {'trangThai': 'Đang thuê'}, where: 'id = ?', whereArgs: [khach.phongId]);
    }
    await fetchKhach();
  }

  Future<void> updateKhach(KhachThue khach) async {
    await DatabaseHelper.instance.update('khach_thue', khach.toMap(), where: 'id = ?', whereArgs: [khach.id]);
    await fetchKhach();
  }

  Future<void> deleteKhach(int id) async {
    await DatabaseHelper.instance.delete('khach_thue', where: 'id = ?', whereArgs: [id]);
    await fetchKhach();
  }
}
