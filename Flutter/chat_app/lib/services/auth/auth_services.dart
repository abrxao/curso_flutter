import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserCredential> signInWithCredentials(
      String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      _firestore.collection('users').doc(userCredential.user!.uid).set(
          {'uid': userCredential.user!.uid, 'email': email},
          SetOptions(merge: true));

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<UserCredential> createAccountWithCredentials(
      String email, String password, String name) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      _firestore.collection('users').doc(userCredential.user!.uid).set(
          {'uid': userCredential.user!.uid, 'email': email, 'name': name},
          SetOptions(merge: true));

      return userCredential;
    } catch (e) {
      if (e is FirebaseAuthException) {
        if (e.code == 'invalid-email') {
          throw ErrorDescription('Verifique seu email');
        } else if (e.code == 'weak-password') {
          throw ErrorDescription('A senha é muito fraca. Tente outra.');
        } else if (e.code == 'email-already-in-use') {
          throw ErrorDescription(
              'Este email já está em uso. Tente fazer login.');
        } else {
          // Outros erros do Firebase Auth
          throw ErrorDescription('Erro ao criar a conta: ${e.message}');
        }
      } else {
        // Lidar com exceções gerais que não são específicas do Firebase Auth
        throw ErrorDescription(e.toString());
      }
    }
  }
}
