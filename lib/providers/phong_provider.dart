import 'package:flutter/material.dart';
import '../data/database_helper.dart';
import '../models/phong_model.dart';

class PhongProvider with ChangeNotifier {
  List<Phong> _allPhong = [];
  String _filter = "";
  String _searchQuery = "";

  String get filter => _filter;
  List<Phong> get allPhong => _allPhong;

  List<Phong> get filteredPhong {
    return _allPhong.where((p) {
      final matchesFilter = _filter.isEmpty || p.trangThai == _filter;
      final matchesSearch = _searchQuery.isEmpty || p.soPhong.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesFilter && matchesSearch;
    }).toList();
  }

  Future<void> fetchPhong() async {
    _allPhong = await DatabaseHelper.instance.getAllPhong();
    notifyListeners();
  }

  void setFilter(String filter) {
    _filter = filter;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> addPhong(Phong phong) async {
    await DatabaseHelper.instance.insertPhong(phong);
    await fetchPhong();
  }

  Future<void> updatePhong(Phong phong) async {
    await DatabaseHelper.instance.updatePhong(phong);
    await fetchPhong();
  }

  Future<void> deletePhong(int id) async {
    await DatabaseHelper.instance.deletePhong(id);
    await fetchPhong();
  }
}
