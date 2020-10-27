import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:example/pusher.dart';
import 'package:example/socketio.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Flutter Demo',
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _current = 'socketio';

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: Colors.white,
        middle: CupertinoSegmentedControl(
          children: {
            'socketio': Text(
              '  socket.io  ',
              style: TextStyle(fontSize: 14),
            ),
            'pusher': Text(
              'pusher',
              style: TextStyle(fontSize: 14),
            ),
          },
          onValueChanged: (value) {
            setState(() {
              _current = value;
            });
          },
          groupValue: _current,
        ),
      ),
      child: _current == 'socketio' ? SocketioPage() : PusherPage(),
    );
  }
}
