//repository.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/student.dart';

class StudentRepository {
  final String apiUrl = 'https://p2act.onrender.com/api/students';

  Future<List<Student>> fetchStudents() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Student.fromJson(json)).toList();
      } else if (response.statusCode == 404) {
        throw Exception('No students found');
      } else {
        throw Exception('Error loading students: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load students: ${e.toString()}');
    }
  }

  Future<void> addStudent(Student student) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(student.toJson()),
      );

      if (response.statusCode != 201) {
        print('Failed to add student. Status code: ${response.statusCode}, Body: ${response.body}');
        throw Exception('Failed to add student');
      }
    } catch (e) {
      print('Exception while adding student: $e');
      throw Exception('Failed to add student: ${e.toString()}');
    }
  }

  Future<void> updateStudent(Student student) async {
    try {
      final response = await http.put(
        Uri.parse('$apiUrl/${student.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(student.toJson()),
      );
      if (response.statusCode == 200) {
        print('Student updated successfully.');
      } else {
        print('Failed to update student. Status code: ${response.statusCode}, Body: ${response.body}');
        throw Exception('Failed to update student: ${response.body}');
      }
    } catch (e) {
      print('Exception while updating student: $e');
      throw Exception('Failed to update student: ${e.toString()}');
    }
  }

  Future<void> deleteStudent(String studentId) async {
    try {
      final response = await http.delete(
        Uri.parse('$apiUrl/$studentId'),
      );

      if (response.statusCode == 204 || response.statusCode == 200) {
        print('Successfully deleted student with ID: $studentId');
      } else {
        print('Failed to delete student. Status code: ${response.statusCode}, Body: ${response.body}');
        throw Exception('Failed to delete student');
      }
    } catch (e) {
      print('Exception while deleting student: $e');
      throw Exception('Failed to delete student: ${e.toString()}');
    }
  }
}