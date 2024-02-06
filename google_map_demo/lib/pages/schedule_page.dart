import 'dart:async';

import 'package:flutter/material.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({Key? key}) : super(key: key);

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  late Timer _timer;
  late DateTime _nextDepartureTime;
  late String _departureType;
  late DateTime _friday7AM;
  late DateTime _friday7PM;

  @override
  void initState() {
    super.initState();
    _friday7AM = _getNextFriday(DateTime(7, 0));
    _friday7PM = _getNextFriday(DateTime(19, 0));
    _updateDepartureTime();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _updateDepartureTime();
      });
    });
  }

  void _updateDepartureTime() {
    DateTime now = DateTime.now();
    if (now.isAfter(_friday7PM)) {
      _nextDepartureTime = _getNextFriday(DateTime(7, 0));
      _departureType = 'Next departure: Friday 7:00 AM';
    } else if (now.isAfter(_friday7AM)) {
      _nextDepartureTime = _friday7PM;
      _departureType = 'Next departure: Friday 7:00 PM';
    } else {
      _nextDepartureTime = _friday7AM;
      _departureType = 'Next departure: Friday 7:00 AM';
    }
  }

  DateTime _getNextFriday(DateTime time) {
    DateTime today = DateTime.now();
    int daysUntilNextFriday = (DateTime.friday - today.weekday) % 7;
    return DateTime(today.year, today.month, today.day + daysUntilNextFriday,
        time.hour, time.minute);
  }

  String _formatDuration(Duration duration) {
    if (duration.inDays >= 1) {
      return '${duration.inDays} days ${duration.inHours.remainder(24)}:${duration.inMinutes.remainder(60)}:${duration.inSeconds.remainder(60)}';
    } else {
      String twoDigits(int n) => n.toString().padLeft(2, '0');
      return '${twoDigits(duration.inHours)}:${twoDigits(duration.inMinutes)}:${twoDigits(duration.inSeconds)}';
    }
  }

  @override
  Widget build(BuildContext context) {
    Duration remainingTime = _nextDepartureTime.difference(DateTime.now());
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 5,
          title: Text('Bus Schedule', textAlign: TextAlign.center),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                _departureType,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                _formatDuration(remainingTime),
                style: TextStyle(
                  fontSize: 24,
                  color:
                      remainingTime.inMinutes <= 15 ? Colors.red : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
