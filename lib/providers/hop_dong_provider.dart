import 'package:flutter/material.dart';
import '../data/database_helper.dart';
import '../models/hop_dong_model.dart';

class HopDongProvider with ChangeNotifier {
  List<HopDong> _allHopDong = [];

  List<HopDong> get allHopDong => _allHopDong;

  Future<void> fetchHopDong() async {
    _allHopDong = await DatabaseHelper.instance.getAllHopDong();
    notifyListeners();
  }

  Future<void> addHopDong(HopDong hd) async {
    await DatabaseHelper.instance.insertHopDong(hd);
    await fetchHopDong();
  }

  Future<void> deleteHopDong(int id) async {
    await DatabaseHelper.instance.deleteHopDong(id);
    await fetchHopDong();
  }
}
