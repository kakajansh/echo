import 'private-channel.dart';
import 'pusher-channel.dart';

///
/// This class represents a Pusher private channel.
///
class PusherPrivateChannel extends PusherChannel implements PrivateChannel {
  PusherPrivateChannel(pusher, String name, options)
      : super(pusher, name, options);

  /// Trigger client event on the channel.
  PusherPrivateChannel whisper(String eventName, dynamic data) {
    // this.subscription.channels[this.name].trigger('client-$eventName', data);

    return this;
  }
}
