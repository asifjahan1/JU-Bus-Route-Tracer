import 'package:flutter/material.dart';

class SchedulePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Buses Schedule'),
        ),
        body: Center(
          child: Text('This is the Schedule Page'),
        ),
      ),
    );
  }
}
