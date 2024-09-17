//form.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../bloc/student_bloc.dart';
import '../model/student.dart';

class StudentForm extends StatefulWidget {
  final Student? student;

  const StudentForm({super.key, this.student});

  @override
  _StudentFormState createState() => _StudentFormState();
}

class _StudentFormState extends State<StudentForm> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _courseController = TextEditingController();
  String _selectedYear = "First Year";
  bool _isEnrolled = false;

  @override
  void initState() {
    super.initState();
    if (widget.student != null) {
      _firstNameController.text = widget.student!.firstname;
      _lastNameController.text = widget.student!.lastname;
      _courseController.text = widget.student!.course;
      _selectedYear = widget.student!.year;
      _isEnrolled = widget.student!.enrolled;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(widget.student == null ? 'Add Student' : 'Edit Student', style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _firstNameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        labelText: 'First Name',
                        prefixIcon: const Icon(Icons.person),
                      ),
                      validator: (value) => value == null || value.isEmpty ? 'First name is required' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _lastNameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        labelText: 'Last Name',
                        prefixIcon: const Icon(Icons.person),
                      ),
                      validator: (value) => value == null || value.isEmpty ? 'Last name is required' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _courseController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        labelText: 'Course Name',
                        prefixIcon: const Icon(Icons.book),
                      ),
                      validator: (value) => value == null || value.isEmpty ? 'Course name is required' : null,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedYear,
                      items: const [
                        DropdownMenuItem(value: 'First Year', child: Text('First Year')),
                        DropdownMenuItem(value: 'Second Year', child: Text('Second Year')),
                        DropdownMenuItem(value: 'Third Year', child: Text('Third Year')),
                        DropdownMenuItem(value: 'Fourth Year', child: Text('Fourth Year')),
                        DropdownMenuItem(value: 'Fifth Year', child: Text('Fifth Year')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedYear = value!;
                        });
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        labelText: 'Year',
                        prefixIcon: const Icon(Icons.calendar_today),
                      ),
                      validator: (value) => value == null ? 'Year is required' : null,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Text('Enrolled', style: TextStyle(fontSize: 16)),
                        const Spacer(),
                        Switch(
                          value: _isEnrolled,
                          onChanged: (value) {
                            setState(() {
                              _isEnrolled = value;
                            });
                          },
                        )
                      ],
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () async {
                        if (_firstNameController.text.isEmpty ||
                            _lastNameController.text.isEmpty ||
                            _courseController.text.isEmpty ||
                            _selectedYear.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please fill in all fields')),
                          );
                          return;
                        }
                        
                        final student = Student(
                          id: widget.student?.id ?? const Uuid().v4(),
                          firstname: _firstNameController.text,
                          lastname: _lastNameController.text,
                          course: _courseController.text,
                          year: _selectedYear,
                          enrolled: _isEnrolled,
                        );
                        try {
                          if (widget.student == null) {
                            context.read<StudentBloc>().add(AddStudent(student));
                          } else {
                            context.read<StudentBloc>().add(UpdateStudent(student));
                          }
                          Navigator.pop(context);
                        } catch (e) {
                          print('Error adding or updating student: $e');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Failed to save student: $e'),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(widget.student == null ? 'Submit' : 'Update'),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}