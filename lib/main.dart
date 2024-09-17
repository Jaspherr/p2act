//main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p2act/repository/repository.dart';
import 'package:p2act/screens/list.dart';
import 'bloc/student_bloc.dart';
import 'package:http/http.dart' as http;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    final response = await http.get(Uri.parse('http://localhost:5000/api/students'));

    if (response.statusCode == 200) {
      print('Data fetched from API: ${response.body}');
    } else {
      print('Failed to fetch data: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching data: $e');
  }

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => StudentRepository()),
      ],
      child: BlocProvider(
        create: (context) => StudentBloc(context.read<StudentRepository>())
          ..add(LoadStudents()),
        child: const P2Act(),
      ),
    ),
  );
}

class P2Act extends StatelessWidget {
  const P2Act({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: BlocBuilder<StudentBloc, StudentState>(
          builder: (context, state) {
            if (state is StudentLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is StudentLoaded) {
              return const StudentList();
            } else if (state is StudentError) {
              return Center(child: Text(state.message));
            }
            return Container();
          },
        ),
      ),
    );
  }
}
