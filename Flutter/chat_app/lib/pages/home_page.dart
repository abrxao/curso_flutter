import 'package:chat_app/pages/chat_page.dart';
import 'package:chat_app/services/auth/auth_services.dart';
import 'package:chat_app/services/auth/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_app/components/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _firebaseAuth = FirebaseAuth.instance;
  final ChatService _chatService = ChatService();
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  void signOut() {
    final authService = Provider.of<AuthService>(context, listen: false);
    authService.signOut();
  }

  void sendMessage() async {
    if (_messageController.text.isNotEmpty &&
        _emailController.text.isNotEmpty) {
      try {
        await _chatService.sendMessage(
            message: _messageController.text,
            receiverEmail: _emailController.text);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Email não encontrado')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Verifique os campos vazios')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          'Conversas de ${_firebaseAuth.currentUser!.email}',
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
        actions: [
          Tooltip(
              message: 'Sair',
              child: IconButton(
                  onPressed: _modalLogout,
                  icon: const Icon(
                    Icons.logout,
                    color: Colors.white,
                  )))
        ],
      ),
      body: _buildUserList(),
      floatingActionButton: Tooltip(
        message: 'Nova mensagem',
        child: FloatingActionButton(
          onPressed: () {
            _modalNewMessage();
          },
          backgroundColor: Theme.of(context).primaryColor,
          child: const Icon(
            Icons.chat_bubble_outline_rounded,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
        stream: _chatService.getChats(_firebaseAuth.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('error');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor));
          }

          return ListView(
            children: snapshot.data!.docs
                .map<Widget>((doc) => _buildUserListItem(doc))
                .toList(),
          );
        });
  }

  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    var whoSended = data['lastMsgSenderID'] == _firebaseAuth.currentUser!.uid
        ? 'você'
        : data['name'];
    var lastMsg = data['lastMsg'] ?? 'teste';

    if (_firebaseAuth.currentUser!.uid != data['id']) {
      var _buildHasNotification = data['newMessage'] == true
          ? Positioned(
              right: 12,
              child: Icon(
                Icons.circle,
                color: Theme.of(context).primaryColor,
              ),
            )
          : Container();

      var _buildLastMsg = Row(
        children: [
          Text(
            '$whoSended: $lastMsg',
            style: const TextStyle(fontSize: 14, color: Colors.black45),
          ),
        ],
      );

      return ListTile(
        title: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 16),
            decoration: BoxDecoration(
                border: BorderDirectional.lerp(
                    BorderDirectional(
                        bottom: BorderSide(color: Theme.of(context).cardColor)),
                    BorderDirectional(
                        bottom: BorderSide(color: Theme.of(context).cardColor)),
                    1)),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                        child: Text(
                      data['name'],
                      style: const TextStyle(fontSize: 18),
                    )),
                    _buildHasNotification,
                  ],
                ),
                _buildLastMsg
              ],
            )),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatPage(
                        receiverUserName: data['name'],
                        receiverUserId: data['id'],
                      )));
        },
      );
    } else {
      return Container();
    }
  }

  _modalNewMessage() {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Container(
              constraints: const BoxConstraints(maxHeight: 150),
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(children: [
                      Expanded(
                          child: MyTextField(
                        controller: _emailController,
                        hintText: 'Email de destino',
                        obscureText: false,
                      )),
                    ]),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
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
                                _emailController.clear();
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.send,
                              )),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  _modalLogout() {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) {
        return Dialog(
          shadowColor: Colors.transparent,
          child: Container(
            constraints: const BoxConstraints(maxHeight: 150),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    blurRadius: 2,
                    color: Colors.black87,
                    offset: Offset.fromDirection(
                      1,
                    )),
              ],
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Deseja mesmo sair?',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            signOut();
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Sair',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Theme.of(context).primaryColor)),
                          child: const Text(
                            'Quero continuar no app',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    )
                  ]),
            ),
          ),
        );
      },
    );
  }
}
