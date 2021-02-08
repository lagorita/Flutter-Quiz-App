import 'package:denemequiz/databases/question_provider.dart';
import 'package:denemequiz/model/user_answer_model.dart';
import 'package:denemequiz/state/state_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';

void setUserAnswer(BuildContext context, MapEntry<int, Question> e, value) {
  context.read(userListAnswer).state[e.key] =
      context.read(userAnswerSelected).state = new UserAnswer(
          questionId: e.value.questionId,
          answered: value,
          isCorrect: value.toString().isNotEmpty
              ? value.toString().toLowerCase() ==
                  e.value.correctAnswer.toLowerCase()
              : false);
}
