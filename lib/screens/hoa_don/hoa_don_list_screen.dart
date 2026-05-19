import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/hoa_don_provider.dart';
import '../../providers/phong_provider.dart';
import '../../providers/thu_chi_provider.dart';
import '../../providers/khach_thue_provider.dart';
import '../../models/hoa_don_model.dart';
import '../../utils/format_utils.dart';
import '../../utils/pdf_export_utils.dart';
import '../../utils/bank_qr_utils.dart';
import 'tao_hoa_don_screen.dart';

class HoaDonListScreen extends StatefulWidget {
  const HoaDonListScreen({super.key});

  @override
  _HoaDonListScreenState createState() => _HoaDonListScreenState();
}

class _HoaDonListScreenState extends State<HoaDonListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HoaDonProvider>().fetchHoaDon();
      context.read<PhongProvider>().fetchPhong();
      context.read<KhachThueProvider>().fetchKhach();
    });
  }

  void _showBankQrDialog(BuildContext context, HoaDon hd, String tenPhong) {
    final qrUrl = BankQrUtils.generateQrUrl(
      amount: hd.tongTien,
      roomName: tenPhong,
      period: hd.thangNam ?? "",
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Center(child: Text("Quét mã chuyển khoản")),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade200),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  qrUrl,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Padding(
                      padding: EdgeInsets.all(40.0),
                      child: CircularProgressIndicator(),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => 
                    const Icon(Icons.broken_image_outlined, size: 100, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(FormatUtils.formatCurrency(hd.tongTien), 
                 style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)),
            const SizedBox(height: 8),
            Text("Chủ TK: ${BankQrUtils.accountName}", style: const TextStyle(fontSize: 13)),
            Text("STK: ${BankQrUtils.accountNo} (${BankQrUtils.bankId})", style: const TextStyle(fontSize: 13, color: Colors.grey)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: const Text("ĐÓNG")
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HoaDonProvider>();
    final phongProvider = context.watch<PhongProvider>();
    final khachProvider = context.watch<KhachThueProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Lịch sử hóa đơn", style: TextStyle(fontWeight: FontWeight.bold))),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                _buildFilterChip(provider, "Tất cả", ""),
                const SizedBox(width: 8),
                _buildFilterChip(provider, "Chưa thu", HoaDon.CHUA_THANH_TOAN),
                const SizedBox(width: 8),
                _buildFilterChip(provider, "Đã thu", HoaDon.DA_THANH_TOAN),
              ],
            ),
          ),
          Expanded(
            child: provider.filteredHoaDon.isEmpty
                ? const Center(child: Text("Chưa có hóa đơn nào"))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: provider.filteredHoaDon.length,
                    itemBuilder: (context, index) {
                      final hd = provider.filteredHoaDon[index];
                      final phong = phongProvider.allPhong.where((p) => p.id == hd.phongId).firstOrNull;
                      final tenPhong = phong != null ? "Phòng ${phong.soPhong}" : "Phòng ${hd.phongId}";
                      
                      final khach = khachProvider.filteredKhach.where((k) => k.id == hd.khachThueId).firstOrNull;
                      final tenKhach = khach?.hoTen ?? "---";
                      
                      return _buildHoaDonItem(context, hd, tenPhong, tenKhach);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TaoHoaDonScreen())),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildFilterChip(HoaDonProvider provider, String label, String value) {
    return ChoiceChip(
      label: Text(label),
      selected: provider.filter == value,
      onSelected: (val) => provider.setFilter(value),
    );
  }

  Widget _buildHoaDonItem(BuildContext context, HoaDon hd, String tenPhong, String tenKhach) {
    final isPaid = hd.trangThai == HoaDon.DA_THANH_TOAN;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(tenPhong, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text("Khách: $tenKhach", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
                Text(hd.thangNam ?? "", style: const TextStyle(color: Colors.grey)),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Tổng tiền:", style: TextStyle(fontSize: 14)),
                Text(FormatUtils.formatCurrency(hd.tongTien), 
                     style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 18)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // NÚT MÃ QR MỚI
                IconButton(
                  onPressed: () => _showBankQrDialog(context, hd, tenPhong),
                  icon: const Icon(Icons.qr_code_2, color: Colors.blue),
                  tooltip: "Mã QR thanh toán",
                ),
                const SizedBox(width: 4),
                OutlinedButton.icon(
                  onPressed: () => PdfExportUtils.generateInvoicePdf(hd, tenPhong, tenKhach),
                  icon: const Icon(Icons.picture_as_pdf, size: 18),
                  label: const Text("XUẤT PDF"),
                ),
                const SizedBox(width: 8),
                if (!isPaid)
                  ElevatedButton(
                    onPressed: () async {
                      await context.read<HoaDonProvider>().thanhToan(hd);
                      if (context.mounted) {
                        context.read<ThuChiProvider>().fetchThuChi();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Đã thu tiền và cập nhật vào Thu Chi"))
                        );
                      }
                    },
                    child: const Text("XÁC NHẬN"),
                  ),
                if (isPaid)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                    child: const Text("✅ Đã thu", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
