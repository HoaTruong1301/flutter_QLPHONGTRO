class KhachThue {
  int? id;
  int? phongId;
  String hoTen;
  String? cccd;
  String? soDienThoai;
  String? email;
  String? queQuan;
  String? ngheNghiep;
  int ngayVao;
  int? ngayRa;
  bool dangThue;
  String? ghiChu;
  int ngayTao;

  KhachThue({
    this.id,
    this.phongId,
    required this.hoTen,
    this.cccd,
    this.soDienThoai,
    this.email,
    this.queQuan,
    this.ngheNghiep,
    required this.ngayVao,
    this.ngayRa,
    this.dangThue = true,
    this.ghiChu,
    required this.ngayTao,
  });

  Map<String, dynamic> toMap() => {
    'id': id, 'phongId': phongId, 'hoTen': hoTen, 'cccd': cccd, 'soDienThoai': soDienThoai,
    'email': email, 'queQuan': queQuan, 'ngheNghiep': ngheNghiep, 'ngayVao': ngayVao,
    'ngayRa': ngayRa, 'dangThue': dangThue ? 1 : 0, 'ghiChu': ghiChu, 'ngayTao': ngayTao
  };

  factory KhachThue.fromMap(Map<String, dynamic> map) => KhachThue(
    id: map['id'],
    phongId: map['phongId'],
    hoTen: map['hoTen'],
    cccd: map['cccd'],
    soDienThoai: map['soDienThoai'],
    email: map['email'],
    queQuan: map['queQuan'],
    ngheNghiep: map['ngheNghiep'],
    ngayVao: map['ngayVao'] ?? 0,
    ngayRa: map['ngayRa'],
    dangThue: map['dangThue'] == 1,
    ghiChu: map['ghiChu'],
    ngayTao: map['ngayTao'] ?? 0,
  );
}
