import 'package:flutter/material.dart';
import '../models/phong_model.dart';
import '../utils/format_utils.dart';

class PhongItem extends StatelessWidget {
  final Phong phong;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const PhongItem({
    required this.phong,
    required this.onTap,
    required this.onLongPress,
  });

  Color _getStatusColor(String status) {
    switch (status) {
      case Phong.TRANG_THAI_TRONG: return Colors.green;
      case Phong.TRANG_THAI_DANG_THUE: return Colors.blue;
      case Phong.TRANG_THAI_DANG_SUA: return Colors.orange;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(phong.trangThai);
    
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    phong.soPhong.length > 3 ? phong.soPhong.substring(0, 3) : phong.soPhong,
                    style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Phòng ${phong.soPhong}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            phong.trangThai,
                            style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text("${phong.loaiPhong} • ${FormatUtils.formatArea(phong.dienTich)}", 
                         style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                    SizedBox(height: 8),
                    Text("${FormatUtils.formatCurrency(phong.giaThue)}/tháng", 
                         style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
