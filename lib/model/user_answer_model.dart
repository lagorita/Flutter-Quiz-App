class UserAnswer {
  int questionId;
  String answered;
  bool isCorrect;
  UserAnswer({this.answered, this.isCorrect, this.questionId});

  Map toJson() => {
        "questionId": questionId,
        "answered": answered,
        "isCorrect": isCorrect,
      };
}
