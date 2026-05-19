import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/phong_provider.dart';
import '../../providers/hoa_don_provider.dart';
import '../../models/hoa_don_model.dart';
import '../../models/phong_model.dart';
import '../../utils/format_utils.dart';

class TaoHoaDonScreen extends StatefulWidget {
  const TaoHoaDonScreen({super.key});

  @override
  _TaoHoaDonScreenState createState() => _TaoHoaDonScreenState();
}

class _TaoHoaDonScreenState extends State<TaoHoaDonScreen> {
  int? _selectedPhongId;
  double _giaPhong = 0;
  final _dienController = TextEditingController();
  final _nuocController = TextEditingController();
  double _tongTien = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PhongProvider>().fetchPhong();
    });
  }

  void _calculate() {
    double dien = double.tryParse(_dienController.text) ?? 0;
    double nuoc = double.tryParse(_nuocController.text) ?? 0;
    setState(() {
      _tongTien = _giaPhong + (dien * 3500) + (nuoc * 15000) + 20000;
    });
  }

  @override
  Widget build(BuildContext context) {
    final phongProvider = context.watch<PhongProvider>();
    final phongs = phongProvider.allPhong.where((p) => p.trangThai == Phong.TRANG_THAI_DANG_THUE).toList();

    return Scaffold(
      appBar: AppBar(title: Text("Tạo hóa đơn tháng ${FormatUtils.getCurrentMonthYear()}")),
      body: phongs.isEmpty 
          ? Center(child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: const Text("Hiện không có phòng nào đang ở trạng thái 'Đang thuê'. Hãy thêm khách vào phòng trước.", textAlign: TextAlign.center),
            ))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<int>(
                    value: _selectedPhongId,
                    isExpanded: true,
                    decoration: const InputDecoration(labelText: "Chọn phòng để tính tiền", border: OutlineInputBorder()),
                    items: phongs.map((p) => DropdownMenuItem(
                      value: p.id, 
                      child: Text("Phòng ${p.soPhong} - ${FormatUtils.formatCurrency(p.giaThue)}"))
                    ).toList(),
                    onChanged: (val) {
                      final p = phongs.firstWhere((element) => element.id == val);
                      setState(() {
                        _selectedPhongId = val;
                        _giaPhong = p.giaThue;
                        _calculate();
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text("Chỉ số điện nước", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(child: TextField(
                        controller: _dienController,
                        decoration: const InputDecoration(labelText: "Số điện (kWh)", border: OutlineInputBorder()),
                        keyboardType: TextInputType.number,
                        onChanged: (_) => _calculate(),
                      )),
                      const SizedBox(width: 12),
                      Expanded(child: TextField(
                        controller: _nuocController,
                        decoration: const InputDecoration(labelText: "Số nước (m³)", border: OutlineInputBorder()),
                        keyboardType: TextInputType.number,
                        onChanged: (_) => _calculate(),
                      )),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: Colors.blue.withOpacity(0.05), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.blue.withOpacity(0.2))),
                    child: Column(
                      children: [
                        _rowInfo("Giá phòng", FormatUtils.formatCurrency(_giaPhong)),
                        _rowInfo("Phí rác", "20,000 đ"),
                        const Divider(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("TỔNG CỘNG", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                            Text(FormatUtils.formatCurrency(_tongTien), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.blue)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    onPressed: _save,
                    child: const Text("XÁC NHẬN LƯU HÓA ĐƠN"),
                  )
                ],
              ),
            ),
    );
  }

  Widget _rowInfo(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(label), Text(value)]),
  );

  void _save() async {
    if (_selectedPhongId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Vui lòng chọn phòng")));
      return;
    }
    final hd = HoaDon(
      phongId: _selectedPhongId!,
      thangNam: FormatUtils.getCurrentMonthYear(),
      tienPhong: _giaPhong,
      tongTienDichVu: _tongTien - _giaPhong,
      tongTien: _tongTien,
      trangThai: HoaDon.CHUA_THANH_TOAN,
      ngayTao: DateTime.now().millisecondsSinceEpoch,
    );
    await context.read<HoaDonProvider>().insertHoaDon(hd);
    Navigator.pop(context);
  }
}
