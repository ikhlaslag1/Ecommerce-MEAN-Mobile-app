import 'package:intl/intl.dart';

class Formatter {

  static String formatPrice(num price) {
    final numberFormat = NumberFormat("#,##0.00", "en_US"); // Using en_US locale for formatting
    final formattedPrice = numberFormat.format(price);
    return '$formattedPrice MAD'; // Adding MAD currency symbol
  }

  static String formatDate(DateTime date) {
    DateTime localDate = date.toLocal();
    final dateFormat = DateFormat("dd MMM y, hh:mm a");
    return dateFormat.format(localDate);
  }

}
