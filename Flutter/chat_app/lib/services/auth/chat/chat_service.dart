import 'package:chat_app/model/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class ChatService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Future<void> toggledNotification(
      String receiverId, String currentUserId, bool update) async {
    _fireStore
        .collection('users')
        .doc(currentUserId)
        .collection('chats')
        .doc(receiverId)
        .set({'newMessage': update}, SetOptions(merge: true));
  }

  Future<void> sendMessage({
    String? receiverId,
    String? receiverEmail,
    required String message,
  }) async {
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final Timestamp timestamp = Timestamp.now();

    if (receiverId == null && receiverEmail == null) {
      throw Exception('Você deve fornecer receiverId ou email.');
    }

    try {
      if (receiverId == null) {
        final QuerySnapshot receiverData = await _fireStore
            .collection('users')
            .where('email', isEqualTo: receiverEmail)
            .get();
        if (receiverData.docs.isNotEmpty) {
          receiverId = receiverData.docs[0].id;
        } else {
          throw ErrorDescription('Usuario não encontrado');
        }
      }
      final userData =
          await _fireStore.collection('users').doc(currentUserId).get();
      final userReceiverData =
          await _fireStore.collection('users').doc(receiverId).get();

      Message newMessage = Message(userData['name'], currentUserId,
          userReceiverData['name'], receiverId, message, timestamp);

      List<String> ids = [currentUserId, receiverId];

      ids.sort();
      String chatRoomId = ids.join('_');

      final chatRoomReq = _fireStore
          .collection('chat_rooms')
          .doc(chatRoomId)
          .collection('messages')
          .add(newMessage.toMap());

      final senderChatReq = _fireStore
          .collection('users')
          .doc(currentUserId)
          .collection('chats')
          .doc(receiverId)
          .set({
        'name': userReceiverData['name'],
        'id': receiverId,
        'timestamp': timestamp,
      }, SetOptions(merge: true));

      final receiverChatReq = _fireStore
          .collection('users')
          .doc(receiverId)
          .collection('chats')
          .doc(currentUserId)
          .set({
        'name': userData['name'],
        'id': currentUserId,
        'timestamp': timestamp,
        'newMessage': true
      }, SetOptions(merge: true));

      await Future.wait([senderChatReq, receiverChatReq, chatRoomReq]);
    } catch (e) {
      throw ErrorDescription(e.toString());
    }
  }

  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();

    String chatRoomId = ids.join('_');

    return _fireStore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp',
            descending:
                true) //Esse parametro é decrescente para quando a ListView for montada ela poder ser montada inversamente e começar em baixo.
        .snapshots();
  }

  Stream<QuerySnapshot> getChats(String userId) {
    return _fireStore
        .collection('users')
        .doc(userId)
        .collection('chats')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}
