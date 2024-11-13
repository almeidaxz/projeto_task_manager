import 'package:flutter/material.dart';

class EditReminderPage extends StatefulWidget {
  final String reminderName;
  final String reminderDescription;
  final String reminderDate;
  final String reminderTime;

  const EditReminderPage({
    super.key,
    required this.reminderName,
    required this.reminderDescription,
    required this.reminderDate,
    required this.reminderTime,
  });

  @override
  EditReminderPageState createState() => EditReminderPageState();
}

class EditReminderPageState extends State<EditReminderPage> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _dateController;
  late TextEditingController _timeController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.reminderName);
    _descriptionController =
        TextEditingController(text: widget.reminderDescription);
    _dateController = TextEditingController(text: widget.reminderDate);
    _timeController = TextEditingController(text: widget.reminderTime);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  void _saveReminder() {
    // Lógica para salvar o lembrete editado
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Lembrete atualizado com sucesso!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 1),
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar Lembrete"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Nome",
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: "Descrição",
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _dateController,
              decoration: const InputDecoration(
                labelText: "Data",
              ),
              onTap: () async {
                FocusScope.of(context).requestFocus(FocusNode());
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null) {
                  setState(() {
                    _dateController.text =
                        "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                  });
                }
              },
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _timeController,
              decoration: const InputDecoration(
                labelText: "Hora",
              ),
              onTap: () async {
                FocusScope.of(context).requestFocus(FocusNode());
                TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (pickedTime != null) {
                  setState(() {
                    _timeController.text = pickedTime.format(context);
                  });
                }
              },
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton.extended(
                  onPressed: _saveReminder,
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
