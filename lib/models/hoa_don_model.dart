class HoaDon {
  int? id;
  int phongId;
  int? khachThueId;
  String? thangNam;
  double tienPhong;
  double tongTienDichVu;
  double tongTien;
  String? trangThai;
  int ngayTao;
  int? ngayThanhToan;
  String? ghiChu;

  static const String CHUA_THANH_TOAN = "Chưa thanh toán";
  static const String DA_THANH_TOAN = "Đã thanh toán";

  HoaDon({
    this.id,
    required this.phongId,
    this.khachThueId,
    this.thangNam,
    required this.tienPhong,
    required this.tongTienDichVu,
    required this.tongTien,
    this.trangThai,
    required this.ngayTao,
    this.ngayThanhToan,
    this.ghiChu,
  });

  Map<String, dynamic> toMap() => {
    'id': id, 'phongId': phongId, 'khachThueId': khachThueId, 'thangNam': thangNam,
    'tienPhong': tienPhong, 'tongTienDichVu': tongTienDichVu, 'tongTien': tongTien,
    'trangThai': trangThai, 'ngayTao': ngayTao, 'ngayThanhToan': ngayThanhToan, 'ghiChu': ghiChu
  };

  factory HoaDon.fromMap(Map<String, dynamic> map) => HoaDon(
    id: map['id'],
    phongId: map['phongId'],
    khachThueId: map['khachThueId'],
    thangNam: map['thangNam'],
    tienPhong: map['tienPhong']?.toDouble() ?? 0.0,
    tongTienDichVu: map['tongTienDichVu']?.toDouble() ?? 0.0,
    tongTien: map['tongTien']?.toDouble() ?? 0.0,
    trangThai: map['trangThai'],
    ngayTao: map['ngayTao'] ?? 0,
    ngayThanhToan: map['ngayThanhToan'],
    ghiChu: map['ghiChu'],
  );
}
