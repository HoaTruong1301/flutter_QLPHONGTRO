import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/khach_thue_model.dart';
import '../../models/phong_model.dart';
import '../../providers/khach_thue_provider.dart';
import '../../providers/phong_provider.dart';
import '../../utils/format_utils.dart';

class ThemKhachThueScreen extends StatefulWidget {
  final KhachThue? khach;
  const ThemKhachThueScreen({super.key, this.khach});

  @override
  State<ThemKhachThueScreen> createState() => _ThemKhachThueScreenState();
}

class _ThemKhachThueScreenState extends State<ThemKhachThueScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _hoTenController;
  late TextEditingController _sdtController;
  late TextEditingController _cccdController;
  late TextEditingController _ngayVaoController;
  int? _selectedPhongId;
  int _selectedNgayVao = DateTime.now().millisecondsSinceEpoch;

  @override
  void initState() {
    super.initState();
    _hoTenController = TextEditingController(text: widget.khach?.hoTen ?? "");
    _sdtController = TextEditingController(text: widget.khach?.soDienThoai ?? "");
    _cccdController = TextEditingController(text: widget.khach?.cccd ?? "");
    _selectedNgayVao = widget.khach?.ngayVao ?? DateTime.now().millisecondsSinceEpoch;
    _ngayVaoController = TextEditingController(text: FormatUtils.formatDate(_selectedNgayVao));
    _selectedPhongId = widget.khach?.phongId;
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PhongProvider>().fetchPhong();
    });
  }

  @override
  Widget build(BuildContext context) {
    final phongProvider = context.watch<PhongProvider>();
    final availablePhongs = phongProvider.allPhong.where((p) => 
      p.trangThai == Phong.TRANG_THAI_TRONG || p.id == widget.khach?.phongId
    ).toList();

    return Scaffold(
      appBar: AppBar(title: Text(widget.khach == null ? "Thêm khách mới" : "Sửa khách thuê")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<int>(
                value: _selectedPhongId,
                isExpanded: true,
                decoration: const InputDecoration(labelText: "Gán vào phòng trống", border: OutlineInputBorder()),
                items: availablePhongs.isEmpty 
                  ? [const DropdownMenuItem(value: null, child: Text("Không có phòng trống nào"))]
                  : availablePhongs.map((p) => DropdownMenuItem(
                      value: p.id,
                      child: Text("Phòng ${p.soPhong} - ${FormatUtils.formatCurrency(p.giaThue)}"),
                    )).toList(),
                onChanged: (val) => setState(() => _selectedPhongId = val),
              ),
              if (availablePhongs.isEmpty) 
                const Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text("Cần tạo thêm phòng mới ở trạng thái 'Trống' trước.", style: TextStyle(color: Colors.red, fontSize: 12)),
                ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _hoTenController,
                decoration: const InputDecoration(labelText: "Họ và tên khách thuê", border: OutlineInputBorder()),
                validator: (v) => v!.isEmpty ? "Vui lòng nhập họ tên" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _sdtController,
                decoration: const InputDecoration(labelText: "Số điện thoại", border: OutlineInputBorder()),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cccdController,
                decoration: const InputDecoration(labelText: "Số CCCD", border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _ngayVaoController,
                decoration: const InputDecoration(labelText: "Ngày vào ở", border: OutlineInputBorder(), suffixIcon: Icon(Icons.calendar_today)),
                readOnly: true,
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.fromMillisecondsSinceEpoch(_selectedNgayVao),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setState(() {
                      _selectedNgayVao = picked.millisecondsSinceEpoch;
                      _ngayVaoController.text = FormatUtils.formatDate(_selectedNgayVao);
                    });
                  }
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                onPressed: _save,
                child: const Text("LƯU KHÁCH THUÊ"),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final khach = KhachThue(
        id: widget.khach?.id,
        phongId: _selectedPhongId,
        hoTen: _hoTenController.text,
        soDienThoai: _sdtController.text,
        cccd: _cccdController.text,
        ngayVao: _selectedNgayVao,
        ngayTao: widget.khach?.ngayTao ?? DateTime.now().millisecondsSinceEpoch,
      );
      if (widget.khach == null) {
        context.read<KhachThueProvider>().addKhach(khach);
      } else {
        context.read<KhachThueProvider>().updateKhach(khach);
      }
      Navigator.pop(context);
    }
  }
}
