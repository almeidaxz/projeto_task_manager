import 'package:flutter/material.dart';

class AddTaskPage extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  AddTaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nova Tarefa"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nome*',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Descrição',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: categoryController,
              decoration: InputDecoration(
                labelText: 'Categoria',
                hintText: 'Insira as categorias separadas por vírgula',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    categoryController.clear();
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: dateController,
              decoration: const InputDecoration(
                labelText: 'Data',
                border: OutlineInputBorder(),
              ),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null) {
                  dateController.text =
                      "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                }
              },
              readOnly: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: timeController,
              decoration: const InputDecoration(
                labelText: 'Hora',
                border: OutlineInputBorder(),
              ),
              onTap: () async {
                TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (pickedTime != null) {
                  timeController.text = pickedTime.format(context);
                }
              },
              readOnly: true,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                // Adicionar a lógica para salvar a tarefa
              },
              icon: const Icon(Icons.check),
              label: const Text("Adicionar"),
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0)),
            ),
          ],
        ),
      ),
    );
  }
}
