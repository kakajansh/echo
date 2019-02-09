## Laravel Echo for Flutter

Basically, this package is port of official [Laravel Echo javascript library](https://github.com/laravel/echo). It helps subscribe to channels and listen for events broadcast from your Laravel app.

Three connectors available:
- [ ] Pusher
- [x] Socket.io
- [x] Null

## Getting started

For now, only `socket.io` connector implemented. You need to install [socket_io_client](https://pub.dartlang.org/packages/socket_io_client) for your Flutter app.

In your `pubspec.yaml` file:

```yaml
dependencies:
  ...
  socket_io_client: ^0.9.1
  laravel_echo:
```

#### Usage:

```dart
IO.Socket socket = IO.io('http://localhost:6001', <String, dynamic>{'transports': ['websocket']});

Echo echo = new Echo({
  'broadcaster': 'socket.io',
  'client': socket,
});

echo.channel('test').listen('TestEvent', (e) {
  print(e);
});

socket.on('connect', (_) => print('connect'));
socket.on('disconnect', (_) => print('disconnect'));
```

Package by [Kakajan SH](http://kakajan.sh)