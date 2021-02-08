// import 'package:denemequiz/screens/home_page.dart';
// import 'package:denemequiz/screens/read_mode.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/all.dart';

// void main() {
//   runApp(ProviderScope(child: MyApp()));
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       routes: {
//         "/homePage": (context) => HomePage(),
//         "/readModePage": (context) => ReadModePage()
//       },
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key key, this.title}) : super(key: key);

//   final String title;

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//     //  Navigator.of(context).pop();
//       Navigator.pushNamed(context, "/homePage");
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Center(),
//     );
//   }
// }
