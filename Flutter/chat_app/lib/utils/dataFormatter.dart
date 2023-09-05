import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DateFormatter {
  static String formatMessageDate(Timestamp messageDate) {
    final now = DateTime.now();
    final dateTime = messageDate.toDate(); // Converte Timestamp para DateTime
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      // Hoje
      return DateFormat.Hm().format(dateTime);
    } else if (difference.inDays == 1) {
      // Ontem
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
