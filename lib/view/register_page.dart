import 'package:apk_p3/service/auth_service.dart';
import 'package:apk_p3/view/components/my_button.dart';
import 'package:apk_p3/view/components/my_textfield.dart';
import 'package:apk_p3/view/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final AuthService authService = AuthService();

  void showWaiting() {
    showDialog(
      context: context,
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
  }

  void showAlert(String msg) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Erro de Cadastro'),
          content: Text(msg),
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

  void registerUser() async {
    if (usernameController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      showAlert('Preencha todos os campos.');
      return;
    }

    showWaiting();

    if (passwordController.text != confirmPasswordController.text) {
      Navigator.of(context, rootNavigator: true).pop();
      showAlert('As senhas não conferem!');
      return;
    }

    try {
      await authService.signUp(
        usernameController.text.trim(),
        passwordController.text.trim(),
      );

      if (!mounted) return;

      Navigator.of(context, rootNavigator: true).pop();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }

      String message;
      switch (e.code) {
        case 'email-already-in-use':
          message = 'Já existe um usuário com esse e-mail.';
          break;
        case 'weak-password':
          message = 'A senha deve ter pelo menos 6 caracteres.';
          break;
        case 'invalid-email':
          message = 'O formato do e-mail é inválido.';
          break;
        default:
          message = 'Ocorreu um erro. Tente novamente.';
      }

      showAlert(message);
    }
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
                    height: size.height * 0.25,
                    child: Lottie.asset(
                      'assets/horse.json',
                      fit: BoxFit.contain,
                    ),
                  ),

                  const Text(
                    'Crie sua conta',
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

                  const SizedBox(height: 15),

                  MyTextfield(
                    controller: confirmPasswordController,
                    hintText: 'Confirmar Senha',
                    obscureText: true,
                  ),

                  const SizedBox(height: 30),

                  MyButton(onTap: registerUser, text: 'Cadastrar'),

                  const SizedBox(height: 40),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        'Já tem uma conta?',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ),
                          );
                        },
                        child: const Text(
                          'Entrar',
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
