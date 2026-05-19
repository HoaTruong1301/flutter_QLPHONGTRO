class HopDong {
  int? id;
  int phongId;
  int khachThueId;
  String? ngayBatDau;
  String? ngayKetThuc;
  double tienCoc;
  double giaThue;
  String? noiDung;
  String? trangThai;
  int ngayTao;

  HopDong({
    this.id,
    required this.phongId,
    required this.khachThueId,
    this.ngayBatDau,
    this.ngayKetThuc,
    required this.tienCoc,
    required this.giaThue,
    this.noiDung,
    this.trangThai,
    required this.ngayTao,
  });

  Map<String, dynamic> toMap() => {
    'id': id, 'phongId': phongId, 'khachThueId': khachThueId, 'ngayBatDau': ngayBatDau,
    'ngayKetThuc': ngayKetThuc, 'tienCoc': tienCoc, 'giaThue': giaThue,
    'noiDung': noiDung, 'trangThai': trangThai, 'ngayTao': ngayTao
  };

  factory HopDong.fromMap(Map<String, dynamic> map) => HopDong(
    id: map['id'],
    phongId: map['phongId'] ?? 0,
    khachThueId: map['khachThueId'] ?? 0,
    ngayBatDau: map['ngayBatDau'],
    ngayKetThuc: map['ngayKetThuc'],
    tienCoc: map['tienCoc']?.toDouble() ?? 0.0,
    giaThue: map['giaThue']?.toDouble() ?? 0.0,
    noiDung: map['noiDung'],
    trangThai: map['trangThai'],
    ngayTao: map['ngayTao'] ?? 0,
  );
}
