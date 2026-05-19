import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/phong_provider.dart';
import '../../providers/khach_thue_provider.dart';
import '../../providers/hop_dong_provider.dart';
import '../../models/hop_dong_model.dart';
import '../../models/phong_model.dart';
import '../../utils/format_utils.dart';

class TaoHopDongScreen extends StatefulWidget {
  const TaoHopDongScreen({super.key});

  @override
  State<TaoHopDongScreen> createState() => _TaoHopDongScreenState();
}

class _TaoHopDongScreenState extends State<TaoHopDongScreen> {
  final _formKey = GlobalKey<FormState>();
  int? _selectedPhongId;
  int? _selectedKhachId;
  final _giaThueController = TextEditingController();
  final _tienCocController = TextEditingController();
  final _noiDungController = TextEditingController();
  
  DateTime _ngayBatDau = DateTime.now();
  DateTime _ngayKetThuc = DateTime.now().add(const Duration(days: 365));

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PhongProvider>().fetchPhong();
      context.read<KhachThueProvider>().fetchKhach();
    });
  }

  @override
  Widget build(BuildContext context) {
    final phongProvider = context.watch<PhongProvider>();
    final khachProvider = context.watch<KhachThueProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Tạo hợp đồng mới")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(labelText: "Chọn phòng", border: OutlineInputBorder()),
                items: phongProvider.allPhong.map((p) => DropdownMenuItem(
                  value: p.id,
                  child: Text("Phòng ${p.soPhong}"),
                )).toList(),
                onChanged: (val) {
                  setState(() {
                    _selectedPhongId = val;
                    final p = phongProvider.allPhong.firstWhere((e) => e.id == val);
                    _giaThueController.text = p.giaThue.toInt().toString();
                    _tienCocController.text = p.giaThue.toInt().toString(); // Mặc định cọc 1 tháng
                  });
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(labelText: "Chọn khách thuê", border: OutlineInputBorder()),
                items: khachProvider.filteredKhach.map((k) => DropdownMenuItem(
                  value: k.id,
                  child: Text(k.hoTen),
                )).toList(),
                onChanged: (val) => setState(() => _selectedKhachId = val),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _giaThueController,
                      decoration: const InputDecoration(labelText: "Giá thuê", border: OutlineInputBorder()),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _tienCocController,
                      decoration: const InputDecoration(labelText: "Tiền cọc", border: OutlineInputBorder()),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text("Ngày bắt đầu"),
                subtitle: Text(FormatUtils.formatDate(_ngayBatDau.millisecondsSinceEpoch)),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _ngayBatDau,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) setState(() => _ngayBatDau = picked);
                },
              ),
              ListTile(
                title: const Text("Ngày kết thúc"),
                subtitle: Text(FormatUtils.formatDate(_ngayKetThuc.millisecondsSinceEpoch)),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _ngayKetThuc,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) setState(() => _ngayKetThuc = picked);
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _noiDungController,
                decoration: const InputDecoration(labelText: "Ghi chú hợp đồng", border: OutlineInputBorder()),
                maxLines: 3,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
                onPressed: _save,
                child: const Text("LƯU HỢP ĐỒNG"),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _save() async {
    if (_formKey.currentState!.validate() && _selectedPhongId != null && _selectedKhachId != null) {
      final hd = HopDong(
        phongId: _selectedPhongId!,
        khachThueId: _selectedKhachId!,
        giaThue: double.parse(_giaThueController.text),
        tienCoc: double.parse(_tienCocController.text),
        ngayBatDau: FormatUtils.formatDate(_ngayBatDau.millisecondsSinceEpoch),
        ngayKetThuc: FormatUtils.formatDate(_ngayKetThuc.millisecondsSinceEpoch),
        noiDung: _noiDungController.text,
        trangThai: "Đang hiệu lực",
        ngayTao: DateTime.now().millisecondsSinceEpoch,
      );
      await context.read<HopDongProvider>().addHopDong(hd);
      Navigator.pop(context);
    }
  }
}
