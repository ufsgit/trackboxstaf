class StudentResult {
  final String studentName;
  final int score;
  final int total;
  final List<QuestionAnswer> answers;

  StudentResult({
    required this.studentName,
    required this.score,
    required this.total,
    required this.answers,
  });
}

class QuestionAnswer {
  final String question;
  final String studentAnswer;
  final String correctAnswer;

  QuestionAnswer({
    required this.question,
    required this.studentAnswer,
    required this.correctAnswer,
  });

  bool get isCorrect => studentAnswer == correctAnswer;
}

final List<StudentResult> studentResults = [
  StudentResult(
    studentName: "Deepa Sebastin",
    score: 1,
    total: 2,
    answers: [
      QuestionAnswer(
        question: "What is Flutter?",
        studentAnswer: "Framework",
        correctAnswer: "Framework",
      ),
      QuestionAnswer(
        question: "Flutter developed by?",
        studentAnswer: "Facebook",
        correctAnswer: "Google",
      ),
    ],
  ),
  StudentResult(
    studentName: "Reeba Mareena",
    score: 1,
    total: 2,
    answers: [
      QuestionAnswer(
        question: "Dart is?",
        studentAnswer: "Language",
        correctAnswer: "Language",
      ),
      QuestionAnswer(
        question: "Flutter UI uses?",
        studentAnswer: "XML",
        correctAnswer: "Widgets",
      ),
    ],
  ),
];
