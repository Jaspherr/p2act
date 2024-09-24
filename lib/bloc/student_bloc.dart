//student_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:p2act/model/student.dart';
import 'package:p2act/repository/repository.dart';
part 'student_event.dart';
part 'student_state.dart';

class StudentBloc extends Bloc<StudentEvent, StudentState> {
  final StudentRepository repository;

  StudentBloc(this.repository) : super(StudentLoading()) {
    on<LoadStudents>((event, emit) async {
      try {
        final students = await repository.fetchStudents();
        print('Data loaded: ${students.length} students found');
        if (students.isEmpty) {
          print('No students in the database');
        }
        emit(StudentLoaded(students));
      } catch (e) {
        emit(const StudentError("Failed to load students"));
      }
    });

    on<AddStudent>((event, emit) async {
      if (state is StudentLoaded) {
        try {
          await repository.addStudent(event.student);
          print('Student added: ${event.student}');
          
          // Refetch the latest students after adding
          final students = await repository.fetchStudents();
          emit(StudentLoaded(students));
        } catch (e) {
          print('Error adding student: $e');
          emit(const StudentError("Failed to add student"));
        }
      } else {
        print('State is not StudentLoaded');
      }
    });

    on<UpdateStudent>((event, emit) async {
      if (state is StudentLoaded) {
        try {
          await repository.updateStudent(event.student);
          print('Student updated: ${event.student}');
          
          // Refetch the latest students after updating
          final students = await repository.fetchStudents();
          emit(StudentLoaded(students));
        } catch (e) {
          print('Error updating student: $e');
          emit(const StudentError("Failed to update student"));
        }
      }
    });

    on<DeleteStudent>((event, emit) async {
      if (state is StudentLoaded) {
        try {
          await repository.deleteStudent(event.studentId);
          print('Successfully deleted student with ID: ${event.studentId}');
          
          // Refetch the latest students after deleting
          final students = await repository.fetchStudents();
          emit(StudentLoaded(students));
        } catch (e) {
          print('Error deleting student: $e');
          emit(StudentError('Failed to delete student: $e'));
        }
      }
    });
  }
}