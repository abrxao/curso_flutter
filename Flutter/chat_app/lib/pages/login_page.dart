import 'package:chat_app/components/my_button.dart';
import 'package:chat_app/components/my_text_field.dart';
import 'package:chat_app/services/auth/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  // final void Function()? onTap;
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isPasswordHidden = true;

  void signIn() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    try {
      await authService.signInWithCredentials(
          emailController.text, passwordController.text);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  void _toggleIcon() {
    setState(() {
      _isPasswordHidden = !_isPasswordHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'images/logo.png',
                width: 150,
              ),
              const SizedBox(
                height: 8,
              ),
              const Text('Bem-vindo ao ChatApp'),
              const SizedBox(
                height: 48,
              ),
              MyTextField(
                  controller: emailController,
                  hintText: 'Digite seu e-mail',
                  obscureText: false),
              const SizedBox(
                height: 16,
              ),
              Stack(alignment: AlignmentDirectional.center, children: [
                MyTextField(
                    controller: passwordController,
                    hintText: 'Digite sua senha',
                    obscureText: _isPasswordHidden),
                Positioned(
                  right: 8,
                  child: IconButton(
                      tooltip:
                          _isPasswordHidden ? 'Ver senha' : 'Esconder senha',
                      onPressed: () {
                        _toggleIcon();
                      },
                      icon: _isPasswordHidden
                          ? const Icon(Icons.visibility_off)
                          : const Icon(Icons.visibility)),
                ),
              ]),
              const SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Não tem conta?'),
                  const SizedBox(
                    width: 4,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: const Text('Crie agora',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  )
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              MyButton(
                onTap: () {
                  signIn();
                },
                text: 'Entrar',
              ),
              const SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
