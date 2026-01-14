import 'student_test_modal.dart';

class Exam {
  final String examName;
  final String date;
  final List<StudentResult> students;

  Exam({
    required this.examName,
    required this.date,
    required this.students,
  });
}

final List<Exam> exams = [
  Exam(
    examName: "Flutter Basics Test",
    date: "02 Jan 2025",
    students: studentResults, // 👈 your existing list
  ),
  Exam(
    examName: "Dart Language Test",
    date: "28 Dec 2024",
    students: [
      StudentResult(
        studentName: "Anu",
        score: 2,
        total: 2,
        answers: [
          QuestionAnswer(
            question: "Dart is?",
            studentAnswer: "Language",
            correctAnswer: "Language",
          ),
        ],
      ),
    ],
  ),
];
