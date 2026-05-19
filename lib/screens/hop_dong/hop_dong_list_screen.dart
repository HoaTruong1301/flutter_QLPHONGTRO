import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/hop_dong_provider.dart';
import '../../providers/phong_provider.dart';
import '../../providers/khach_thue_provider.dart';
import '../../utils/format_utils.dart';
import '../../utils/pdf_export_utils.dart';
import '../../models/hop_dong_model.dart';
import 'tao_hop_dong_screen.dart';

class HopDongListScreen extends StatefulWidget {
  const HopDongListScreen({super.key});

  @override
  State<HopDongListScreen> createState() => _HopDongListScreenState();
}

class _HopDongListScreenState extends State<HopDongListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HopDongProvider>().fetchHopDong();
      context.read<PhongProvider>().fetchPhong();
      context.read<KhachThueProvider>().fetchKhach();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HopDongProvider>();
    final phongProvider = context.watch<PhongProvider>();
    final khachProvider = context.watch<KhachThueProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Quản lý hợp đồng", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: provider.allHopDong.isEmpty
          ? const Center(child: Text("Chưa có hợp đồng nào"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: provider.allHopDong.length,
              itemBuilder: (context, index) {
                final hd = provider.allHopDong[index];
                final phong = phongProvider.allPhong.where((p) => p.id == hd.phongId).firstOrNull;
                final khach = khachProvider.filteredKhach.where((k) => k.id == hd.khachThueId).firstOrNull;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Phòng ${phong?.soPhong ?? hd.phongId}", 
                                 style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                            Text(hd.ngayBatDau ?? "", style: const TextStyle(color: Colors.grey)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text("Khách thuê: ${khach?.hoTen ?? '---'}", style: const TextStyle(fontSize: 16)),
                        const Divider(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Giá thuê: ${FormatUtils.formatCurrency(hd.giaThue)}"),
                            Text("Cọc: ${FormatUtils.formatCurrency(hd.tienCoc)}"),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            OutlinedButton.icon(
                              onPressed: () {
                                if (phong != null && khach != null) {
                                  PdfExportUtils.generateContract(hd, phong, khach, "Chủ trọ Admin");
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Dữ liệu phòng hoặc khách không hợp lệ"))
                                  );
                                }
                              },
                              icon: const Icon(Icons.picture_as_pdf),
                              label: const Text("XUẤT PDF"),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.red),
                              onPressed: () => _confirmDelete(context, hd.id!),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TaoHopDongScreen())),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _confirmDelete(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Xóa hợp đồng"),
        content: const Text("Bạn có chắc muốn xóa hợp đồng này không?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("HỦY")),
          TextButton(
            onPressed: () {
              context.read<HopDongProvider>().deleteHopDong(id);
              Navigator.pop(context);
            },
            child: const Text("XÓA", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
