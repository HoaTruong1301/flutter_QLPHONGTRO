import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:http/http.dart' as http;
import '../models/phong_model.dart';
import '../models/khach_thue_model.dart';
import '../models/hop_dong_model.dart';
import '../models/hoa_don_model.dart';
import 'format_utils.dart';
import 'bank_qr_utils.dart';

class PdfExportUtils {
  static Future<void> generateContract(HopDong hopDong, Phong phong, KhachThue khach, String chuTro) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Text("CONG HOA XA HOI CHU NGHIA VIET NAM", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14)),
            pw.Text("Doc lap - Tu do - Hanh phuc"),
            pw.SizedBox(height: 10),
            pw.Divider(),
            pw.SizedBox(height: 20),
            pw.Text("HOP DONG THUE PHONG TRO", style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 30),
            pw.Align(alignment: pw.Alignment.centerLeft, child: pw.Text("BEN CHO THUE (BEN A): $chuTro")),
            pw.Align(alignment: pw.Alignment.centerLeft, child: pw.Text("BEN THUE (BEN B): ${khach.hoTen}")),
            pw.SizedBox(height: 20),
            pw.Align(alignment: pw.Alignment.centerLeft, child: pw.Text("Phong so: ${phong.soPhong}")),
            pw.Align(alignment: pw.Alignment.centerLeft, child: pw.Text("Gia thue: ${FormatUtils.formatCurrency(hopDong.giaThue)} /thang")),
            pw.Align(alignment: pw.Alignment.centerLeft, child: pw.Text("Tien coc: ${FormatUtils.formatCurrency(hopDong.tienCoc)}")),
            pw.SizedBox(height: 40),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text("KY TEN BEN A"),
                pw.Text("KY TEN BEN B"),
              ]
            )
          ],
        ),
      ),
    );
    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  static Future<void> generateInvoicePdf(HoaDon hoaDon, String tenPhong, String tenKhach) async {
    final pdf = pw.Document();

    // 1. Tạo link QR và tải dữ liệu ảnh từ internet
    final qrUrl = BankQrUtils.generateQrUrl(
      amount: hoaDon.tongTien,
      roomName: tenPhong,
      period: hoaDon.thangNam ?? "",
    );
    
    pw.MemoryImage? qrImage;
    try {
      final response = await http.get(Uri.parse(qrUrl));
      if (response.statusCode == 200) {
        qrImage = pw.MemoryImage(response.bodyBytes);
      }
    } catch (e) {
      print("Khong the tai anh QR cho PDF: $e");
    }

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) => pw.Padding(
          padding: const pw.EdgeInsets.all(20),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Text("HOA DON TIEN PHONG", 
                    style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              ),
              pw.SizedBox(height: 20),
              pw.Text("Ky thanh toan: ${hoaDon.thangNam}"),
              pw.Text("Phong: $tenPhong"),
              pw.Text("Khach thue: $tenKhach"),
              pw.SizedBox(height: 10),
              pw.Divider(),
              pw.SizedBox(height: 10),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("Noi dung", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text("Thanh tien", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ]
              ),
              pw.SizedBox(height: 10),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("Tien phong"),
                  pw.Text(FormatUtils.formatCurrency(hoaDon.tienPhong)),
                ]
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("Tien dich vu (dien, nuoc, rac...)"),
                  pw.Text(FormatUtils.formatCurrency(hoaDon.tongTienDichVu)),
                ]
              ),
              pw.SizedBox(height: 20),
              pw.Divider(),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("TONG CONG:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16)),
                  pw.Text(FormatUtils.formatCurrency(hoaDon.tongTien), 
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 18, color: PdfColors.blue)),
                ]
              ),
              
              // KHU VỰC MÃ QR THANH TOÁN TRONG PDF
              if (qrImage != null) ...[
                pw.SizedBox(height: 30),
                pw.Center(
                  child: pw.Column(
                    children: [
                      pw.Text("QUET MA DE THANH TOAN", style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                      pw.SizedBox(height: 10),
                      pw.Container(
                        width: 150,
                        height: 150,
                        child: pw.Image(qrImage),
                      ),
                      pw.SizedBox(height: 5),
                      pw.Text("Ngan hang: ${BankQrUtils.bankId} - STK: ${BankQrUtils.accountNo}", style: pw.TextStyle(fontSize: 10)),
                      pw.Text("Chu tai khoan: ${BankQrUtils.accountName}", style: pw.TextStyle(fontSize: 10)),
                    ]
                  )
                ),
              ],

              pw.Spacer(),
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Column(
                  children: [
                    pw.Text("Ngay xuat: ${FormatUtils.formatDate(DateTime.now().millisecondsSinceEpoch)}"),
                    pw.SizedBox(height: 10),
                    pw.Text("NGUOI LAP PHIEU"),
                    pw.SizedBox(height: 40),
                    pw.Text("(Ky va ghi ro ho ten)"),
                  ]
                )
              ),
              pw.SizedBox(height: 20),
              pw.Center(
                child: pw.Text("Cam on quy khach!", style: pw.TextStyle(fontStyle: pw.FontStyle.italic, fontSize: 10))
              )
            ],
          ),
        ),
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }
}
