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
  bool _isBlinking = false;

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
    if (now.weekday == DateTime.friday) {
      if ((now.hour == 6 && now.minute >= 45) ||
          (now.hour == 7 && now.minute < 0)) {
        // If it's 15 minutes before Friday 7:00 AM
        _nextDepartureTime = _friday7AM;
        _departureType = 'Bus departure: Friday 7:00 AM';
        _isBlinking = true;
      } else if (now.hour >= 7 && now.hour < 19) {
        // If it's between Friday 7:00 AM and Friday 7:00 PM
        _nextDepartureTime = _friday7PM;
        _departureType = 'Next departure: Friday 7:00 PM';
        _isBlinking = false;
      } else {
        // If it's after Friday 7:00 PM
        _nextDepartureTime = _getNextFriday(DateTime(7, 0));
        _departureType = 'Bus departure: Friday 7:00 AM';
        _isBlinking = false;
      }
    } else {
      _nextDepartureTime = _friday7AM;
      _departureType = 'Bus departure: Friday 7:00 AM';
      _isBlinking = false;
    }
  }

  DateTime _getNextFriday(DateTime time) {
    DateTime today = DateTime.now();
    int daysUntilNextFriday = (DateTime.friday - today.weekday) % 7;
    return DateTime(today.year, today.month, today.day + daysUntilNextFriday,
        time.hour, time.minute);
  }

  String _formatDuration(Duration duration) {
    int days = duration.inDays;
    int hours = duration.inHours.remainder(24);
    int minutes = duration.inMinutes.remainder(60);
    int seconds = duration.inSeconds.remainder(60);

    String formattedDuration = '';

    if (days > 0) {
      formattedDuration += '$days day ';
    }
    if (hours > 0 || days > 0) {
      formattedDuration += '$hours hours ';
    }
    if (minutes > 0 || hours > 0 || days > 0) {
      formattedDuration += '$minutes mins ';
    }
    formattedDuration += '$seconds sec';

    return formattedDuration.trim();
  }

  @override
  Widget build(BuildContext context) {
    Duration remainingTime = _nextDepartureTime.difference(DateTime.now());
    String formattedDuration = _formatDuration(remainingTime);
    return Container(
      color: Colors.white,
      child: PopScope(
        canPop: false,
        // () async {
        //   // Navigate back to the map page
        //   Navigator.pop(context);
        //   return false; // Prevent default back navigation
        // },
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Bus Schedule',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 1.3,
              ),
            ),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                // Navigate back to the map page
                Navigator.pop(context);
              },
            ),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 500),
                  style: TextStyle(
                    color: _isBlinking ? Colors.black : Colors.red,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                  child: Text(_departureType),
                ),
                const SizedBox(height: 20),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: Text(
                      _formatDuration(remainingTime),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.1,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
