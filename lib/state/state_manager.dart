import 'package:denemequiz/databases/category_provider.dart';
import 'package:denemequiz/databases/question_provider.dart';
import 'package:denemequiz/model/user_answer_model.dart';
import 'package:flutter_riverpod/all.dart';

final categoryListProvider =
    StateNotifierProvider((ref) => new CategoryList([]));
final questionCategoryState = StateProvider((ref) => Category());
final currentReadPage = StateProvider((ref) => 0);
final isTestMode = StateProvider((ref) => false);
final isEnableShowAnswer = StateProvider((ref) => false);
final userAnswerSelected = StateProvider((ref) => new UserAnswer());
final userListAnswer = StateProvider((ref) => List<UserAnswer>());
final userViewQuestionState = StateProvider((ref) => Question());
