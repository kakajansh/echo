import 'package:flutter/material.dart';

class LeaveChannelModal extends StatefulWidget {
  final ValueChanged<String?> onLeave;
  final List<String> listeningChannels;

  LeaveChannelModal({
    Key? key,
    required this.onLeave,
    required this.listeningChannels,
  }) : super(key: key);

  _LeaveChannelModalState createState() => _LeaveChannelModalState();
}

class _LeaveChannelModalState extends State<LeaveChannelModal> {
  late String name;
  late TextEditingController nameController;

  @override
  void initState() {
    super.initState();
    nameController = new TextEditingController();
    if (widget.listeningChannels.isNotEmpty) {
      name = widget.listeningChannels.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.listeningChannels.isEmpty) {
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'No listening channels',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        ),
      );
    }

    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          DropdownButton<String>(
            value: name,
            isExpanded: true,
            hint: Text('Please choose channel name'),
            items: widget.listeningChannels.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? value) {
              setState(() => name = value!);
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              fixedSize: Size.fromHeight(44),
            ),
            child: Text(
              'Leave',
              style: TextStyle(fontSize: 16),
            ),
            onPressed: () => widget.onLeave(name),
          ),
        ],
      ),
    );
  }
}
