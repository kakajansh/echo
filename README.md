## Laravel Echo for Flutter

Basically, this package is port of official [Laravel Echo javascript library](https://github.com/laravel/echo). It helps subscribe to channels and listen for events broadcast from your Laravel app.

Three connectors available:
- [x] [socket.io](#socket.io)
- [x] [Pusher](#pusher)
- [x] Null

## Getting started

### socket.io

To use with `socket.io`, you need to install [socket_io_client](https://pub.dartlang.org/packages/socket_io_client) for your Flutter app.

In your `pubspec.yaml` file:

```yaml
dependencies:
  ...
  socket_io_client: ^0.9.1
  laravel_echo:
```

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

### Pusher (NOT TESTED)

To use with __Pusher__, you need to install [pusher](https://pub.dartlang.org/packages/pusher) for you Flutter app.

In your `pubspec.yaml` file:

```yaml
dependencies:
  ...
  pusher: ^1.0.0
  laravel_echo:
```

```dart
Pusher pusher = new Pusher('PUSHER_APP_ID', 'PUSHER_APP_KEY', 'PUSHER_APP_SECRET');

Echo echo = new Echo({
  'broadcaster': 'pusher',
  'client': pusher,
});

echo.channel('test').listen('TestEvent', (e) {
  print(e);
});

socket.on('connect', (_) => print('connect'));
socket.on('disconnect', (_) => print('disconnect'));
```

Package by [Kakajan SH](http://kakajan.sh)