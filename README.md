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

To use with __Pusher__, you need to install [pusher_websocket_flutter](https://pub.dev/packages/pusher_websocket_flutter) for you Flutter app.

In your `pubspec.yaml` file:

```yaml
dependencies:
  ...
  pusher_websocket_flutter: ^0.2.0
  laravel_echo:
```

import `pusher_websocket_flutter`
```dart
import 'package:pusher_websocket_flutter/pusher.dart';
```

usage
> Somewhere along the line, you are going to need the Pusher initialization like the one in the below. One thing you have to remember is that `PusherAuth` requires an `HTTPS` endpoint not `HTTP`.

```dart
Future<void> _initPusher() async {
  try {
    await Pusher.init(
        'your-pusher-app-key-goes-here',
        PusherOptions(
          auth: PusherAuth(
              'https://your-api-endpoint.com/api/broadcasting/auth',
              headers: {
                'Content-Type': 'application/json',
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
echo.channel('my-channel').listen('MyEvent', (e) {
  print(e);
});
echo.channel('my-channel').on('connect', (_) => print('connect'));
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

Package by [Kakajan SH](http://kakajan.sh)
