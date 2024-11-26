import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/clients/base_client.dart';

class EditTaskPage extends StatefulWidget {
  final int id;

  const EditTaskPage({super.key, required this.id});

  @override
  EditTaskPageState createState() => EditTaskPageState();
}

class EditTaskPageState extends State<EditTaskPage> {
  late TextEditingController _nameController = TextEditingController();
  late TextEditingController _descriptionController = TextEditingController();
  late TextEditingController _categoryController = TextEditingController();
  late TextEditingController _dateController = TextEditingController();
  late TextEditingController _timeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getTaskDetails();
  }

  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  Future<void> _getTaskDetails() async {
    BaseClient client = BaseClient();
    final response = await client.get('/task/${widget.id}');
    Map<String, dynamic> data = jsonDecode(response);
    if (!data['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Não foi possível buscar os dados da tarefa. Tente novamente mais tarde.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      Navigator.pop(context);
    } else {
      _nameController.text = data['response']['name'];
      _descriptionController.text = data['response']['description'];
      _categoryController.text = data['response']['categories'];
      _dateController.text = data['response']['due_date'];
      _timeController.text = data['response']['due_time'];
    }
  }

  BaseClient client = BaseClient();
  static const userId = 1;
  Future<void> _saveTask() async {
    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();
    final categories = _categoryController.text.trim();
    final due_date = _dateController.text.trim();
    final due_time = _timeController.text.trim();

    if (name.isEmpty || due_date.isEmpty || due_time.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, preencha os campos obrigatórios.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final taskData = {
      "user_id": userId.toString(),
      "name": name,
      "description": description,
      "categories": categories,
      "due_date": due_date,
      "due_time": due_time.split(" ")[0],
    };

    final response = await client.put('/task/${widget.id}', taskData);
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tarefa editada com sucesso!'),
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
        title: const Text("Editar Tarefa"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nome*',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Descrição',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _categoryController,
              decoration: InputDecoration(
                labelText: 'Categoria',
                hintText: 'Insira as categorias separadas por vírgula',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _categoryController.clear();
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _dateController,
              decoration: const InputDecoration(
                labelText: 'Data*',
                border: OutlineInputBorder(),
              ),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2030),
                );
                if (pickedDate != null) {
                  _dateController.text =
                      DateFormat('dd/MM/yyyy').format(pickedDate);
                }
              },
              readOnly: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _timeController,
              decoration: const InputDecoration(
                labelText: 'Hora*',
                border: OutlineInputBorder(),
              ),
              onTap: () async {
                TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                  builder: (BuildContext context, Widget? child) {
                    return MediaQuery(
                      data: MediaQuery.of(context)
                          .copyWith(alwaysUse24HourFormat: true),
                      child: child!,
                    );
                  },
                );
                if (pickedTime != null) {
                  _timeController.text = DateFormat('HH:mm').format(
                      DateTime(0, 0, 0, pickedTime.hour, pickedTime.minute));
                }
              },
              readOnly: true,
            ),
            const SizedBox(height: 32),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton.extended(
                  onPressed: _saveTask,
                  extendedPadding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                  icon: const Icon(Icons.check),
                  label: const Text("Salvar"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
