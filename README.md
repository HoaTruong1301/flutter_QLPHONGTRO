# 🏠 Ứng dụng Quản lý Nhà trọ (QL PHÒNG TRỌ)

Ứng dụng quản lý nhà trọ chuyên nghiệp dành cho chủ trọ, được xây dựng trên nền tảng **Flutter**. Hệ thống giúp số hóa quy trình quản lý truyền thống, từ việc lưu trữ thông tin khách thuê đến tính toán hóa đơn tự động và theo dõi dòng tiền.

## 🚀 Tính năng nổi bật

### 1. 🔑 Hệ thống Tài khoản
* Đăng ký, Đăng nhập và quản lý phiên làm việc bằng **SharedPreferences**.
* Bảo mật thông tin kinh doanh cho chủ trọ.

### 2. 📊 Dashboard Thông minh
* Thống kê trực quan: Tổng số phòng, phòng trống, đang thuê và hóa đơn nợ.
* Theo dõi doanh thu tháng hiện tại.
* **Bản tin API**: Cập nhật thông báo từ ban quản lý thông qua REST API.

### 3. 📦 Quản lý Hạ tầng & Khách thuê
* Quản lý danh sách phòng theo trạng thái (Trống, Đang thuê, Đang sửa).
* Hồ sơ khách thuê chi tiết (SĐT, CCCD, Ngày vào ở).
* Tự động cập nhật trạng thái phòng khi thêm khách.

### 4. 📄 Hợp đồng & Hóa đơn PDF
* Lập hợp đồng thuê nhà điện tử.
* **Chốt điện nước**: Tính toán hóa đơn tự động theo chỉ số tiêu thụ.
* **Xuất bản PDF**: In hóa đơn và hợp đồng chuyên nghiệp ngay trên điện thoại.

### 5. 💳 Tích hợp VietQR (Napas 24/7)
* **Tự động tạo mã QR**: Mã QR thanh toán ngân hàng được nhúng trực tiếp vào hóa đơn PDF.
* Khách thuê chỉ cần quét mã để thanh toán chính xác 100% số tiền và nội dung.

### 6. 💰 Quản lý Thu Chi
* Sổ quỹ ghi chép mọi biến động dòng tiền.
* Tự động đồng bộ khoản thu khi khách thanh toán hóa đơn.
* Theo dõi lợi nhuận và số dư.

## 🛠 Công nghệ sử dụng
* **Flutter & Dart**: Framework chính.
* **SQLite (sqflite)**: Cơ sở dữ liệu cục bộ.
* **Provider**: Quản lý trạng thái (State Management).
* **http**: Giao tiếp REST API.
* **pdf & printing**: Xử lý tệp tin tài liệu.
* **intl**: Định dạng tiền tệ và thời gian Việt Nam.

## 📸 Hình ảnh ứng dụng
*(Bạn có thể thêm link ảnh vào đây để giáo viên thấy giao diện ngay trên GitHub)*

## 📥 Hướng dẫn cài đặt
1. Cài đặt Flutter SDK tại [flutter.dev](https://flutter.dev).
2. Clone dự án:
   ```bash
   git clone https://github.com/HoaTruong1301/flutter_QLPHONGTRO.git
   ```
3. Chạy lệnh tải thư viện:
   ```bash
   flutter pub get
   ```
4. Chạy ứng dụng:
   ```bash
   flutter run
   ```

---

