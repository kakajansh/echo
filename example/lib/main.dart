import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:laravel_echo/laravel_echo.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

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

class SocketioPage extends StatefulWidget {
  _SocketioPage createState() => _SocketioPage();
}

class _SocketioPage extends State<SocketioPage> {
  List<String> _logs = new List();
  Echo echo;
  bool is_connected = false;
  String channel_type = 'public';
  String channel_name = '';
  String event;

  @override
  void initState() {
    super.initState();

    echo = new Echo({
      'broadcaster': 'socket.io',
      'client': IO.io,
      'auth': {
        'headers': {
          'Authorization':
              'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjFkNTcxYzcyMTcwZmFmNDRmM2JkYjdkZTE2NmVmNTMzZTMwYjYwNjI2MjA5NjJlNWFhMmNkNTkyOTgwMzNlZmVlMjMyNzI2YTczMTY2NGZiIn0.eyJhdWQiOiIxIiwianRpIjoiMWQ1NzFjNzIxNzBmYWY0NGYzYmRiN2RlMTY2ZWY1MzNlMzBiNjA2MjYyMDk2MmU1YWEyY2Q1OTI5ODAzM2VmZWUyMzI3MjZhNzMxNjY0ZmIiLCJpYXQiOjE1NTAyNTE4MzIsIm5iZiI6MTU1MDI1MTgzMiwiZXhwIjoxNTgxNzg3ODMyLCJzdWIiOiIxIiwic2NvcGVzIjpbXX0.Yhmzofhp8q32gcFmzQDAmm48cwmxqrZAi4Mfsbzp6pyzjzWziEM8isDrNqyQZANXUJP40LGJroK9LkVddHyqWtPQqTNXPv-Azx3tVy_YOkI-BhJhttKaiN7DTPD9gYiuUpINUjrqTVuzxzDHzXNmTemOVqVBABo4f6m9ZoWkdyNKyirPZHagofs4Lp1YR0--AgItZVCPl3DYrLdMY78a687edQaYA1q3HKWPggtxayN35BPoeOm08uxmE_YzYXRTzi6OxGLNcQnrC61NvWqTCZ5Ze4fvUuVRtASqybV1Y4oxcgs2kZYg1rxm5idHUrGwQE4fLmaGgDclBR7Ax-NbiN-VN1gJpB2D7eVYxigCVsCVBnoA5DtjKewg0axckthTXyxcTWJBnbarbbnPuI9ZWrxaZWcp4kWwosw9_pr7Ee_5Q-Uxr_ksZg6qZ3gVrqR9ZY0zZoQl4qEsbUGfLXLGrKj_NjeESOcUsPY6fACIy_Okttxto_a3y9wQwPMDJY-jxdLdZ1TdusZUJG8d5KJxfOUprqsCzju-TVnLZxpA-f15mI9zIcjtA-2PFYnUuukIxBw-FXzBWssrMLyTXxHl9Sux3WH5mtXDW_wbwoJj6aaLHBw28jgokbdlKx3QRWdTvAsALJM6nmDN4BWu2pIn05i5wpcUnxHIvcdOgoh3hn0'
        }
      }
    });

    echo.socket.on('connect', (_) {
      log('connected');

      setState(() {
        is_connected = true;
      });
    });

    echo.socket.on('disconnect', (_) {
      log('disconnected');

      setState(() {
        is_connected = false;
      });
    });
  }

  log(String event) {
    var now = new DateTime.now();
    String formatted =
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";

    setState(() {
      _logs.insert(0, "$formatted $event");
    });
  }

