import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/thu_chi_provider.dart';
import '../../models/thu_chi_model.dart';

class ThemThuChiScreen extends StatefulWidget {
  const ThemThuChiScreen({super.key});

  @override
  _ThemThuChiScreenState createState() => _ThemThuChiScreenState();
}

class _ThemThuChiScreenState extends State<ThemThuChiScreen> {
  final _formKey = GlobalKey<FormState>();
  final _soTienController = TextEditingController();
  final _moTaController = TextEditingController();
  String _selectedLoai = "THU";
  String _selectedDanhMuc = "Tiền thuê nhà";

  final List<String> _danhMucThu = ["Tiền thuê nhà", "Tiền cọc", "Thu khác"];
  final List<String> _danhMucChi = ["Sửa chữa", "Điện nước", "Bảo trì", "Chi khác"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Thêm giao dịch mới")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Loại giao dịch", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: ChoiceChip(
                      label: const Center(child: Text("KHOẢN THU")),
                      selected: _selectedLoai == "THU",
                      onSelected: (val) => setState(() { _selectedLoai = "THU"; _selectedDanhMuc = _danhMucThu[0]; }),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ChoiceChip(
                      label: const Center(child: Text("KHOẢN CHI")),
                      selected: _selectedLoai == "CHI",
                      selectedColor: Colors.red[100],
                      onSelected: (val) => setState(() { _selectedLoai = "CHI"; _selectedDanhMuc = _danhMucChi[0]; }),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _soTienController,
                decoration: const InputDecoration(labelText: "Số tiền (đ)", border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? "Vui lòng nhập số tiền" : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedDanhMuc,
                decoration: const InputDecoration(labelText: "Danh mục", border: OutlineInputBorder()),
                items: (_selectedLoai == "THU" ? _danhMucThu : _danhMucChi)
                    .map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (val) => setState(() => _selectedDanhMuc = val!),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _moTaController,
                decoration: const InputDecoration(labelText: "Ghi chú/Mô tả", border: OutlineInputBorder()),
                maxLines: 3,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: _selectedLoai == "THU" ? Colors.blue : Colors.red,
                ),
                onPressed: _save,
                child: const Text("LƯU GIAO DỊCH", style: TextStyle(color: Colors.white)),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final tc = ThuChi(
        loai: _selectedLoai,
        danhMuc: _selectedDanhMuc,
        soTien: double.parse(_soTienController.text),
        moTa: _moTaController.text,
        ngayGiaoDich: DateTime.now().millisecondsSinceEpoch,
        ngayTao: DateTime.now().millisecondsSinceEpoch,
      );
      context.read<ThuChiProvider>().addThuChi(tc);
      Navigator.pop(context);
    }
  }
}
