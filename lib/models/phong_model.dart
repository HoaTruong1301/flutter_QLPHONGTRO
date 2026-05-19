class Phong {
  int? id;
  String soPhong;
  String loaiPhong;
  double giaThue;
  double dienTich;
  String trangThai;
  String? moTa;
  int ngayTao;

  static const String TRANG_THAI_TRONG = "Trống";
  static const String TRANG_THAI_DANG_THUE = "Đang thuê";
  static const String TRANG_THAI_DANG_SUA = "Đang sửa";

  Phong({
    this.id,
    required this.soPhong,
    required this.loaiPhong,
    required this.giaThue,
    required this.dienTich,
    required this.trangThai,
    this.moTa,
    required this.ngayTao,
  });

  Map<String, dynamic> toMap() => {
    'id': id, 'soPhong': soPhong, 'loaiPhong': loaiPhong, 'giaThue': giaThue,
    'dienTich': dienTich, 'trangThai': trangThai, 'moTa': moTa, 'ngayTao': ngayTao
  };

  factory Phong.fromMap(Map<String, dynamic> map) => Phong(
    id: map['id'],
    soPhong: map['soPhong'],
    loaiPhong: map['loaiPhong'],
    giaThue: map['giaThue']?.toDouble() ?? 0.0,
    dienTich: map['dienTich']?.toDouble() ?? 0.0,
    trangThai: map['trangThai'],
    moTa: map['moTa'],
    ngayTao: map['ngayTao'] ?? 0,
  );
}
