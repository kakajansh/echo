## Laravel Echo for Flutter

Basically, this package is port of official [Laravel Echo javascript library](https://github.com/laravel/echo). It helps subscribe to channels and listen for events broadcasted from your Laravel app.

API is same as official Echo package, so everything in [Official documentation](https://laravel.com/docs/5.7/broadcasting) should work.

Three connectors available:

- [x] [socket.io](#socket.io)
- [x] [Pusher](#pusher)
- [x] Null

<img width="300" alt="Screen Shot 2019-03-17 at 9 37 50 PM" src="https://user-images.githubusercontent.com/7093483/54494522-f15eef80-48fc-11e9-8fc1-e986bc004360.png">

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

### Pusher

To use with **Pusher**, you need to install [flutter_pusher_client](https://pub.dartlang.org/packages/flutter_pusher_client) for you Flutter app.

In your `pubspec.yaml` file:

```yaml
dependencies:
  ...
  flutter_pusher_client: ^0.3.1
  laravel_echo: ^0.2.5
```

import `flutter_pusher_client`

```dart
import 'package:flutter_pusher_client/flutter_pusher.dart';
```

```dart
PusherOptions options = PusherOptions(
  host: '10.0.2.2',
  port: 6001,
  encrypted: false,
);
FlutterPusher pusher = FlutterPusher('app', options, enableLogging: true);

Echo echo = new Echo({
  'broadcaster': 'pusher',
  'client': pusher,
});

echo.channel('public-channel').listen('PublicEvent', (e) {
  print(e);
});

socket.on('connect', (_) => print('connect'));
socket.on('disconnect', (_) => print('disconnect'));
```

## Guide

### Options

| Option       | Description                                | Default               |
| ------------ | ------------------------------------------ | --------------------- |
| auth         |                                            |                       |
| authEndpoint |                                            | /broadcasting/auth    |
| broadcaster  |                                            | socket.io             |
| crsfToken    |                                            |                       |
| host         | Socket host                                | http://localhost:6001 |
| namespace    | Event namespace                            | App.Events            |
| ...          | Any other options, passed as socket params |                       |

### Authorize private channels

To authorize channel requests we use [Laravel Passport](https://laravel.com/docs/5.7/passport)

In our `BroadcastServiceProvider.php` we need to enable

```php
Broadcast::routes(['middleware' => ['auth:api']]);
```

then, when creating `Echo` instance include `Authorization` header with bearer token

```dart
echo = new Echo({
  'broadcaster': 'socket.io',
  'client': socket,
  'auth': {
    'headers': {
        'Authorization': 'Bearer $token'
    }
  }
});
```

### Sample backend

Backend used for example app could be found at [echo-server](https://github.com/kakajansh/echo-server)

Package by [Kakajan SH](http://kakajan.sh)
