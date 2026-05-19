import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/phong_provider.dart';
import '../../widgets/phong_item.dart';
import '../../models/phong_model.dart';
import 'them_phong_screen.dart';

class PhongListScreen extends StatefulWidget {
  const PhongListScreen({super.key});

  @override
  _PhongListScreenState createState() => _PhongListScreenState();
}

class _PhongListScreenState extends State<PhongListScreen> {
  bool _isSearchVisible = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PhongProvider>().fetchPhong();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PhongProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Danh sách phòng", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(_isSearchVisible ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearchVisible = !_isSearchVisible;
                if (!_isSearchVisible) {
                  _searchController.clear();
                  provider.setSearchQuery("");
                }
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (_isSearchVisible)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Tìm số phòng...",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
                  contentPadding: EdgeInsets.zero,
                ),
                onChanged: (value) => provider.setSearchQuery(value),
              ),
            ),
          
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: ["", Phong.TRANG_THAI_TRONG, Phong.TRANG_THAI_DANG_THUE, Phong.TRANG_THAI_DANG_SUA].map((status) {
                final label = status.isEmpty ? "Tất cả" : status;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(label),
                    selected: provider.filter == status,
                    onSelected: (selected) {
                      provider.setFilter(status);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          
          Expanded(
            child: provider.filteredPhong.isEmpty
                ? const Center(child: Text("Không có dữ liệu"))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: provider.filteredPhong.length,
                    itemBuilder: (context, index) {
                      final phong = provider.filteredPhong[index];
                      return PhongItem(
                        phong: phong,
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => ThemPhongScreen(phong: phong)));
                        },
                        onLongPress: () {
                          _showDeleteDialog(context, phong);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ThemPhongScreen())),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, Phong phong) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Xóa phòng"),
        content: Text("Bạn có chắc muốn xóa phòng ${phong.soPhong}?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text("HỦY")),
          TextButton(
            onPressed: () {
              context.read<PhongProvider>().deletePhong(phong.id!);
              Navigator.pop(dialogContext);
            }, 
            child: const Text("XÓA", style: TextStyle(color: Colors.red))
          ),
        ],
      ),
    );
  }
}
