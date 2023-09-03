import 'package:chat_app/components/my_text_field.dart';
import 'package:chat_app/services/auth/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String receiverUserEmail;
  final String receiverUserId;
  const ChatPage(
      {super.key,
      required this.receiverUserEmail,
      required this.receiverUserId});
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
          widget.receiverUserId, _messageController.text);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            title: Text(widget.receiverUserEmail)),
        body: Column(
          children: [
            Expanded(child: _buildMessageList()),
            _buildMessageInput()
          ],
        ));
  }

  Widget _buildMessageList() {
    return StreamBuilder(
        stream: _chatService.getMessages(
            widget.receiverUserId, _firebaseAuth.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('error');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ));
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: ListView(
                reverse: true,
                children: snapshot.data!.docs
                    .map((document) => _buildMessageItem(document))
                    .toList()),
          );
        });
  }

  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    final Alignment alignment;
    final Color bgColor;
    final CrossAxisAlignment crossAlignment;
    final MainAxisAlignment mainAlignment;
    final String name;

    if (data['senderId'] == _firebaseAuth.currentUser!.uid) {
      name = 'eu';
      alignment = Alignment.centerRight;
      bgColor = const Color.fromARGB(255, 220, 220, 220);
      crossAlignment = CrossAxisAlignment.end;
      mainAlignment = MainAxisAlignment.end;
    } else {
      name = data['name'];
      alignment = Alignment.centerLeft;
      bgColor = Theme.of(context).cardColor;
      crossAlignment = CrossAxisAlignment.start;
      mainAlignment = MainAxisAlignment.start;
    }

    return Container(
      alignment: alignment,
      child: Column(
          crossAxisAlignment: crossAlignment,
          mainAxisAlignment: mainAlignment,
          children: [
            Text(
              name,
              style: const TextStyle(
                  fontSize: 12, color: Color.fromARGB(255, 160, 160, 200)),
            ),
            Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: bgColor,
                ),
                child: Text(
                  data['message'],
                  style: const TextStyle(fontSize: 16),
                )),
            const SizedBox(
              height: 12,
            ),
          ]),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
              child: MyTextField(
            controller: _messageController,
            hintText: 'Digite uma messagem',
            obscureText: false,
          )),
          Tooltip(
            message: 'Enviar',
            child: IconButton(
                onPressed: sendMessage,
                icon: const Icon(
                  Icons.send,
                )),
          )
        ],
      ),
    );
  }
}
