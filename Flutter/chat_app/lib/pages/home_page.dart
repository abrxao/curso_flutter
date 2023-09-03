import 'package:chat_app/pages/chat_page.dart';
import 'package:chat_app/services/auth/auth_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _firebaseAuth = FirebaseAuth.instance;

  void signOut() {
    final authService = Provider.of<AuthService>(context, listen: false);
    authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('Home Page'),
        actions: [
          Tooltip(
              message: 'Sair',
              child: IconButton(
                  onPressed: _modalLogout, icon: const Icon(Icons.logout)))
        ],
      ),
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
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

    if (_firebaseAuth.currentUser!.email != data['email']) {
      return ListTile(
        visualDensity: VisualDensity.compact,
        title: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
            decoration: BoxDecoration(
                border: BorderDirectional.lerp(
                    BorderDirectional(
                        bottom: BorderSide(color: Theme.of(context).cardColor)),
                    BorderDirectional(
                        bottom: BorderSide(color: Theme.of(context).cardColor)),
                    1)),
            child: Text(data['name'])),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatPage(
                        receiverUserEmail: data['name'],
                        receiverUserId: data['uid'],
                      )));
        },
      );
    } else {
      return Container();
    }
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
