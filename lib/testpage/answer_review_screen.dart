import 'package:breffini_staff/testpage/student_test_modal.dart';
import 'package:flutter/material.dart';

class StudentAnswerReviewScreen extends StatelessWidget {
  final StudentResult result;

  const StudentAnswerReviewScreen({required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Answer Review")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              result.studentName,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              "Score: ${result.score}/${result.total}",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: result.answers.length,
                itemBuilder: (context, index) {
                  final ans = result.answers[index];

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Q${index + 1}. ${ans.question}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "Student Answer: ${ans.studentAnswer}",
                            style: TextStyle(
                              color: ans.isCorrect ? Colors.green : Colors.red,
                            ),
                          ),
                          Text(
                            "Correct Answer: ${ans.correctAnswer}",
                            style: TextStyle(color: Colors.green),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Icon(
                              ans.isCorrect ? Icons.check_circle : Icons.cancel,
                              color: ans.isCorrect ? Colors.green : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
