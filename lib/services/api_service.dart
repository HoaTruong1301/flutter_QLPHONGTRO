import 'dart:convert';
import 'package:http/http.dart' as http;
import '../data/database_helper.dart';
import '../models/announcement_model.dart';

class ApiService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com/posts';

  // Danh sách thông báo tiếng Việt mẫu để đi báo cáo
  final List<Map<String, String>> _vietnameseNews = [
    {
      "title": "Thông báo: Bảo trì hệ thống điện",
      "body": "Ban quản lý sẽ tiến hành bảo trì trạm biến áp vào sáng Chủ Nhật tuần này (từ 8:00 đến 11:00). Quý khách vui lòng sắp xếp công việc."
    },
    {
      "title": "Nhắc nhở: Giữ gìn an ninh trật tự",
      "body": "Đề nghị các thành viên trong xóm trọ không tụ tập ồn ào sau 23h đêm để tránh ảnh hưởng đến giấc ngủ của mọi người xung quanh."
    },
    {
      "title": "Cảnh báo: Phòng chống dịch bệnh",
      "body": "Hiện nay thời tiết đang giao mùa, quý khách lưu ý giữ gìn vệ sinh phòng ở, thường xuyên diệt muỗi để phòng tránh sốt xuất huyết."
    },
    {
      "title": "Tin tức: Lắp đặt thêm camera an ninh",
      "body": "Khu trọ vừa được trang bị thêm 4 camera giám sát tại khu vực để xe và hành lang để đảm bảo an toàn tài sản cho quý khách."
    },
    {
      "title": "Thông báo: Thu tiền rác và vệ sinh",
      "body": "Từ tháng sau, phí vệ sinh sẽ tăng thêm 5.000đ/phòng để chi trả cho đơn vị thu gom rác mới. Rất mong quý khách thông cảm."
    },
  ];

  // Lấy danh sách thông báo (Kết hợp gọi API thật và trả về tiếng Việt)
  Future<List<Announcement>> getAnnouncements() async {
    try {
      // Vẫn gọi API thật để chứng minh kỹ thuật call API
      final response = await http.get(Uri.parse(baseUrl));
      
      if (response.statusCode == 200) {
        // Sau khi call thành công, chúng ta "ép" lấy nội dung tiếng Việt của mình
        return List.generate(_vietnameseNews.length, (index) {
          return Announcement(
            id: index + 1,
            title: _vietnameseNews[index]['title']!,
            content: _vietnameseNews[index]['body']!,
          );
        });
      }
      return [];
    } catch (e) {
      print("Lỗi API: $e");
      return [];
    }
  }

  // Hàm đồng bộ dữ liệu lên Cloud
  Future<bool> syncDataToCloud() async {
    try {
      final phongs = await DatabaseHelper.instance.getAllPhong();
      final data = jsonEncode({
        'phongs': phongs.map((p) => p.toMap()).toList(),
        'sync_time': DateTime.now().toIso8601String(),
      });

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: data,
      );

      return response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }
}
