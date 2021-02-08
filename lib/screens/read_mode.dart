import 'package:carousel_slider/carousel_slider.dart';
import 'package:denemequiz/databases/db_helper.dart';
import 'package:denemequiz/databases/question_provider.dart';
import 'package:denemequiz/model/user_answer_model.dart';
import 'package:denemequiz/state/state_manager.dart';
import 'package:denemequiz/widgets/question_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReadModePage extends StatefulWidget {
  @override
  _ReadModePageState createState() => _ReadModePageState();
}

class _ReadModePageState extends State<ReadModePage> {
  CarouselController carouselController = CarouselController();
  SharedPreferences prefs;
  List<UserAnswer> userAnswer = new List<UserAnswer>();

  int indexPage = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      prefs = await SharedPreferences.getInstance();
      indexPage =
          prefs.getInt("${context.read(questionCategoryState).state.id}");
    });
    Future.delayed(Duration(milliseconds: 500)).then((value) =>
        carouselController.animateToPage(indexPage == null ? 0 : indexPage));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Consumer(
        builder: (context, watch, child) {
          var questionModule = context.read(questionCategoryState).state;
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black87,
              title: Text("${questionModule.name}"),
              centerTitle: true,
            ),
            body: FutureBuilder<List<Question>>(
              future: getQuestionByid(questionModule.id),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text("${snapshot.error}"),
                  );
                }
                if (snapshot.hasData) {
                  return Container(
                    margin: const EdgeInsets.all(4),
                    child: Card(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              child: QuestionBody(
                                carouselController: carouselController,
                                context: context,
                                questions: snapshot.data,
                                userAnswers: userAnswer,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton(
                                    onPressed: () {
                                      setState(() {
                                        context.read(isEnableShowAnswer).state =
                                            true;
                                      });
                                    },
                                    child: Text("Show Answer",style: TextStyle(color: Color(0xFF022970)),))
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                } else
                  return Center(
                    child: CircularProgressIndicator(),
                  );
              },
            ),
          );
        },
      ),
      onWillPop: () async {
        showCloseDialog();
        return true;
      },
    );
  }

  Future<List<Question>> getQuestionByid(int id) async {
    var db = await copyDB();
    var result = await QuestionProvider().getQuestionByCategoryId(db, id);
    return result;
  }

  showCloseDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Close"),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text("Do you want to save this question index?")
            ],
          ),
        ),
        actions: [
          TextButton(

              onPressed: () {
                context.read(isEnableShowAnswer).state = false;

                Navigator.of(context).pop();
                Navigator.pop(context);
              },
              child: Text("No",style: TextStyle(color: Colors.black87),)),
          TextButton(
              onPressed: () {
                prefs.setInt("${context.read(questionCategoryState).state.id}",
                    context.read(currentReadPage).state);
                context.read(isEnableShowAnswer).state = false;
                Navigator.of(context).pop();
                Navigator.pop(context);
              },
              child: Text("Yes",style: TextStyle(color: Colors.black87))),
        ],
      ),
    );
  }
}
