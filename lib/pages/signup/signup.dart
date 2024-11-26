import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:task_manager/clients/base_client.dart';
import 'package:task_manager/pages/login/login.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  SignUpPageState createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _confirmaEmailController =
      TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _confirmaSenhaController =
      TextEditingController();

  void _registrar() async {
    BaseClient client = BaseClient();

    final nome = _nomeController.text.trim();
    final email = _emailController.text.trim();
    final confirmaEmail = _confirmaEmailController.text.trim();
    final senha = _senhaController.text.trim();
    final confirmaSenha = _confirmaSenhaController.text.trim();

    if (email.isEmpty ||
        senha.isEmpty ||
        nome.isEmpty ||
        confirmaEmail.isEmpty ||
        confirmaSenha.isEmpty) {
      _mostrarMensagemErro("Preencha todos os campos.");
      return;
    }
    if (email != confirmaEmail) {
      _mostrarMensagemErro("Os e-mails não coincidem!");
      return;
    }

    if (senha != confirmaSenha) {
      _mostrarMensagemErro("As senhas não coincidem!");
      return;
    }

    final response = await client.post('/user/', {
      "name": nome,
      "email": email,
      "password": senha,
    });
    Map<String, dynamic> data = jsonDecode(response);

    if (!data['success']) {
      _mostrarMensagemErro(data['errors'][0]);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cadastro realizado com sucesso!'),
          backgroundColor: Colors.green,
          duration: Duration(milliseconds: 800),
        ),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F4FF), // Fundo roxo claro
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTextField(
                  label: "Nome Completo",
                  hintText: "John Doe",
                  icon: Icons.person,
                  controller: _nomeController,
                ),
                const SizedBox(height: 16.0),
                _buildTextField(
                  label: "E-mail",
                  hintText: "seuemail@provedor.com.br",
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                ),
                const SizedBox(height: 16.0),
                _buildTextField(
                  label: "Confirmar E-mail",
                  hintText: "seuemail@provedor.com.br",
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  controller: _confirmaEmailController,
                ),
                const SizedBox(height: 16.0),
                _buildTextField(
                  label: "Senha",
                  hintText: "********",
                  icon: Icons.lock,
                  obscureText: true,
                  controller: _senhaController,
                ),
                const SizedBox(height: 16.0),
                _buildTextField(
                  label: "Confirmar Senha",
                  hintText: "********",
                  icon: Icons.lock,
                  obscureText: true,
                  controller: _confirmaSenhaController,
                ),
                const SizedBox(height: 32.0),
                ElevatedButton(
                  onPressed: _registrar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9C7DF9), // Roxo do botão
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text(
                    "Registrar",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  },
                  child: const Text(
                    "Já possui conta? Entrar",
                    style: TextStyle(
                      color: Color(0xFF9C7DF9),
                      fontSize: 14.0,
                      decoration: TextDecoration.underline,
                    ),
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
