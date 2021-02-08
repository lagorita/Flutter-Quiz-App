import 'package:denemequiz/state/state_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';

class QuestionDetails extends StatefulWidget {
  @override
  _QuestionDetailsState createState() => _QuestionDetailsState();
}

class _QuestionDetailsState extends State<QuestionDetails> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, _) {
        var currentQuestion = context.read(userViewQuestionState).state;

        return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black87,
              title: Text("${currentQuestion.questionId} in Database"),
              centerTitle: true,
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                            "No ${currentQuestion.questionId}:${currentQuestion.questionText}"),
                        Visibility(
                          visible: currentQuestion.isImageQuestion == 1
                              ? true
                              : false,
                          child: Container(
                            height: MediaQuery.of(context).size.height / 15 * 3,
                            child: Image.network(
                              "${currentQuestion.questionImage}",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            title: Text(
                              "${currentQuestion.answerA}",
                              style: TextStyle(
                                  color: currentQuestion.correctAnswer == "A"
                                      ? Colors.red
                                      : Colors.grey),
                            ),
                            leading: Radio(
                              value: "A",
                              groupValue: currentQuestion.correctAnswer,
                              onChanged: (value) => null,
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            title: Text(
                              "${currentQuestion.answerB}",
                              style: TextStyle(
                                  color: currentQuestion.correctAnswer == "B"
                                      ? Colors.red
                                      : Colors.grey),
                            ),
                            leading: Radio(
                              value: "B",
                              groupValue: currentQuestion.correctAnswer,
                              onChanged: (value) => null,
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            title: Text(
                              "${currentQuestion.answerC}",
                              style: TextStyle(
                                  color: currentQuestion.correctAnswer == "C"
                                      ? Colors.red
                                      : Colors.grey),
                            ),
                            leading: Radio(
                              value: "C",
                              groupValue: currentQuestion.correctAnswer,
                              onChanged: (value) => null,
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            title: Text(
                              "${currentQuestion.answerD}",
                              style: TextStyle(
                                  color: currentQuestion.correctAnswer == "D"
                                      ? Colors.red
                                      : Colors.grey),
                            ),
                            leading: Radio(
                              value: "D",
                              groupValue: currentQuestion.correctAnswer,
                              onChanged: (value) => null,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ));
      },
    );
  }
}
