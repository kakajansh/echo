import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ChannelOptions {
  final String channelName;
  final ChannelType channelType;
  final String event;

  ChannelOptions(this.channelName, this.channelType, this.event);
}

enum ChannelType {
  public,
  private,
  presence,
}

class ListenToChannelModal extends StatefulWidget {
  final ValueChanged<ChannelOptions> onListen;

  ListenToChannelModal({
    Key? key,
    required this.onListen,
  }) : super(key: key);

  _ListenToChannelModalState createState() => _ListenToChannelModalState();
}

class _ListenToChannelModalState extends State<ListenToChannelModal> {
  String channelName = 'public-channel';
  String event = 'PublicEvent';
  ChannelType channelType = ChannelType.public;
  late TextEditingController channelNameController;
  late TextEditingController eventController;

  @override
  void initState() {
    super.initState();
    channelNameController = new TextEditingController(text: channelName);
    eventController = new TextEditingController(text: event);
  }

  void onChannelTypeChange(ChannelType value) {
    switch (value) {
      case ChannelType.private:
        channelName = 'private-channel.1';
        event = 'PrivateEvent';
        break;
      case ChannelType.presence:
        channelName = 'presence-channel.1';
        event = 'PresenceEvent';
        break;
      default:
        channelName = 'public-channel';
        event = 'PublicEvent';
        break;
    }

    setState(() {
      channelNameController.text = channelName;
      eventController.text = event;
      channelType = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          CupertinoSegmentedControl<ChannelType>(
            groupValue: channelType,
            onValueChanged: onChannelTypeChange,
            children: {
              ChannelType.public: Text('public'),
              ChannelType.private: Text('private'),
              ChannelType.presence: Text('presence'),
            },
          ),
          SizedBox(height: 25),
          TextField(
            controller: channelNameController,
            decoration: InputDecoration(
              labelText: 'Channel name',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 12,
              ),
            ),
            onChanged: (String value) {
              setState(() => channelName = value);
            },
          ),
          SizedBox(height: 20),
          TextField(
            controller: eventController,
            decoration: InputDecoration(
              labelText: 'Event name',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 12,
              ),
            ),
            onChanged: (String value) {
              setState(() => event = value);
            },
          ),
          SizedBox(height: 25),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              fixedSize: Size.fromHeight(44),
            ),
            child: Text('Listen'),
            onPressed: () {
              if (channelName.isEmpty || event.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Please fill all fields'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                return;
              }

              widget.onListen(ChannelOptions(
                channelName,
                channelType,
                event,
              ));
            },
          ),
        ],
      ),
    );
  }
}
