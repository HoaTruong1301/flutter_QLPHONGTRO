import 'package:flutter/material.dart';
import '../data/database_helper.dart';
import '../models/thu_chi_model.dart';

class ThuChiProvider with ChangeNotifier {
  List<ThuChi> _allThuChi = [];
  String _filterLoai = "";

  List<ThuChi> get filteredThuChi {
    if (_filterLoai.isEmpty) return _allThuChi;
    return _allThuChi.where((tc) => tc.loai == _filterLoai).toList();
  }

  double _tongThu = 0;
  double _tongChi = 0;

  double get tongThu => _tongThu;
  double get tongChi => _tongChi;
  double get soDu => _tongThu - _tongChi;

  Future<void> fetchThuChi() async {
    _allThuChi = await DatabaseHelper.instance.getAllThuChi();
    _tongThu = await DatabaseHelper.instance.getTongThu();
    _tongChi = await DatabaseHelper.instance.getTongChi();
    notifyListeners();
  }

  void setFilter(String loai) {
    _filterLoai = loai;
    notifyListeners();
  }

  Future<void> addThuChi(ThuChi tc) async {
    await DatabaseHelper.instance.insertThuChi(tc);
    await fetchThuChi();
  }

  Future<void> deleteThuChi(int id) async {
    await DatabaseHelper.instance.delete('thu_chi', where: 'id = ?', whereArgs: [id]);
    await fetchThuChi();
  }
}
