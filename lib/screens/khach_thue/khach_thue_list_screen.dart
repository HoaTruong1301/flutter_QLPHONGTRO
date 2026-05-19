import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/khach_thue_provider.dart';
import '../../models/khach_thue_model.dart';
import 'them_khach_thue_screen.dart';

class KhachThueListScreen extends StatefulWidget {
  const KhachThueListScreen({super.key});

  @override
  _KhachThueListScreenState createState() => _KhachThueListScreenState();
}

class _KhachThueListScreenState extends State<KhachThueListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<KhachThueProvider>().fetchKhach();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<KhachThueProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Quản lý khách thuê", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: provider.filteredKhach.isEmpty
          ? const Center(child: Text("Chưa có khách thuê nào"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: provider.filteredKhach.length,
              itemBuilder: (context, index) {
                final khach = provider.filteredKhach[index];
                return _buildKhachItem(context, khach);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ThemKhachThueScreen())),
        child: const Icon(Icons.person_add),
      ),
    );
  }

  Widget _buildKhachItem(BuildContext context, KhachThue khach) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          radius: 28,
          backgroundColor: Colors.blue.withOpacity(0.1),
          child: Text(khach.hoTen.substring(0, 1).toUpperCase(), 
               style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
        ),
        title: Text(khach.hoTen, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text("SĐT: ${khach.soDienThoai ?? '---'}"),
            Text("Phòng ID: ${khach.phongId ?? 'Chưa có'}", style: const TextStyle(color: Colors.blue)),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: khach.dangThue ? Colors.green.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(khach.dangThue ? "Đang thuê" : "Đã trả", 
               style: TextStyle(color: khach.dangThue ? Colors.green : Colors.grey, fontSize: 11)),
        ),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ThemKhachThueScreen(khach: khach))),
      ),
    );
  }
}
