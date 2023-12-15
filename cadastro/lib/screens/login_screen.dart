import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(labelText: 'Senha'),
                    obscureText: true,
                  ),
                  ElevatedButton(
                    onPressed: _loginUser,
                    child: Text('Login'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignupScreen()),
                      );
                    },
                    child: Text('Não tem uma conta? Cadastre-se'),
                  ),
                ],
              ),
      ),
    );
  }

  Future<void> _loginUser() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await _authService.signIn(
        emailController.text,
        passwordController.text,
      );
      // Navegar para a próxima tela após o login
      // ...
    } on FirebaseAuthException catch (e) {
      _showErrorDialog(e.message ?? 'Ocorreu um erro desconhecido.');
    } catch (e) {
      _showErrorDialog('Ocorreu um erro desconhecido.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Erro'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text('Ok'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }
}
