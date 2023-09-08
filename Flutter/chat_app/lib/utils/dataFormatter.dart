import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DateFormatter {
  static String formatMessageDate(Timestamp messageDate) {
    final now = DateTime.now();
    final dateTime = messageDate.toDate(); // Converte Timestamp para DateTime
    final difference = now.difference(dateTime);

    if (now.day - dateTime.day == 0) {
      return DateFormat.Hm().format(dateTime);
    } else if (now.day - dateTime.day == 1) {
      return 'Ontem';
    } else if (difference.inDays < 7) {
      // Esta semana
      return DateFormat('EEEE').format(dateTime);
    } else {
      // Mais de uma semana atrás
      return DateFormat('dd/MM').format(dateTime);
    }
  }
}
