import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:denemequiz/const/const.dart';
import 'package:denemequiz/databases/db_helper.dart';
import 'package:denemequiz/databases/question_provider.dart';
import 'package:denemequiz/model/user_answer_model.dart';
import 'package:denemequiz/state/state_manager.dart';
import 'package:denemequiz/widgets/countdown.dart';
import 'package:denemequiz/widgets/question_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';

class TestModePage extends StatefulWidget {
  @override
  _TestModePageState createState() => _TestModePageState();
}

class _TestModePageState extends State<TestModePage>
    with SingleTickerProviderStateMixin {
  CarouselController carouselController = CarouselController();
  List<UserAnswer> userAnswers = new List<UserAnswer>();
  AnimationController _animationController;
  @override
  void dispose() {
    // TODO: implement dispose
    if (_animationController.isAnimating || _animationController.isCompleted)
      _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: Duration(seconds: limitTime));
    _animationController.addListener(() {
      if (_animationController.isCompleted) {
        Navigator.of(context).pop();
        Navigator.pushNamed(context, "/resultPage");
      }
    });
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
          appBar: AppBar(
            title: Text("Quiz"),
            centerTitle: true,
            backgroundColor: Colors.black87,
          ),
          body: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: () {
                        showAnswerSheet();
                      },
                      child: Column(
                        children: [
                          Icon(
                            Icons.note,
                            color: Colors.black87,
                          ),
                          Text(
                            "Answer Sheet",
                            style: TextStyle(color: Colors.black87),
                          )
                        ],
                      )),
                  CountDown(
                    animation: StepTween(begin: limitTime, end: 0)
                        .animate(_animationController),
                  ),
                  TextButton(
                      onPressed: () {
                        submitTest();
                      },
                      child: Column(
                        children: [
                          Icon(
                            Icons.done,
                            color: Colors.black87,
                          ),
                          Text(
                            "Submit",
                            style: TextStyle(color: Colors.black87),
                          )
                        ],
                      ))
                ],
              ),
              FutureBuilder(
                future: getQuestion(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text("${snapshot.error}"),
                    );
                  } else if (snapshot.hasData) {
                    return Container(
                      margin: const EdgeInsets.all(4),
                      child: Card(
                        color: Colors.blueGrey,
                        elevation: 8,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: QuestionBody(
                            carouselController: carouselController,
                            context: context,
                            questions: snapshot.data,
                            userAnswers: userAnswers,
                          ),
                        ),
                      ),
                    );
                  } else
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                },
              )
            ],
          )),
      onWillPop: () async {
        closeExamDialog();
        return true;
      },
    );
  }

  Future<List<Question>> getQuestion() async {
    var db = await copyDB();
    var result = await QuestionProvider().getQuestions(db);
    userAnswers.clear();
    result.forEach((element) {
      userAnswers.add(new UserAnswer(
        questionId: element.questionId,
        answered: "",
        isCorrect: false,
      ));
    });
    context.read(userListAnswer).state = userAnswers;
    return result;
  }

  void showAnswerSheet() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Answer Sheet"),
        content: Container(
          width: MediaQuery.of(context).size.height / 4,
          child: GridView.count(
            crossAxisCount: 2,
            children: context
                .read(userListAnswer)
                .state
                .asMap()
                .entries
                .map((e) => Builder(builder: (context) {
                      return GestureDetector(
                        onTap: () {
                          carouselController.animateToPage(e.key);
                          Navigator.of(context).pop();
                        },
                        child: Row(
                          children: [
                            AutoSizeText("No ${e.key + 1}:"),
                            AutoSizeText(
                              " ${e.value.answered}",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      );
                    }))
                .toList(),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Close", style: TextStyle(color: Colors.black87))),
        ],
      ),
    );
  }

  void submitTest() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Close"),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[Text("Do you really want to submit the exam ?")],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("No", style: TextStyle(color: Colors.black87))),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, "/resultPage");
              },
              child: Text("Yes", style: TextStyle(color: Colors.black87))),
        ],
      ),
    );
  }

  void closeExamDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Finish"),
        content: Text(
            "Do you really want to quit the exam?\nThe questions you marked will be deleted. "),
        actions: <Widget>[
          TextButton(
            child: Text('No', style: TextStyle(color: Colors.black87)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Yes', style: TextStyle(color: Colors.black87)),
            onPressed: () {
              context.read(isTestMode).state = false;
              Navigator.of(context).pop();
              Navigator.pushNamed(context, "/homePage");
            },
          ),
        ],
      ),
    );
  }
}
