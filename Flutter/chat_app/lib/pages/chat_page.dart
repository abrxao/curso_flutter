import 'package:chat_app/components/my_text_field.dart';
import 'package:chat_app/services/auth/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String receiverUserName;
  final String receiverUserId;
  const ChatPage(
      {super.key,
      required this.receiverUserName,
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
      try {
        await _chatService.sendMessage(
          message: _messageController.text,
          receiverId: widget.receiverUserId,
        );
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Erro desconhecido')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            title: Text(widget.receiverUserName)),
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
    _chatService.toggledNotification(
        widget.receiverUserId, _firebaseAuth.currentUser!.uid, false);

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
      name = data['senderName'];
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
                onPressed: () {
                  sendMessage();
                  _messageController.clear();
                },
                icon: const Icon(
                  Icons.send,
                )),
          )
        ],
      ),
    );
  }
}
