import 'package:denemequiz/const/const.dart';
import 'package:sqflite/sqflite.dart';

class Question {
  int questionId, isImageQuestion, categoryId;
  String questionText,
      questionImage,
      answerA,
      answerB,
      answerC,
      answerD,
      correctAnswer;
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      cQuestionId: questionId,
      cQuestionCategoryId: categoryId,
      cQuestionIsImage: isImageQuestion,
      cQuestionText: questionText,
      cQuestionImage: questionImage,
      cQuestionAnswerA: answerA,
      cQuestionAnswerB: answerB,
      cQuestionAnswerC: answerC,
      cQuestionAnswerD: answerD,
      cQuestionCorrectAnswer: correctAnswer
    };
    return map;
  }

  Question();

  Question.fromMap(Map<String, dynamic> map) {
    questionId = map[cQuestionId];
    categoryId = map[cQuestionCategoryId];
    isImageQuestion = map[cQuestionIsImage];
    questionText = map[cQuestionText];
    questionImage = map[cQuestionImage];
    answerA = map[cQuestionAnswerA];
    answerB = map[cQuestionAnswerB];
    answerC = map[cQuestionAnswerC];
    answerD = map[cQuestionAnswerD];
    correctAnswer = map[cQuestionCorrectAnswer];
  }
}

class QuestionProvider {
  Future<List<Question>> getQuestionByCategoryId(Database db, int id) async {
    var maps = await db.query(tableQuestionName,
        columns: [
          cQuestionId,
          cQuestionImage,
          cQuestionText,
          cQuestionAnswerA,
          cQuestionAnswerB,
          cQuestionAnswerC,
          cQuestionAnswerD,
          cQuestionCorrectAnswer,
          cQuestionIsImage,
          cQuestionCategoryId,
        ],
        where: "$cQuestionCategoryId=?",
        whereArgs: [id]);
    if (maps.length > 0)
      return maps.map((question) => Question.fromMap(question)).toList();
    return null;
  }

  Future<Question> getQuestionById(Database db, int id) async {
    var maps = await db.query(tableQuestionName,
        columns: [
          cQuestionId,
          cQuestionImage,
          cQuestionText,
          cQuestionAnswerA,
          cQuestionAnswerB,
          cQuestionAnswerC,
          cQuestionAnswerD,
          cQuestionCorrectAnswer,
          cQuestionIsImage,
          cQuestionCategoryId,
        ],
        where: "$cQuestionId=?",
        whereArgs: [id]);
    if (maps.length > 0) return Question.fromMap(maps.first);
    return null;
  }

  Future<List<Question>> getQuestions(Database db) async {
    var maps = await db.query(tableQuestionName,
        columns: [
          cQuestionId,
          cQuestionImage,
          cQuestionText,
          cQuestionAnswerA,
          cQuestionAnswerB,
          cQuestionAnswerC,
          cQuestionAnswerD,
          cQuestionCorrectAnswer,
          cQuestionIsImage,
          cQuestionCategoryId,
        ],
        limit: 30,
        orderBy: "Random()");
    if (maps.length > 0)
      return maps.map((question) => Question.fromMap(question)).toList();
    return null;
  }
}
