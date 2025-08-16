import 'package:flutter/material.dart';
import 'package:infoklub/app/theme.dart';
import 'package:infoklub/models/reminder/reminder.dart';
import 'package:infoklub/viewmodels/Reminders/reminders_viewmodel.dart';
import 'package:provider/provider.dart';

class AddReminder extends StatefulWidget {
  const AddReminder({super.key});

  @override
  State<AddReminder> createState() => _AddReminderState();
}

class _AddReminderState extends State<AddReminder> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final List<int> _repeatDays = [];
  Color _selectedColor = Colors.blue;

  final List<Color> _colorOptions = [
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.red,
    Colors.teal,
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  void _toggleDay(int dayIndex) {
    setState(() {
      _repeatDays.contains(dayIndex)
          ? _repeatDays.remove(dayIndex)
          : _repeatDays.add(dayIndex);
    });
  }

  void _submitReminder() async {
    if (!_formKey.currentState!.validate()) {
      print("❌ Form not valid!");
      return;
    }

    final vm = Provider.of<RemindersViewModel>(context, listen: false);

    DateTime? finalDt;
    if (_selectedDate != null) {
      final time = _selectedTime ?? const TimeOfDay(hour: 9, minute: 0);
      finalDt = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        time.hour,
        time.minute,
      );
    }

    final newReminder = Reminder(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
      dateTime: finalDt,
      isCompleted: false,
      colorValue: _selectedColor.value,
      repeatDays: _repeatDays.isNotEmpty ? List<int>.from(_repeatDays) : null,
      userEmail: vm.currentUserEmail, // ✅ from VM
    );

    print("🟢 Creating reminder:");
    print("   id: ${newReminder.id}");
    print("   title: ${newReminder.title}");
    print("   notes: ${newReminder.notes}");
    print("   dateTime: ${newReminder.dateTime}");
    print("   isCompleted: ${newReminder.isCompleted}");
    print("   colorValue: ${newReminder.colorValue}");
    print("   repeatDays: ${newReminder.repeatDays}");
    print("   userEmail: ${newReminder.userEmail}");

    try {
      await vm.addReminder(newReminder);

      print("✅ Reminder saved to VM/Hive");
      if (mounted) Navigator.pop(context);
    } catch (e, s) {
      print("❌ Error saving reminder: $e");
      print(s);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      shadowColor: Colors.black.withOpacity(0.5),
      surfaceTintColor: Colors.white,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Add New Reminder',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.secondaryColor),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextFormField(
                style: const TextStyle(color: Colors.black),
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  labelStyle: const TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                ),
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? 'Please enter a title'
                    : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                style: const TextStyle(color: Colors.black),
                controller: _notesController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Notes',
                  labelStyle: const TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectDate(context),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          _selectedDate == null
                              ? 'Select Date'
                              : 'Date: ${_selectedDate!.toLocal().toString().split(' ')[0]}',
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectTime(context),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          _selectedTime == null
                              ? 'Select Time'
                              : 'Time: ${_selectedTime!.format(context)}',
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              const Text('Repeat on:', style: TextStyle(color: Colors.black)),
              const SizedBox(height: 10),
              SizedBox(
                height: 50,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(7, (index) {
                      return GestureDetector(
                        onTap: () => _toggleDay(index),
                        child: Container(
                          width: 40,
                          height: 40,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            color: _repeatDays.contains(index)
                                ? AppTheme.secondaryColor
                                : Colors.transparent,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppTheme.secondaryColor),
                          ),
                          child: Center(
                            child: Text(
                              const ['S', 'M', 'T', 'W', 'T', 'F', 'S'][index],
                              style: TextStyle(
                                color: _repeatDays.contains(index)
                                    ? Colors.white
                                    : AppTheme.secondaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              const Text('Select Color:',
                  style: TextStyle(color: Colors.black)),
              const SizedBox(height: 5),
              SizedBox(
                height: 50,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _colorOptions.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    final color = _colorOptions[index];
                    return GestureDetector(
                      onTap: () => setState(() => _selectedColor = color),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: _selectedColor == color
                              ? Border.all(color: Colors.black, width: 2)
                              : null,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.secondaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: _submitReminder,
                child: const Text('Add Reminder',
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
