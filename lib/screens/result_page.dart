import 'package:auto_size_text/auto_size_text.dart';
import 'package:denemequiz/databases/db_helper.dart';
import 'package:denemequiz/databases/question_provider.dart';
import 'package:denemequiz/state/state_manager.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:flutter_riverpod/all.dart';

class ResultPage extends StatefulWidget {
  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Results"),
          centerTitle: true,
          backgroundColor: Colors.black87,
        ),
        body: Column(
          children: [
            AutoSizeText("Limit"),
            LinearPercentIndicator(
              backgroundColor: Colors.grey,
              percent: ((context
                      .read(userListAnswer)
                      .state
                      .where((element) => element.answered != "")
                      .toList()
                      .length) /
                  context.read(userListAnswer).state.length),
              lineHeight: 15,
              progressColor: Color(0xFF022970),
            ),
            AutoSizeText(
                "Your mark: ${((10 / context.read(userListAnswer).state.toList().length) * context.read(userListAnswer).state.where((element) => element.answered != "").toList().length).toStringAsFixed(1)}/10"),
            LinearPercentIndicator(
              backgroundColor: Color(0xFF6B5B5B),
              percent: (context
                      .read(userListAnswer)
                      .state
                      .where((element) => element.isCorrect)
                      .toList()
                      .length /
                  context.read(userListAnswer).state.length),
              lineHeight: 15,
              progressColor: Color(0xFF94030F),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        color: Color(0xFF0A5420),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Correct Answer")
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        color: Color(0xFF780424),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Wrong Answer")
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        color: Colors.blueGrey,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Not Done")
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 5,
                children: context
                    .read(userListAnswer)
                    .state
                    .asMap()
                    .entries
                    .map((e) => Builder(builder: (context) {
                          return GestureDetector(
                            onTap: () async {
                              var questionNeedView =
                                  await getQuestionById(e.value.questionId);
                              context.read(userViewQuestionState).state =
                                  questionNeedView;
                              Navigator.pushNamed(
                                  context, "/questionDetailsPage");
                            },
                            child: Card(
                              color: e.value.answered.isEmpty
                                  ? Colors.blueGrey
                                  : e.value.isCorrect
                                      ? Color(0xFF0A5420)
                                      : Color(0xFF780424),
                              elevation: 4,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AutoSizeText(
                                    "No ${e.key + 1}\n ${e.value.answered}",
                                    style: TextStyle(
                                      color: e.value.answered.isEmpty
                                          ? Colors.black
                                          : Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }))
                    .toList(),
              ),
            )
          ],
        ),
      ),
      onWillPop: () async {
        Navigator.pushNamed(context, "/homePage");
        return true;
      },
    );
  }

  Future<Question> getQuestionById(int id) async {
    var db = await copyDB();
    var result = await QuestionProvider().getQuestionById(db, id);
    return result;
  }
}
