import 'package:flutter/material.dart';
import 'dart:async';

class SchedulePage extends StatefulWidget {
  const SchedulePage({Key? key}) : super(key: key);

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  late Timer _timer;
  late DateTime _departureTime;
  String _timeUntilDeparture = '';

  @override
  void initState() {
    super.initState();
    _departureTime = _getNextDepartureTime();
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
        _timeUntilDeparture =
            _formatDuration(_departureTime.difference(DateTime.now()));
      });
    });
  }

  DateTime _getNextDepartureTime() {
    // Implement your logic to determine the next departure time based on the current day and scheduled departure time
    // For demonstration purposes, let's set a fixed departure time at 7:00 AM
    DateTime now = DateTime.now();
    DateTime departureTime = DateTime(now.year, now.month, now.day, 7, 0, 0);
    if (now.isAfter(departureTime)) {
      departureTime = departureTime.add(const Duration(days: 1)); // Next day
    }
    return departureTime;
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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 5,
          title: const Text('Bus Schedule'),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              // Navigate back to the MapPage
              Navigator.pop(context);
            },
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Next Departure: Jahangirnagar University',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                _timeUntilDeparture,
                style: TextStyle(
                  fontSize: 24,
                  color:
                      _departureTime.difference(DateTime.now()).inMinutes <= 15
                          ? Colors.red
                          : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
