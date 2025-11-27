import 'package:apk_p3/service/auth_service.dart';
import 'package:apk_p3/view/components/my_button.dart';
import 'package:apk_p3/view/components/my_textfield.dart';
import 'package:apk_p3/view/home_page.dart';
import 'package:apk_p3/view/register_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  void signUserIn() async {
    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      _showErrorMessage('empty-fields');
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Center(
          child: SizedBox(
            width: 100,
            height: 100,
            child: Lottie.asset('assets/loading.json'),
          ),
        );
      },
    );

    try {
      await _authService.signIn(
        usernameController.text,
        passwordController.text,
      );

      if (mounted) Navigator.pop(context);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) Navigator.pop(context);
      _showErrorMessage(e.code);
    }
  }

  void _showErrorMessage(String errorCode) {
    String message;

    if (errorCode == 'empty-fields') {
      message = 'Preencha todos os campos.';
    } else if (errorCode == 'user-not-found' || errorCode == 'wrong-password') {
      message = 'E-mail ou senha incorretos.';
    } else {
      message = 'Erro ao fazer login. Tente novamente.';
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Erro de Login'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK', style: TextStyle(color: Colors.brown)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.brown[50],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: size.height * 0.05),

                  SizedBox(
                    height: size.height * 0.3,
                    child: Lottie.asset(
                      'assets/horse.json',
                      fit: BoxFit.contain,
                    ),
                  ),

                  const Text(
                    'Acesse sua conta',
                    style: TextStyle(
                      color: Colors.brown,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: size.height * 0.03),

                  MyTextfield(
                    controller: usernameController,
                    hintText: 'Email',
                    obscureText: false,
                  ),

                  const SizedBox(height: 15),

                  MyTextfield(
                    controller: passwordController,
                    hintText: 'Senha',
                    obscureText: true,
                  ),

                  const SizedBox(height: 30),

                  MyButton(onTap: signUserIn, text: 'Entrar'),

                  const SizedBox(height: 40),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        'Não tem cadastro?',
                        style: TextStyle(color: Colors.black54, fontSize: 16),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterPage(),
                            ),
                          );
                        },
                        child: const Text(
                          'Cadastrar-se',
                          style: TextStyle(
                            color: Colors.brown,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: size.height * 0.05),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
