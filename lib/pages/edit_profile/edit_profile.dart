import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:task_manager/clients/base_client.dart';

FlutterSecureStorage storage = const FlutterSecureStorage();

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  EditProfileState createState() => EditProfileState();
}

class EditProfileState extends State<EditProfilePage> {
  BaseClient client = BaseClient();
  late final TextEditingController _nameController = TextEditingController();
  late final TextEditingController _emailController = TextEditingController();
  late final TextEditingController _passwordController =
      TextEditingController();

  String? userId = '';

  getUserData() async {
    userId = await storage.read(key: 'id').then((value) => value);
    final response = await client.get('/user/$userId');
    Map<String, dynamic> data = jsonDecode(response);
    _nameController.text = data['response']['name'];
    _emailController.text = data['response']['email'];

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text(
          'Caso não deseje alterar Nome ou E-mail, mantenha os valores originais. Caso não deseje alterar Senha, deixe em branco.'),
      backgroundColor: Colors.blue,
      duration: Duration(seconds: 3),
    ));
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<void> _saveProfile() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (name.isEmpty || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nome e E-mail não podem estar em branco.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 1, microseconds: 500),
        ),
      );
      return;
    }

    final userData = {
      "name": name,
      "email": email,
      "password": password,
    };

    final response = await client.put('/user/$userId', userData);
    Map<String, dynamic> data = jsonDecode(response);
    if (!data['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(data['errors'][0]),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 1, milliseconds: 500),
        ),
      );
    } else {
      await storage.write(key: 'name', value: name).then((value) => value);
      await storage.write(key: 'email', value: email).then((value) => value);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Perfil atualizado com sucesso!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 1),
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar perfil"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              key: const Key('editNameProfileField'),
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nome',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              key: const Key('emailProfileField'),
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'E-mail',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              key: const Key('editPasswordProfileField'),
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Senha',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton.extended(
                  onPressed: _saveProfile,
                  extendedPadding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                  icon: const Icon(Icons.check),
                  label: const Text("Salvar"),
                  heroTag: const Key('saveProfileButton'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
