class BankQrUtils {
  // THÔNG TIN NGÂN HÀNG CỦA CHỦ TRỌ (Bạn hãy sửa ở đây)
  static const String bankId = "Vietcombank"; // Tên ngân hàng (VCB, MB, Techcombank...)
  static const String accountNo = "1234567890"; // Số tài khoản của bạn
  static const String accountName = "NGUYEN VAN ADMIN"; // Tên chủ tài khoản

  static String generateQrUrl({
    required double amount,
    required String roomName,
    required String period,
  }) {
    // Nội dung chuyển khoản: "Thanh toan Phong 101 thang 12/2024"
    String description = "Thanh toan $roomName thang $period";
    
    // Chuyển đổi description sang dạng URL encode (xóa dấu và thay khoảng trắng)
    String cleanDesc = Uri.encodeComponent(description);

    // Sử dụng API VietQR để tạo ảnh QR
    return "https://img.vietqr.io/image/$bankId-$accountNo-compact.png?amount=${amount.toInt()}&addInfo=$cleanDesc&accountName=${Uri.encodeComponent(accountName)}";
  }
}
