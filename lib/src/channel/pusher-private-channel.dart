import 'package:laravel_echo/src/channel/pusher-channel.dart';
import 'package:laravel_echo/src/channel/private-channel.dart';

///
/// This class represents a Pusher private channel.
///
class PusherPrivateChannel extends PusherChannel implements PrivateChannel {
  PusherPrivateChannel(pusher, String name, options)
      : super(pusher, name, options);

  /// Trigger client event on the channel.
  PusherPrivateChannel whisper(String eventName, dynamic data) {
    this.pusher.channels.channels[this.name].trigger('client-$eventName', data);

    return this;
  }
}
