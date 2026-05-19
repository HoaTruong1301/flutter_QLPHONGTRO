import 'package:intl/intl.dart';

class FormatUtils {
  static final currencyFormat = NumberFormat("#,###", "vi_VN");
  static final dateFormat = DateFormat("dd/MM/yyyy");
  static final monthYearFormat = DateFormat("MM/yyyy");

  static String formatCurrency(double amount) => "${currencyFormat.format(amount)} đ";
  static String formatDate(int timestamp) => dateFormat.format(DateTime.fromMillisecondsSinceEpoch(timestamp));
  static String formatMonthYear(int timestamp) => monthYearFormat.format(DateTime.fromMillisecondsSinceEpoch(timestamp));
  static String getCurrentMonthYear() => monthYearFormat.format(DateTime.now());
  static String formatArea(double area) => "${area.toStringAsFixed(1)} m²";
}
