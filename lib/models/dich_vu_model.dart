class DichVu {
  int? id;
  String tenDichVu;
  double donGia;
  String? donViTinh;
  bool batBuoc;
  bool tinhTheoChiso;

  DichVu({
    this.id,
    required this.tenDichVu,
    required this.donGia,
    this.donViTinh,
    this.batBuoc = false,
    this.tinhTheoChiso = false,
  });

  Map<String, dynamic> toMap() => {
    'id': id, 'tenDichVu': tenDichVu, 'donGia': donGia, 'donViTinh': donViTinh,
    'batBuoc': batBuoc ? 1 : 0, 'tinhTheoChiso': tinhTheoChiso ? 1 : 0
  };

  factory DichVu.fromMap(Map<String, dynamic> map) => DichVu(
    id: map['id'],
    tenDichVu: map['tenDichVu'] ?? '',
    donGia: map['donGia']?.toDouble() ?? 0.0,
    donViTinh: map['donViTinh'],
    batBuoc: map['batBuoc'] == 1,
    tinhTheoChiso: map['tinhTheoChiso'] == 1,
  );
}

class ChiTietHoaDon {
  int? id;
  int hoaDonId;
  int dichVuId;
  String? tenDichVu;
  int? chiSoCu;
  int? chiSoMoi;
  int soLuong;
  double donGia;
  double thanhTien;

  ChiTietHoaDon({
    this.id,
    required this.hoaDonId,
    required this.dichVuId,
    this.tenDichVu,
    this.chiSoCu,
    this.chiSoMoi,
    required this.soLuong,
    required this.donGia,
    required this.thanhTien,
  });

  Map<String, dynamic> toMap() => {
    'id': id, 'hoaDonId': hoaDonId, 'dichVuId': dichVuId, 'tenDichVu': tenDichVu,
    'chiSoCu': chiSoCu, 'chiSoMoi': chiSoMoi, 'soLuong': soLuong, 'donGia': donGia, 'thanhTien': thanhTien
  };

  factory ChiTietHoaDon.fromMap(Map<String, dynamic> map) => ChiTietHoaDon(
    id: map['id'],
    hoaDonId: map['hoaDonId'] ?? 0,
    dichVuId: map['dichVuId'] ?? 0,
    tenDichVu: map['tenDichVu'],
    chiSoCu: map['chiSoCu'],
    chiSoMoi: map['chiSoMoi'],
    soLuong: map['soLuong'] ?? 0,
    donGia: map['donGia']?.toDouble() ?? 0.0,
    thanhTien: map['thanhTien']?.toDouble() ?? 0.0,
  );
}
