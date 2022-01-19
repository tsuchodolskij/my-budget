import 'package:flutter/material.dart';
import 'package:my_budget/page/budget.dart';
import 'package:my_budget/page/categories.dart';
import 'package:my_budget/page/status.dart';
import 'package:my_budget/preferences/budget_preferences.dart';
import 'package:my_budget/preferences/categories_preferences.dart';
import 'package:my_budget/util/data_sample.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CategoriesPreferences.init();
  await BudgetPreferences.init();
  await DataSample.mock();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Budget',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'My Budget'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            indicatorColor: Colors.amberAccent,
            tabs: [
              Tab(text: 'Stan'),
              Tab(text: 'Budżet'),
              Tab(text: 'Kategorie'),
            ],
          ),
          title: Text('My budget'),
        ),
        body: TabBarView(
          children: [
            Status(),
            Budget(),
            Categories(),
          ],
        ),
      )
    );
  }
}
