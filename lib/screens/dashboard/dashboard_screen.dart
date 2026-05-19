import 'package:flutter/material.dart';
import '../../data/database_helper.dart';
import '../../utils/format_utils.dart';
import '../../services/api_service.dart';
import '../../services/auth_service.dart';
import '../../models/announcement_model.dart';
import '../auth/login_screen.dart';
import '../hop_dong/hop_dong_list_screen.dart';
import '../hoa_don/tao_hoa_don_screen.dart';
import '../phong/phong_list_screen.dart';
import '../khach_thue/khach_thue_list_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Map<String, int> _stats = {'tong': 0, 'trong': 0, 'thue': 0, 'no': 0};
  double _doanhThu = 0;
  bool _isLoading = true;
  List<Announcement> _announcements = [];
  final _apiService = ApiService();
  final _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final stats = await DatabaseHelper.instance.getStats();
      final doanhThu = await DatabaseHelper.instance.getDoanhThuThang(FormatUtils.getCurrentMonthYear());
      final news = await _apiService.getAnnouncements();
      if (mounted) {
        setState(() {
          _stats = stats;
          _doanhThu = doanhThu;
          _announcements = news;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _handleLogout() async {
    await _authService.logout();
    if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
  }

  void _handleSync() async {
    showDialog(context: context, builder: (context) => const Center(child: CircularProgressIndicator()));
    final success = await _apiService.syncDataToCloud();
    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(success ? "Đã gửi dữ liệu lên Server thành công!" : "Lỗi kết nối Server!")));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("QL PHÒNG TRỌ", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: const Icon(Icons.cloud_upload_outlined, color: Colors.blue), onPressed: _handleSync),
          IconButton(icon: const Icon(Icons.logout_rounded, color: Colors.red), onPressed: _handleLogout),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Báo cáo hôm nay", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              
              GridView.count(
                shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 1.3,
                children: [
                  _buildStatCard("TỔNG PHÒNG", _stats['tong'].toString(), Colors.blue),
                  _buildStatCard("PHÒNG TRỐNG", _stats['trong'].toString(), Colors.green),
                  _buildStatCard("ĐANG THUÊ", _stats['thue'].toString(), Colors.orange),
                  _buildStatCard("CHƯA THU TIỀN", _stats['no'].toString(), Colors.red),
                ],
              ),
              const SizedBox(height: 16),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Colors.blue[700]!, Colors.blue[400]!]),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.blue.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Tổng doanh thu tháng này", style: TextStyle(color: Colors.white70, fontSize: 14)),
                    const SizedBox(height: 8),
                    Text(FormatUtils.formatCurrency(_doanhThu), 
                         style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text("Cập nhật: ${FormatUtils.getCurrentMonthYear()}", style: const TextStyle(color: Colors.white60, fontSize: 12)),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),

              const Text("Thao tác nhanh", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildQuickActionButton(Icons.assignment_rounded, "Hợp đồng", Colors.purple, () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const HopDongListScreen()));
                  }),
                  _buildQuickActionButton(Icons.post_add_rounded, "Tạo hóa đơn", Colors.orange, () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const TaoHoaDonScreen()));
                  }),
                  _buildQuickActionButton(Icons.refresh_rounded, "Làm mới", Colors.grey, _loadData),
                ],
              ),
              
              const SizedBox(height: 24),
              
              const Text("Bản tin thông báo", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              _announcements.isEmpty 
                ? const Text("Không có thông báo mới")
                : Column(
                    children: _announcements.map((news) => Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: const Icon(Icons.info_outline, color: Colors.blue),
                        title: Text(news.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(news.content, maxLines: 2, overflow: TextOverflow.ellipsis),
                        onTap: () => _showNewsDetail(news),
                      ),
                    )).toList(),
                  ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionButton(IconData icon, String label, Color color, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Container(
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 11)),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(color: color, fontSize: 28, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void _showNewsDetail(Announcement news) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(news.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text(news.content, style: const TextStyle(fontSize: 16, height: 1.5)),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text("ĐÃ ĐỌC"))
          ],
        ),
      ),
    );
  }
}
