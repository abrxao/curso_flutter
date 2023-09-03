import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderName;
  final String senderId;
  final String receiverName;
  final String receiverId;
  final String message;

  final Timestamp timestamp;

  Message(
    this.senderName,
    this.senderId,
    this.receiverName,
    this.receiverId,
    this.message,
    this.timestamp,
  );

  Map<String, dynamic> toMap() {
    return {
      'senderName': senderName,
      'senderId': senderId,
      'receiverName': receiverName,
      'receiverId': receiverId,
      'message': message,
      'timestamp': timestamp,
    };
  }
}
