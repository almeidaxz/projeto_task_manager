import 'package:intl/intl.dart';

DateTime formatDate(String date) {
  DateFormat dateFormat = DateFormat("dd/MM/yyyy HH:mm");
  return dateFormat.parse(date);
}
