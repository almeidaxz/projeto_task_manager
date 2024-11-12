import 'package:flutter/material.dart';
import 'package:task_manager/main.dart';
import 'package:task_manager/signup/signup.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("logo.svg", width: 250, height: 250),
            const SizedBox(height: 20),
            const TextField(
              decoration: InputDecoration(
                labelText: 'E-mail',
                prefixIcon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 10),
            const TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Senha',
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const HomePage()));
              },
              child: const Text('Fazer Login'),
            ),
            TextButton(
              onPressed: () {
                print("cadastro");
              },
              child: const Text('Fazer Login com GitHub'),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Ainda não possui conta?'),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUpPage()));
                  },
                  child: const Text('Cadastre-se'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
