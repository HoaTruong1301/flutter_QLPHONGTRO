import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/thu_chi_provider.dart';
import '../../utils/format_utils.dart';
import '../../models/thu_chi_model.dart';
import 'them_thu_chi_screen.dart';

class ThuChiListScreen extends StatefulWidget {
  const ThuChiListScreen({super.key});

  @override
  State<ThuChiListScreen> createState() => _ThuChiListScreenState();
}

class _ThuChiListScreenState extends State<ThuChiListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ThuChiProvider>().fetchThuChi();
    });
  }

  // Hàm lấy icon phù hợp cho từng danh mục
  IconData _getCategoryIcon(String category) {
    switch (category) {
      case "Tiền thuê nhà": return Icons.home_rounded;
      case "Tiền cọc": return Icons.vpn_key_rounded;
      case "Sửa chữa": return Icons.build_rounded;
      case "Điện nước": return Icons.electric_bolt_rounded;
      case "Internet": return Icons.wifi_rounded;
      default: return Icons.category_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ThuChiProvider>();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Lịch sử giao dịch", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Header tóm tắt Số dư
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.green[700]!, Colors.green[400]!]),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.green.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))],
            ),
            child: Column(
              children: [
                const Text("SỔ THU CHI", style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(FormatUtils.formatCurrency(provider.soDu), 
                     style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildMiniStats("Tổng thu", provider.tongThu, Colors.white),
                    Container(width: 1, height: 30, color: Colors.white24),
                    _buildMiniStats("Tổng chi", provider.tongChi, Colors.white),
                  ],
                )
              ],
            ),
          ),
          
          // Bộ lọc Tab
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _filterChip(provider, "Tất cả", ""),
                const SizedBox(width: 8),
                _filterChip(provider, "Khoản thu", "THU"),
                const SizedBox(width: 8),
                _filterChip(provider, "Khoản chi", "CHI"),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // DANH SÁCH LỊCH SỬ
          Expanded(
            child: provider.filteredThuChi.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.history_rounded, size: 64, color: Colors.grey[300]),
                        const SizedBox(height: 16),
                        const Text("Chưa có lịch sử giao dịch nào"),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: provider.filteredThuChi.length,
                    itemBuilder: (context, index) {
                      final item = provider.filteredThuChi[index];
                      final isThu = item.loai == "THU";
                      
                      return Card(
                        elevation: 0,
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(color: Colors.grey.withOpacity(0.1))
                        ),
                        child: ListTile(
                          onLongPress: () => _confirmDelete(context, item), // Thêm sự kiện nhấn giữ
                          contentPadding: const EdgeInsets.all(12),
                          leading: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: (isThu ? Colors.green : Colors.red).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(_getCategoryIcon(item.danhMuc), 
                                        color: isThu ? Colors.green : Colors.red),
                          ),
                          title: Text(item.danhMuc, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (item.moTa != null && item.moTa!.isNotEmpty)
                                Text(item.moTa!, style: const TextStyle(fontSize: 12)),
                              Text(FormatUtils.formatDate(item.ngayGiaoDich), 
                                   style: TextStyle(color: Colors.grey[400], fontSize: 11)),
                            ],
                          ),
                          trailing: Text(
                            "${isThu ? '+' : '-'}${FormatUtils.formatCurrency(item.soTien)}",
                            style: TextStyle(
                              color: isThu ? Colors.green[700] : Colors.red[700], 
                              fontWeight: FontWeight.bold,
                              fontSize: 16
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ThemThuChiScreen())),
        label: const Text("Ghi chép"),
        icon: const Icon(Icons.edit_note_rounded),
      ),
    );
  }

  void _confirmDelete(BuildContext context, ThuChi item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Xóa giao dịch"),
        content: Text("Bạn có muốn xóa giao dịch '${item.danhMuc}' này không?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("HỦY")),
          TextButton(
            onPressed: () {
              context.read<ThuChiProvider>().deleteThuChi(item.id!);
              Navigator.pop(context);
            },
            child: const Text("XÓA", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(ThuChiProvider provider, String label, String value) {
    final isSelected = provider.filteredThuChi.any((element) => element.loai == value) || (value == "" && provider.filteredThuChi.length == provider.filteredThuChi.length); // Placeholder logic
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (val) => provider.setFilter(value),
    );
  }

  Widget _buildMiniStats(String label, double value, Color color) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: color.withOpacity(0.7), fontSize: 11)),
        Text(FormatUtils.formatCurrency(value), 
             style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 14)),
      ],
    );
  }
}
