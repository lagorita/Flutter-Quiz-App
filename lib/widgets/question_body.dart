import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:denemequiz/databases/question_provider.dart';
import 'package:denemequiz/model/user_answer_model.dart';
import 'package:denemequiz/state/state_manager.dart';
import 'package:denemequiz/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';

class QuestionBody extends StatelessWidget {
  QuestionBody(
      {this.carouselController,
      this.context,
      this.questions,
      this.userAnswers});
  List<UserAnswer> userAnswers;
  List<Question> questions;
  CarouselController carouselController;
  BuildContext context;
  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      carouselController: carouselController,
      items: questions
          .asMap()
          .entries
          .map((e) => Builder(builder: (context) {
                return Consumer(
                  builder: (context, watch, _) {
                    var userAnswerState = watch(userAnswerSelected).state;
                    var isShowAnswer = watch(isEnableShowAnswer).state;
                    return Column(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Text(context.read(isTestMode).state
                                  ? "No ${e.key + 1}:${e.value.questionText}"
                                  : "No ${e.value.questionId}:${e.value.questionText}"),
                              Visibility(
                                visible:
                                    e.value.isImageQuestion == 1 ? true : false,
                                child: Container(
                                  height: MediaQuery.of(context).size.height /
                                      15 *
                                      3,
                                  child: Image.network(
                                    "${e.value.questionImage}",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ListTile(
                                  title: Text(
                                    "${e.value.answerA}",
                                    style: TextStyle(
                                        color: isShowAnswer
                                            ? e.value.correctAnswer == "A"
                                                ? Colors.red
                                                : Colors.grey
                                            : Colors.black),
                                  ),
                                  leading: Radio(
                                    activeColor: Colors.black,
                                    value: "A",
                                    groupValue: getGroupValue(
                                        isShowAnswer, e, userAnswerState),
                                    onChanged: (value) =>
                                        setUserAnswer(context, e, value),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ListTile(
                                  title: Text(
                                    "${e.value.answerB}",
                                    style: TextStyle(
                                        color: isShowAnswer
                                            ? e.value.correctAnswer == "B"
                                                ? Colors.red
                                                : Colors.grey
                                            : Colors.black),
                                  ),
                                  leading: Radio(
                                      activeColor: Colors.black,
                                      value: "B",
                                      groupValue: getGroupValue(
                                          isShowAnswer, e, userAnswerState),
                                      onChanged: (value) =>
                                          setUserAnswer(context, e, value)),
                                ),
                              ),
                              Expanded(
                                child: ListTile(
                                  title: Text(
                                    "${e.value.answerC}",
                                    style: TextStyle(
                                        color: isShowAnswer
                                            ? e.value.correctAnswer == "C"
                                                ? Colors.red
                                                : Colors.grey
                                            : Colors.black),
                                  ),
                                  leading: Radio(
                                      activeColor: Colors.black,
                                      value: "C",
                                      groupValue: getGroupValue(
                                          isShowAnswer, e, userAnswerState),
                                      onChanged: (value) =>
                                          setUserAnswer(context, e, value)),
                                ),
                              ),
                              Expanded(
                                child: ListTile(
                                  title: Text(
                                    "${e.value.answerD}",
                                    style: TextStyle(
                                        color: isShowAnswer
                                            ? e.value.correctAnswer == "D"
                                                ? Colors.red
                                                : Colors.grey
                                            : Colors.black),
                                  ),
                                  leading: Radio(
                                      activeColor: Colors.black,
                                      value: "D",
                                      groupValue: getGroupValue(
                                          isShowAnswer, e, userAnswerState),
                                      onChanged: (value) =>
                                          setUserAnswer(context, e, value)),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    );
                  },
                );
              }))
          .toList(),
      options: CarouselOptions(
        onPageChanged: (page, _) {
          context.read(currentReadPage).state = page;

          context.read(isEnableShowAnswer).state = false;
        },
        autoPlay: false,
        enlargeCenterPage: true,
        viewportFraction: 0.9,
        initialPage: 0,
        height: MediaQuery.of(context).size.height / 5 * 3,
      ),
    );
  }

  getGroupValue(bool isShowAnswer, MapEntry<int, Question> e,
      UserAnswer userAnswerState) {
    return isShowAnswer
        ? e.value.correctAnswer
        : context.read(isTestMode).state
            ? context.read(userListAnswer).state[e.key].answered
            : "";
  }
}
