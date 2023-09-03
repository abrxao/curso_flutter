import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String name;
  final String receiverId;
  final String message;
  final Timestamp timestamp;

  Message(
    this.senderId,
    this.name,
    this.receiverId,
    this.message,
    this.timestamp,
  );

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'name': name,
      'receiverId': receiverId,
      'message': message,
      'timestamp': timestamp,
    };
  }
}
