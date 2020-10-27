import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

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
  String name = 'public-channel';
  String type;
  String event = 'PublicEvent';
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
