# echo

Laravel Echo for your Flutter apps.

```dart
IO.Socket socket = IO.io('http://localhost:6001', <String, dynamic>{'transports': ['websocket']});

Echo echo = new Echo({
    'broadcaster': 'socket.io',
    'client': socket,
});

echo.channel('channel-name').listen('EventName', (e) {
    print(e);
});
```