import 'package:denemequiz/databases/category_provider.dart';
import 'package:denemequiz/databases/db_helper.dart';
import 'package:denemequiz/screens/question_details.dart';
import 'package:denemequiz/screens/read_mode.dart';
import 'package:denemequiz/screens/result_page.dart';
import 'package:denemequiz/screens/test_mode.dart';
import 'package:denemequiz/state/state_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';

void main() {
  runApp(ProviderScope(child: ProviderScope(child: MainPage())));
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        "/homePage": (context) => HomePage(),
        "/readModePage": (context) => ReadModePage(),
        "/testModePage": (context) => TestModePage(),
        "/resultPage": (context) => ResultPage(),
        "/questionDetailsPage": (context) => QuestionDetails(),
      },
      title: 'Flutter Demo',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text("Flutter Quiz"),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Category>>(
        future: getCategories(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("${snapshot.error}"),
            );
          } else if (snapshot.hasData) {
            Category examCard = new Category();
            examCard.id = -1;
            examCard.name = "Exam";
            snapshot.data.add(examCard);
            return GridView.count(
              crossAxisCount: 2,
              children: snapshot.data
                  .map((e) => Builder(builder: (context) {
                        return GestureDetector(
                          onTap: () {
                            if (e.id == -1) {
                              context.read(isTestMode).state = true;
                              Navigator.pushNamed(context, "/testModePage");
                            } else {
                              context.read(questionCategoryState).state = e;
                              Navigator.pushNamed(context, "/readModePage");
                            }
                          },
                          child: Card(
                            color: e.id == -1 ? Colors.grey : Colors.black87,
                            elevation: 4,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "${e.name}",
                                  style: TextStyle(
                                      color: e.id == -1
                                          ? Colors.black
                                          : Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        );
                      }))
                  .toList(),
            );
          } else
            return Center(
              child: CircularProgressIndicator(),
            );
        },
      ),
    );
  }

  Future<List<Category>> getCategories() async {
    var db = await copyDB();
    var result = await CategoryProvider().getCategories(db);
    context.read(categoryListProvider).state = result;

    return result;
  }
}
