class Question {
  final String question;
  final List<String> options;
  int correctAnswerIndex;

  Question({
    required this.correctAnswerIndex,
    required this.question,
    required this.options,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      question: json['question'],
      options: List<String>.from(json['options']),
      correctAnswerIndex: json['correctAnswerIndex'],
    );
  }
}
