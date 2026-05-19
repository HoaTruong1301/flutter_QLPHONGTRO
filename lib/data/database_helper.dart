import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/phong_model.dart';
import '../models/khach_thue_model.dart';
import '../models/hoa_don_model.dart';
import '../models/thu_chi_model.dart';
import '../models/hop_dong_model.dart';
import '../models/dich_vu_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('quan_ly_tro.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    return await openDatabase(
      join(dbPath, filePath), 
      version: 5, 
      onCreate: _createDB, 
      onConfigure: (db) async => await db.execute('PRAGMA foreign_keys = ON'),
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 5) {
          await db.execute('DROP TABLE IF EXISTS phong');
          await db.execute('DROP TABLE IF EXISTS khach_thue');
          await db.execute('DROP TABLE IF EXISTS hoa_don');
          await db.execute('DROP TABLE IF EXISTS thu_chi');
          await db.execute('DROP TABLE IF EXISTS dich_vu');
          await db.execute('DROP TABLE IF EXISTS hop_dong');
          await _createDB(db, newVersion);
        }
      }
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('CREATE TABLE phong (id INTEGER PRIMARY KEY AUTOINCREMENT, soPhong TEXT, loaiPhong TEXT, giaThue REAL, dienTich REAL, trangThai TEXT, moTa TEXT, ngayTao INTEGER)');
    await db.execute('CREATE TABLE khach_thue (id INTEGER PRIMARY KEY AUTOINCREMENT, phongId INTEGER, hoTen TEXT, cccd TEXT, soDienThoai TEXT, email TEXT, queQuan TEXT, ngheNghiep TEXT, ngayVao INTEGER, ngayRa INTEGER, dangThue INTEGER, ghiChu TEXT, ngayTao INTEGER, FOREIGN KEY(phongId) REFERENCES phong(id) ON DELETE SET NULL)');
    await db.execute('CREATE TABLE hoa_don (id INTEGER PRIMARY KEY AUTOINCREMENT, phongId INTEGER, khachThueId INTEGER, thangNam TEXT, tienPhong REAL, tongTienDichVu REAL, tongTien REAL, trangThai TEXT, ngayTao INTEGER, ngayThanhToan INTEGER, ghiChu TEXT, FOREIGN KEY(phongId) REFERENCES phong(id) ON DELETE CASCADE)');
    await db.execute('CREATE TABLE thu_chi (id INTEGER PRIMARY KEY AUTOINCREMENT, loai TEXT, danhMuc TEXT, soTien REAL, moTa TEXT, ngayGiaoDich INTEGER, phongId INTEGER, ngayTao INTEGER, FOREIGN KEY(phongId) REFERENCES phong(id) ON DELETE SET NULL)');
    await db.execute('CREATE TABLE dich_vu (id INTEGER PRIMARY KEY AUTOINCREMENT, tenDichVu TEXT, donGia REAL, donViTinh TEXT, batBuoc INTEGER, tinhTheoChiso INTEGER)');
    await db.execute('CREATE TABLE hop_dong (id INTEGER PRIMARY KEY AUTOINCREMENT, phongId INTEGER, khachThueId INTEGER, ngayBatDau TEXT, ngayKetThuc TEXT, tienCoc REAL, giaThue REAL, noiDung TEXT, trangThai TEXT, ngayTao INTEGER, FOREIGN KEY(phongId) REFERENCES phong(id) ON DELETE CASCADE, FOREIGN KEY(khachThueId) REFERENCES khach_thue(id) ON DELETE CASCADE)');

    // Dữ liệu mẫu
    int now = DateTime.now().millisecondsSinceEpoch;
    await db.insert('phong', {'soPhong': '101', 'loaiPhong': 'Phòng đơn', 'giaThue': 2500000.0, 'dienTich': 20.0, 'trangThai': 'Trống', 'moTa': 'Tầng 1', 'ngayTao': now});
    await db.insert('phong', {'soPhong': '102', 'loaiPhong': 'Phòng đôi', 'giaThue': 3500000.0, 'dienTich': 35.0, 'trangThai': 'Đang thuê', 'moTa': 'Tầng 1', 'ngayTao': now});
  }

  // --- GENERIC QUERIES ---
  Future<int> update(String table, Map<String, dynamic> values, {String? where, List<Object?>? whereArgs}) async {
    final db = await database;
    return await db.update(table, values, where: where, whereArgs: whereArgs);
  }

  Future<int> delete(String table, {String? where, List<Object?>? whereArgs}) async {
    final db = await database;
    return await db.delete(table, where: where, whereArgs: whereArgs);
  }

  // --- QUERIES ---
  Future<int> insertPhong(Phong p) async => (await database).insert('phong', p.toMap());
  Future<int> updatePhong(Phong p) async => (await database).update('phong', p.toMap(), where: 'id = ?', whereArgs: [p.id]);
  Future<int> deletePhong(int id) async => (await database).delete('phong', where: 'id = ?', whereArgs: [id]);
  Future<List<Phong>> getAllPhong() async {
    final db = await database;
    final res = await db.query('phong', orderBy: 'soPhong ASC');
    return res.map((e) => Phong.fromMap(e)).toList();
  }

  Future<int> insertKhachThue(KhachThue k) async => (await database).insert('khach_thue', k.toMap());
  Future<int> updateKhachThue(KhachThue k) async => (await database).update('khach_thue', k.toMap(), where: 'id = ?', whereArgs: [k.id]);
  Future<int> deleteKhachThue(int id) async => (await database).delete('khach_thue', where: 'id = ?', whereArgs: [id]);
  Future<List<KhachThue>> getAllKhachThue() async {
    final db = await database;
    final res = await db.query('khach_thue', orderBy: 'hoTen ASC');
    return res.map((e) => KhachThue.fromMap(e)).toList();
  }

  Future<int> insertHoaDon(HoaDon hd) async => (await database).insert('hoa_don', hd.toMap());
  Future<List<HoaDon>> getAllHoaDon() async {
    final db = await database;
    final res = await db.query('hoa_don', orderBy: 'ngayTao DESC');
    return res.map((e) => HoaDon.fromMap(e)).toList();
  }

  Future<int> insertThuChi(ThuChi tc) async => (await database).insert('thu_chi', tc.toMap());
  Future<List<ThuChi>> getAllThuChi() async {
    final db = await database;
    final res = await db.query('thu_chi', orderBy: 'ngayGiaoDich DESC');
    return res.map((e) => ThuChi.fromMap(e)).toList();
  }

  // --- HOP DONG ---
  Future<int> insertHopDong(HopDong hd) async => (await database).insert('hop_dong', hd.toMap());
  Future<List<HopDong>> getAllHopDong() async {
    final db = await database;
    final res = await db.query('hop_dong', orderBy: 'ngayTao DESC');
    return res.map((e) => HopDong.fromMap(e)).toList();
  }
  Future<int> deleteHopDong(int id) async => (await database).delete('hop_dong', where: 'id = ?', whereArgs: [id]);

  // --- STATS ---
  Future<Map<String, int>> getStats() async {
    final db = await database;
    int tong = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM phong')) ?? 0;
    int trong = Sqflite.firstIntValue(await db.rawQuery("SELECT COUNT(*) FROM phong WHERE trangThai = 'Trống'")) ?? 0;
    int thue = Sqflite.firstIntValue(await db.rawQuery("SELECT COUNT(*) FROM phong WHERE trangThai = 'Đang thuê'")) ?? 0;
    int no = Sqflite.firstIntValue(await db.rawQuery("SELECT COUNT(*) FROM hoa_don WHERE trangThai = 'Chưa thanh toán'")) ?? 0;
    return {'tong': tong, 'trong': trong, 'thue': thue, 'no': no};
  }

  Future<double> getDoanhThuThang(String thangNam) async {
    final db = await database;
    final res = await db.rawQuery("SELECT SUM(tongTien) as total FROM hoa_don WHERE thangNam = ? AND trangThai = 'Đã thanh toán'", [thangNam]);
    return (res.first['total'] as num?)?.toDouble() ?? 0.0;
  }

  Future<double> getTongThu() async {
    final db = await database;
    final res = await db.rawQuery("SELECT SUM(soTien) as total FROM thu_chi WHERE loai = 'THU'");
    return (res.first['total'] as num?)?.toDouble() ?? 0.0;
  }

  Future<double> getTongChi() async {
    final db = await database;
    final res = await db.rawQuery("SELECT SUM(soTien) as total FROM thu_chi WHERE loai = 'CHI'");
    return (res.first['total'] as num?)?.toDouble() ?? 0.0;
  }
}
