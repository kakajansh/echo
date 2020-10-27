### socket.io

To use with `socket.io`, you need to install [socket_io_client](https://pub.dartlang.org/packages/socket_io_client) for your Flutter app.

In your `pubspec.yaml` file:

```yaml
dependencies:
  ...
  socket_io_client: ^0.9.1
  laravel_echo:
```

import `socket_io_client`

```dart
import 'package:socket_io_client/socket_io_client.dart' as IO;
```

usage

```dart
// Create echo instance
Echo echo = new Echo({
  'broadcaster': 'socket.io',
  'client': IO.io,
});

// Listening public channel
echo.channel('public-channel').listen('PublicEvent', (e) {
  print(e);
});

// Listening private channel
// Needs auth. See details how to authorize channel below in guides
echo.private('private-channel').listen('PrivateEvent', (e) {
  print(e);
});

// Listening presence channel
// Needs auth. See details how to authorize channel below in guides
echo.join('presence-channel')
  .here((users) {
    print(users);
  }).joining((user) {
    print(user);
  }).leaving((user) {
    print(user);
  }).listen('PresenceEvent', (e) {
    print(e);
  });

// Accessing socket instance
echo.socket.on('connect', (_) => print('connected'));
echo.socket.on('disconnect', (_) => print('disconnected'));
```
