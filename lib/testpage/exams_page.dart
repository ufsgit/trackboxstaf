import 'package:breffini_staff/testpage/exam_modal.dart';
import 'package:breffini_staff/testpage/student_list_screen.dart';
import 'package:flutter/material.dart';

class ExamsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Exams")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: exams.length,
        itemBuilder: (context, index) {
          final exam = exams[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              title: Text(
                exam.examName,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text("Date: ${exam.date}"),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TeacherStudentsListScreen(
                      students: exam.students, // 👈 IMPORTANT
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
