import 'package:laravel_echo/src/channel/pusher-channel.dart';

///
/// This class represents a Pusher presence channel.
///
class PusherPrivateChannel extends PusherChannel {
  PusherPrivateChannel(pusher, String name, options)
      : super(pusher, name, options);

  /// Trigger client event on the channel.
  PusherChannel whisper(String eventName, dynamic data) {
    this.pusher.channels.channels('client event', {
      'channel': this.name,
      'event': 'client-$eventName',
      'data': data,
    });

    return this;
  }
}
