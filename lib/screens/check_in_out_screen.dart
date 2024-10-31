import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class CheckInOutScreen extends StatefulWidget {
  const CheckInOutScreen({super.key});

  @override
  State<StatefulWidget> createState() => CheckInOutState();
}

class CheckInOutState extends State<CheckInOutScreen> {
  bool _isCheckIn = true;
  Database? _database;

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
    _initSwitch();
  }

  Future<void> _initSwitch() async {
    var state = (await _database!.query('check_in')).last['state'].toString();
    setState(() {
      _isCheckIn = state == '0';
    });
  }

  @override
  void activate() {
    super.activate();
    _initSwitch();
  }

  Future<void> _saveCheckInTime() async {
    _database?.insert('check_in',
        {'state': _isCheckIn ? 1 : 0, 'time': DateTime.now().toString()});
    _onSwitchChanged(!_isCheckIn);
  }

  void _onSwitchChanged(bool value) {
    setState(() {
      _isCheckIn = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Switch(value: _isCheckIn, onChanged: _onSwitchChanged),
          ElevatedButton(onPressed: _saveCheckInTime, child: _buttonText())
        ],
      ),
    );
  }

  Text _buttonText() {
    return _isCheckIn ? const Text('check in') : const Text('check out');
  }
}
