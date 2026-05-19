import 'package:flutter/material.dart';
import '../data/database_helper.dart';
import '../models/hoa_don_model.dart';
import '../models/thu_chi_model.dart';

class HoaDonProvider with ChangeNotifier {
  List<HoaDon> _allHoaDon = [];
  String _filter = "";

  List<HoaDon> get filteredHoaDon {
    return _allHoaDon.where((hd) => _filter.isEmpty || hd.trangThai == _filter).toList();
  }

  Future<void> fetchHoaDon() async {
    _allHoaDon = await DatabaseHelper.instance.getAllHoaDon();
    notifyListeners();
  }

  String get filter => _filter;

  void setFilter(String filter) {
    _filter = filter;
    notifyListeners();
  }

  Future<void> insertHoaDon(HoaDon hd) async {
    await DatabaseHelper.instance.insertHoaDon(hd);
    await fetchHoaDon();
  }

  Future<void> thanhToan(HoaDon hd) async {
    final updatedHd = HoaDon(
      id: hd.id,
      phongId: hd.phongId,
      khachThueId: hd.khachThueId,
      thangNam: hd.thangNam,
      tienPhong: hd.tienPhong,
      tongTienDichVu: hd.tongTienDichVu,
      tongTien: hd.tongTien,
      trangThai: "Đã thanh toán",
      ngayTao: hd.ngayTao,
      ngayThanhToan: DateTime.now().millisecondsSinceEpoch,
    );
    
    await DatabaseHelper.instance.update('hoa_don', updatedHd.toMap(), where: 'id = ?', whereArgs: [hd.id]);

    final tc = ThuChi(
      loai: "THU",
      danhMuc: "Tiền thuê nhà",
      soTien: hd.tongTien,
      moTa: "Thu tiền hóa đơn tháng ${hd.thangNam}",
      phongId: hd.phongId,
      ngayGiaoDich: DateTime.now().millisecondsSinceEpoch,
      ngayTao: DateTime.now().millisecondsSinceEpoch,
    );
    await DatabaseHelper.instance.insertThuChi(tc);

    await fetchHoaDon();
  }
}
