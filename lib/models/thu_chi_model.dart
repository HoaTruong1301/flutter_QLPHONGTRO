class ThuChi {
  int? id;
  String loai; // 'THU' hoặc 'CHI'
  String danhMuc;
  double soTien;
  String? moTa;
  int ngayGiaoDich;
  int? phongId;
  int ngayTao;

  // Các danh mục mặc định
  static const List<String> DANH_MUC_THU = ["Tiền thuê nhà", "Tiền cọc", "Thu khác"];
  static const List<String> DANH_MUC_CHI = ["Sửa chữa", "Điện nước", "Bảo trì", "Internet", "Chi khác"];

  ThuChi({
    this.id,
    required this.loai,
    required this.danhMuc,
    required this.soTien,
    this.moTa,
    required this.ngayGiaoDich,
    this.phongId,
    required this.ngayTao,
  });

  Map<String, dynamic> toMap() => {
    'id': id, 'loai': loai, 'danhMuc': danhMuc, 'soTien': soTien, 'moTa': moTa,
    'ngayGiaoDich': ngayGiaoDich, 'phongId': phongId, 'ngayTao': ngayTao
  };

  factory ThuChi.fromMap(Map<String, dynamic> map) => ThuChi(
    id: map['id'],
    loai: map['loai'] ?? 'THU',
    danhMuc: map['danhMuc'] ?? 'Khác',
    soTien: (map['soTien'] as num?)?.toDouble() ?? 0.0,
    moTa: map['moTa'],
    ngayGiaoDich: map['ngayGiaoDich'] ?? 0,
    phongId: map['phongId'],
    ngayTao: map['ngayTao'] ?? 0,
  );
}
