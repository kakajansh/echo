import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:pusher_websocket_flutter/pusher.dart';
import 'package:laravel_echo/laravel_echo.dart';

import 'channel_modal.dart';

class PusherPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PusherPage();
}

class _PusherPage extends State<PusherPage> {
  List<String> _logs = new List();
  Echo echo;
  bool isConnected = false;
  String channelType = 'public';
  String channelName = '';
  String event;

  void onConnectionStateChange(ConnectionStateChange event) async {
    print('connection callback via ${event.currentState}');
    if (event.currentState == 'connected' ||
        event.currentState == 'CONNECTED') {
      log('connected');
      setState(() {
        isConnected = true;
      });
    } else if (event.currentState == 'disconnected' ||
        event.currentState == 'DISCONNECTED') {
      log('disconnected');
      setState(() {
        isConnected = false;
      });
    }
  }

  Future<void> _initPusher() async {
    try {
      await Pusher.init(
          '106bcccd1be248c56008',
          PusherOptions(
            auth: PusherAuth(
                'https://wanderinghog.amusetravel.com/api/broadcasting/auth',
                headers: {
                  'Content-Type': 'application/json',
                  'Accept': 'application/json',
                  'Authorization':
                      'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOlwvXC93YW5kZXJpbmdob2cuYW11c2V0cmF2ZWwuY29tXC9hcGlcL2xvZ2luIiwiaWF0IjoxNTkyOTcyNTU3LCJleHAiOjE1OTQxODIxNTcsIm5iZiI6MTU5Mjk3MjU1NywianRpIjoiejFRTEpqNDgyQkJLbjVDRyIsInN1YiI6MTEsInBydiI6IjIzYmQ1Yzg5NDlmNjAwYWRiMzllNzAxYzQwMDg3MmRiN2E1OTc2ZjciLCJ1dWlkIjoiMTA5MTU2YmUtYzRmYi00MWVhLWIxYjQtZWZlMTY3MWM1ODM2In0.5MkYV6SoVdf_lkdwAmD8P0g5AFyntwVmJAZF5kVHsCs'
                }),
            cluster: 'ap3',
          ),
          enableLogging: true);
    } on PlatformException catch (e) {
      print(e.message);
    }
    echo = new Echo({
      'broadcaster': 'pusher',
      'client': Pusher,
      'callback': this.onConnectionStateChange,
    });
  }

  @override
  void initState() {
    super.initState();
    _initPusher();
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

    print('>>> listening to $type $name $event');
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
                            type: channelType,
                            name: channelName,
                            onTypeChanged: (value) {
                              setState(() {
                                channelType = value;
                              });
                            },
                            onNameChanged: (value) {
                              setState(() {
                                channelName = value;
                              });
                            },
                            onEventChanged: (value) {
                              setState(() {
                                event = value;
                              });
                            },
                            onSubmit: () {
                              log('Listening to channel: $channelName');
                              _listenToChannel(channelType, channelName, event);
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
                            name: channelName,
                            onNameChanged: (value) {
                              setState(() {
                                channelName = value;
                              });
                            },
                            onSubmit: () {
                              log('Leaving channel: $channelName');
                              echo.leave(channelName);
                              Navigator.of(context).pop();
                            },
                          );
                        },
                      );
                    },
                    child: Text('leave channel'),
                  ),
                  Visibility(
                    visible: !isConnected,
                    child: CupertinoButton(
                      onPressed: () {
                        log('connecting');
                        echo.connect();
                        setState(() {
                          isConnected = true;
                        });
                      },
                      child: Text('connect'),
                    ),
                  ),
                  Visibility(
                    visible: isConnected,
                    child: CupertinoButton(
                      onPressed: () {
                        log('disconnecting');
                        echo.disconnect();
                        setState(() {
                          isConnected = false;
                        });
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
