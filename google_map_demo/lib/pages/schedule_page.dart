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
      _departureType = 'Bus departure: Friday 7:00 AM';
    } else if (now.isAfter(_friday7AM)) {
      _nextDepartureTime = _friday7PM;
      _departureType = 'Next departure: Friday 7:00 PM';
    } else {
      _nextDepartureTime = _friday7AM;
      _departureType = 'Bus departure: Friday 7:00 AM';
    }
  }

  DateTime _getNextFriday(DateTime time) {
    DateTime today = DateTime.now();
    int daysUntilNextFriday = (DateTime.friday - today.weekday) % 7;
    return DateTime(today.year, today.month, today.day + daysUntilNextFriday,
        time.hour, time.minute);
  }

  // String _formatDuration(Duration duration) {
  //   if (duration.inDays >= 1) {
  //     return '${duration.inDays} days ${duration.inHours.remainder(24)}:${duration.inMinutes.remainder(60)}:${duration.inSeconds.remainder(60)}';
  //   } else {
  //     String twoDigits(int n) => n.toString().padLeft(2, '0');
  //     return '${twoDigits(duration.inHours)}:${twoDigits(duration.inMinutes)}:${twoDigits(duration.inSeconds)}';
  //   }
  // }

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
      child: WillPopScope(
        onWillPop: () async {
          // Navigate back to the map page
          Navigator.pop(context);
          return false; // Prevent default back navigation
        },
        child: Container(
          color: Colors.white,
          child: Scaffold(
            appBar: AppBar(
              //backgroundColor: Colors.blue,
              //elevation: 0,
              title: const Text(
                'Bus Schedule',
                style: TextStyle(
                  //fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.3,
                ),
              ),
              centerTitle: true,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
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
                  Text(
                    _departureType,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // const Text(
                  //   'until',
                  //   style: TextStyle(
                  //     color: Colors.deepPurple,
                  //     fontSize: 25,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: Text(
                        _formatDuration(remainingTime),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height * 0.1,
                          fontWeight: FontWeight.bold,
                          color: remainingTime.inMinutes <= 15
                              ? Colors.red
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),

                  // RichText(
                  //   text: TextSpan(
                  //     children: _getFormattedTextSpans(formattedDuration),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // List<TextSpan> _getFormattedTextSpans(String formattedDuration) {
  //   List<TextSpan> textSpans = [];
  //   List<String> components = formattedDuration.split(' ');

  //   for (String component in components) {
  //     bool isNumeric = int.tryParse(component) != null;
  //     Color color = isNumeric ? Colors.black : Colors.red;
  //     textSpans.add(TextSpan(
  //       text: component,
  //       style: TextStyle(color: color),
  //     ));
  //     textSpans.add(TextSpan(text: ' '));
  //   }

  //   return textSpans;
  // }
}
