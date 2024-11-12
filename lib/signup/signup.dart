import 'package:flutter/material.dart';
import 'package:task_manager/login/login.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar Conta'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const TextField(
              decoration: InputDecoration(
                labelText: 'Nome Completo',
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 16),
            const TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'E-mail',
                prefixIcon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 16),
            const TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Confirmar E-mail',
                prefixIcon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 16),
            const TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Senha',
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 16),
            const TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Confirmar Senha',
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Lógica para registrar o usuário
              },
              child: const Text('Registrar'),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Já possui conta?'),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()));
                  },
                  child: const Text('Entrar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
