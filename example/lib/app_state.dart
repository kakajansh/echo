import 'package:flutter/material.dart';

class AppState extends InheritedWidget {
  final List<LogString> logs;
  final ValueChanged<String> log;

  AppState({
    Key? key,
    required this.logs,
    required this.log,
    required Widget child,
  }) : super(key: key, child: child);

  static AppState of(BuildContext context) {
    final AppState? result =
        context.dependOnInheritedWidgetOfExactType<AppState>();
    assert(result != null, 'No AppState found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(AppState old) {
    return true;
  }
}

class LogString {
  final String date;
  final String text;

  LogString({
    required this.date,
    required this.text,
  });
}