  void _listenToChannel(String type, String name, String event) {
    dynamic channel;

    if (type == 'public') {
      channel = echo.channel(name);
    } else if (type == 'private') {
      channel = echo.private(name);
    } else if (type == 'presence') {
      channel = echo.join(name).here((users) {
        print(users);
      }).joining((user) {
        print(user);
      }).leaving((user) {
        print(user);
      });
    }

    channel.listen(event, (e) {
      log('channel: $name, event: $event');
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Column(
        children: <Widget>[
          Flexible(
            child: Container(
              padding: EdgeInsets.all(15),
              color: Colors.grey[100],
              child: ListView.builder(
                reverse: true,
                itemCount: _logs.length,
                itemBuilder: (BuildContext context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Text(_logs[index]),
                  );
                },
              ),
            ),
          ),
          Container(
            height: 70,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey[300]),
              ),
            ),
            child: Center(
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  CupertinoButton(
                    onPressed: () {
                      showCupertinoModalPopup<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return ChannelModal(
                            listen: true,
                            type: channel_type,
                            name: channel_name,
                            onTypeChanged: (value) {
                              setState(() {
                                channel_type = value;
                              });
                            },
                            onNameChanged: (value) {
                              setState(() {
                                channel_name = value;
                              });
                            },
                            onEventChanged: (value) {
                              setState(() {
                                event = value;
                              });
                            },
                            onSubmit: () {
                              log('Listening to channel: $channel_name');
                              _listenToChannel(
                                  channel_type, channel_name, event);
                              Navigator.of(context).pop();
                            },
                          );
                        },
                      );
                    },
                    child: Text('listen to channel'),
                  ),
                  CupertinoButton(
                    onPressed: () {
                      showCupertinoModalPopup<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return ChannelModal(
                            listen: false,
                            name: channel_name,
                            onNameChanged: (value) {
                              setState(() {
                                channel_name = value;
                              });
                            },
                            onSubmit: () {
                              log('Leaving channel: $channel_name');
                              echo.leave(channel_name);
                              Navigator.of(context).pop();
                            },
                          );
                        },
                      );
                    },
                    child: Text('leave channel'),
                  ),
                  Visibility(
                    visible: !is_connected,
                    child: CupertinoButton(
                      onPressed: () {
                        log('connecting');
                        echo.connect();
                      },
                      child: Text('connect'),
                    ),
                  ),
                  Visibility(
                    visible: is_connected,
                    child: CupertinoButton(
                      onPressed: () {
                        log('disconnecting');
                        echo.disconnect();
                      },
                      child: Text('disconnect'),
                    ),
                  ),
                  CupertinoButton(
                    onPressed: () {
                      dynamic id = echo.sockedId();
                      log('socket_id: $id');
                    },
                    child: Text('get socket-id'),
                  ),
                  CupertinoButton(
                    onPressed: () {
                      setState(() {
                        _logs = [];
                      });
                    },
                    child: Text('clear log'),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ChannelModal extends StatefulWidget {
  final bool listen;
  final String name;
  final String type;
  final String event;
  final Function onTypeChanged;
  final Function onNameChanged;
  final Function onEventChanged;
  final Function onSubmit;

  ChannelModal({
    Key key,
    this.listen,
    this.name,
    this.type,
    this.event,
    this.onTypeChanged,
    this.onNameChanged,
    this.onEventChanged,
    this.onSubmit,
  }) : super(key: key);

  _ChannelModalState createState() => _ChannelModalState();
}

class _ChannelModalState extends State<ChannelModal> {
  String name;
  String type;
  String event;
  TextEditingController nameController;
  TextEditingController eventController;

  @override
  void initState() {
    super.initState();
    name = widget.name;
    type = widget.type;
    nameController = new TextEditingController(text: name);
    eventController = new TextEditingController(text: event);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: widget.listen ? 240 : 140,
      padding: EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          Visibility(
            visible: widget.listen,
            child: Container(
              width: double.infinity,
              child: CupertinoSegmentedControl(
                groupValue: type,
                onValueChanged: (value) {
                  setState(() {
                    type = value;
                  });
                  widget.onTypeChanged(value);
                },
                children: {
                  'public': Text('public'),
                  'private': Text('private'),
                  'presence': Text('   presence   '),
                },
              ),
            ),
          ),
          SizedBox(height: widget.listen ? 20 : 0),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: CupertinoTextField(
              controller: nameController,
              placeholder: 'Channel name',
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                border: Border.all(
                  color: Colors.blue,
                ),
              ),
              onChanged: widget.onNameChanged,
            ),
          ),
          SizedBox(height: widget.listen ? 20 : 0),
          Visibility(
            visible: widget.listen,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: CupertinoTextField(
                controller: eventController,
                placeholder: 'Event name',
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  border: Border.all(
                    color: Colors.blue,
                  ),
                ),
                onChanged: widget.onEventChanged,
              ),
            ),
          ),
          SizedBox(height: 10),
          CupertinoDialogAction(
            child: Text(widget.listen ? 'Listen' : 'Leave'),
            isDefaultAction: true,
            onPressed: widget.onSubmit,
          ),
        ],
      ),
    );
  }
}

class PusherPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Coming soon'),
    );
  }
}
