import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:task_manager/clients/base_client.dart';
import 'package:task_manager/main.dart';
import 'package:task_manager/pages/signup/signup.dart';

const storage = FlutterSecureStorage();

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  void _checkToken() async {
    final token = await storage.read(key: 'token').then((value) => value);
    if (token != null) {
      var name = await storage.read(key: 'name').then((value) => value);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const TaskManagerPage(),
        ),
      );
      Future.delayed(
          const Duration(seconds: 1),
          () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Bem vindo, $name'),
                backgroundColor: Colors.green,
                duration: const Duration(milliseconds: 800),
              )));
    }
  }

  void _login() async {
    BaseClient client = BaseClient();
    final email = _emailController.text.trim();
    final senha = _senhaController.text.trim();

    if (email.isEmpty || senha.isEmpty) {
      _mostrarMensagemErro("Preencha todos os campos.");
      return;
    }

    final response =
        await client.post('/user/login', {"email": email, "password": senha});
    Map<String, dynamic> data = jsonDecode(response);
    if (!data['success']) {
      _mostrarMensagemErro(data['errors'][0]);
    } else {
      await storage.write(key: 'token', value: data['response']['token']);
      await storage.write(
          key: 'id', value: data['response']['user']['id'].toString());
      await storage.write(key: 'name', value: data['response']['user']['name']);
      await storage.write(
          key: 'email', value: data['response']['user']['email']);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bem vindo, ${data['response']['user']['name']}'),
          backgroundColor: Colors.green,
          duration: const Duration(milliseconds: 500),
        ),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const TaskManagerPage(),
        ),
      );
    }
  }

  void _mostrarMensagemErro(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _checkToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F4FF),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  children: [
                    Icon(
                      Icons.note_alt,
                      size: 120.0,
                      color: Colors.pink[200],
                    ),
                    const SizedBox(height: 32.0),
                  ],
                ),
                _buildTextField(
                  label: "E-mail",
                  hintText: "Digite seu e-mail",
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                ),
                const SizedBox(height: 16.0),
                _buildTextField(
                  label: "Senha",
                  hintText: "Digite sua senha",
                  icon: Icons.lock,
                  obscureText: true,
                  controller: _senhaController,
                ),
                const SizedBox(height: 32.0),
                ElevatedButton.icon(
                  onPressed: _login,
                  icon: const Icon(Icons.login),
                  label: const Text("Fazer Login"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9C7DF9),
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignUpPage(),
                      ),
                    );
                  },
                  child: const Text.rich(
                    TextSpan(
                      text: "Ainda não possui conta? ",
                      children: [
                        TextSpan(
                          text: "Cadastre-se",
                          style: TextStyle(
                            color: Color(0xFF9C7DF9),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hintText,
    required IconData icon,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8.0),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: Icon(icon),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ],
    );
  }
}
