import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class CheckListScreen extends StatefulWidget {
  const CheckListScreen({super.key});

  @override
  State<StatefulWidget> createState() => CheckListState();
}

class CheckListState extends State<CheckListScreen> {
  Database? _database;
  List<Map<String, Object?>> _checkInTimes = [];

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'check_in.db'),
      onCreate: (db, version) {
        return db.execute(
            'create table check_in(id INTEGER PRIMARY KEY, state INTEGER, time TEXT)');
      },
      version: 1,
    );
    _loadCheckInTime();
  }

  Future<void> _loadCheckInTime() async {
    var maps = await _database?.query('check_in');
    setState(() {
      _checkInTimes = maps ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: _checkInTimes.length,
      itemBuilder: (BuildContext context, int index) {
        return _checkInOutText(index, _checkInTimes[index]);
      },
    );
  }

  Text _checkInOutText(int index, Map<String, Object?> map) {
    String text = map['state'].toString() == '1' ? 'Check In' : 'Check Out';
    return Text('$text: ${map['time']}', style: const TextStyle(fontSize: 16));
  }
}
