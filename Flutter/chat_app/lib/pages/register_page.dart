import 'package:chat_app/components/my_button.dart';
import 'package:chat_app/components/my_text_field.dart';
import 'package:chat_app/services/auth/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  // final void Function()? onTap;
  const RegisterPage({
    super.key,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void signUp() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    if (passwordController.text == confirmPasswordController.text &&
        nameController.text.length > 5) {
      try {
        await authService.createAccountWithCredentials(
            emailController.text, passwordController.text, nameController.text);
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Conta criada')));
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Verifique suas credenciais')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'images/logo.png',
                  width: 150,
                ),
                const SizedBox(
                  height: 16,
                ),
                const Text('Vamos criar uma conta pra você'),
                const SizedBox(
                  height: 48,
                ),
                MyTextField(
                    controller: nameController,
                    hintText: 'Digite seu nome',
                    obscureText: false),
                const SizedBox(
                  height: 16,
                ),
                MyTextField(
                    controller: emailController,
                    hintText: 'Digite um email',
                    obscureText: false),
                const SizedBox(
                  height: 16,
                ),
                MyTextField(
                    controller: passwordController,
                    hintText: 'Digite uma senha',
                    obscureText: true),
                const SizedBox(
                  height: 16,
                ),
                MyTextField(
                    controller: confirmPasswordController,
                    hintText: 'Confime sua senha',
                    obscureText: true),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Já é membro?'),
                    const SizedBox(
                      width: 4,
                    ),
                    GestureDetector(
                      onTap: () => {Navigator.pop(context)},
                      child: const Text('Entre agora',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                MyButton(
                  onTap: signUp,
                  text: 'Registre-se',
                ),
                const SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
