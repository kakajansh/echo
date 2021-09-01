import 'package:laravel_echo/src/channel/pusher-channel.dart';
import 'package:laravel_echo/src/channel/presence-channel.dart';

///
/// This class represents a Pusher presence channel.
///
class PusherPresenceChannel extends PusherChannel implements PresenceChannel {
  PusherPresenceChannel(
    dynamic pusher,
    String name,
    dynamic options,
  ) : super(pusher, name, options);

  /// Register a callback to be called anytime the member list changes.
  @override
  PusherPresenceChannel here(Function callback) {
    this.on('pusher:subscription_succeeded', (data) => callback(data));

    return this;
  }

  /// Listen for someone joining the channel.
  @override
  PusherPresenceChannel joining(Function callback) {
    this.on('pusher:member_added', (data) => callback(data));

    return this;
  }

  /// Listen for someone leaving the channel.
  @override
  PusherPresenceChannel leaving(Function callback) {
    this.on('pusher:member_removed', (data) => callback(data));

    return this;
  }

  /// Trigger client event on the channel.
  PusherPresenceChannel whisper(String eventName, dynamic data) {
    this.pusher.channels[this.name].trigger('client-$eventName', data);

    return this;
  }
}
