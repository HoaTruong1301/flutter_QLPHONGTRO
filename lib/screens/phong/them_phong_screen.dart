import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/phong_model.dart';
import '../../providers/phong_provider.dart';

class ThemPhongScreen extends StatefulWidget {
  final Phong? phong;
  const ThemPhongScreen({super.key, this.phong});

  @override
  _ThemPhongScreenState createState() => _ThemPhongScreenState();
}

class _ThemPhongScreenState extends State<ThemPhongScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _soPhongController;
  late TextEditingController _giaThueController;
  late TextEditingController _dienTichController;
  late TextEditingController _moTaController;
  String _loaiPhong = "Phòng đơn";
  String _trangThai = Phong.TRANG_THAI_TRONG;

  @override
  void initState() {
    super.initState();
    _soPhongController = TextEditingController(text: widget.phong?.soPhong ?? "");
    _giaThueController = TextEditingController(text: widget.phong?.giaThue.toInt().toString() ?? "");
    _dienTichController = TextEditingController(text: widget.phong?.dienTich.toString() ?? "");
    _moTaController = TextEditingController(text: widget.phong?.moTa ?? "");
    if (widget.phong != null) {
      _loaiPhong = widget.phong!.loaiPhong;
      _trangThai = widget.phong!.trangThai;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.phong == null ? "Thêm phòng mới" : "Sửa thông tin phòng"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _soPhongController,
                decoration: const InputDecoration(labelText: "Số phòng", border: OutlineInputBorder()),
                validator: (v) => v!.isEmpty ? "Vui lòng nhập số phòng" : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _loaiPhong,
                decoration: const InputDecoration(labelText: "Loại phòng", border: OutlineInputBorder()),
                items: ["Phòng đơn", "Phòng đôi", "Phòng Studio"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (v) => setState(() => _loaiPhong = v!),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _giaThueController,
                decoration: const InputDecoration(labelText: "Giá thuê (đ/tháng)", border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? "Vui lòng nhập giá thuê" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dienTichController,
                decoration: const InputDecoration(labelText: "Diện tích (m²)", border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _trangThai,
                decoration: const InputDecoration(labelText: "Trạng thái", border: OutlineInputBorder()),
                items: [Phong.TRANG_THAI_TRONG, Phong.TRANG_THAI_DANG_THUE, Phong.TRANG_THAI_DANG_SUA].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (v) => setState(() => _trangThai = v!),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _moTaController,
                decoration: const InputDecoration(labelText: "Mô tả", border: OutlineInputBorder()),
                maxLines: 3,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
                onPressed: _save,
                child: const Text("LƯU THÔNG TIN"),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final phong = Phong(
        id: widget.phong?.id,
        soPhong: _soPhongController.text,
        loaiPhong: _loaiPhong,
        giaThue: double.parse(_giaThueController.text),
        dienTich: double.tryParse(_dienTichController.text) ?? 0,
        trangThai: _trangThai,
        moTa: _moTaController.text,
        ngayTao: widget.phong?.ngayTao ?? DateTime.now().millisecondsSinceEpoch,
      );
      
      if (widget.phong == null) {
        context.read<PhongProvider>().addPhong(phong);
      } else {
        context.read<PhongProvider>().updatePhong(phong);
      }
      Navigator.pop(context);
    }
  }
}
