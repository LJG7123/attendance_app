import 'package:check_in_app/screens/check_in_out_screen.dart';
import 'package:check_in_app/screens/check_list_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(title: 'Check In Out'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;
  final _widgets = [
    const CheckInOutScreen(),
    const CheckListScreen(),
  ];

  MyHomePage({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _widgets.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          bottom: const TabBar(tabs: [
            Tab(icon: Icon(Icons.edit_note), text: 'Check In'),
            Tab(icon: Icon(Icons.logout), text: 'Check Out'),
          ]),
        ),
        body: TabBarView(children: _widgets),
      ),
    );
  }
}
