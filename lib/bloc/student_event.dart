//student_event.dart
part of 'student_bloc.dart';

abstract class StudentEvent extends Equatable {
  const StudentEvent();

  @override
  List<Object> get props => [];
}

class LoadStudents extends StudentEvent {}

class AddStudent extends StudentEvent {
  final Student student;

  const AddStudent(this.student);

  @override
  List<Object> get props => [student];
}

class UpdateStudent extends StudentEvent {
  final Student student;

  const UpdateStudent(this.student);

  @override
  List<Object> get props => [student];
}

class DeleteStudent extends StudentEvent {
  final String studentId;

  const DeleteStudent(this.studentId);

  @override
  List<Object> get props => [studentId];
}
