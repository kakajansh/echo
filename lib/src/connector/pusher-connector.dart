import 'package:laravel_echo/src/connector/connector.dart';
import 'package:laravel_echo/src/channel/pusher-channel.dart';
import 'package:laravel_echo/src/channel/pusher-private-channel.dart';
import 'package:laravel_echo/src/channel/pusher-presence-channel.dart';

///
/// This class creates a null connector.
///
class PusherConnector extends Connector {
  /// The Pusher connection instance.
  dynamic pusher;

  /// All of the subscribed channel names.
  dynamic channels = {};

  PusherConnector(dynamic options) : super(options);

  /// Create a fresh Pusher connection.
  @override
  void connect() {
    this.pusher = this.options['client'];

    return this.pusher;
  }

  /// Listen for an event on a channel instance.
  PusherChannel listen(String name, String event, Function callback) {
    return this.channel(name).listen(event, callback);
  }

  /// Get a channel instance by name.
  @override
  PusherChannel channel(String name) {
    if (this.channels[name] == null) {
      this.channels[name] = new PusherChannel(this.pusher, name, this.options);
    }

    return this.channels[name];
  }

  /// Get a private channel instance by name.
  @override
  PusherPrivateChannel privateChannel(String name) {
    if (this.channels['private-$name'] == null) {
      this.channels['private-$name'] = new PusherPrivateChannel(
        this.pusher,
        'private-$name',
        this.options,
      );
    }
    return this.channels['private-$name'];
  }

  /// Get a private encrypted channel instance by name.
  PusherPrivateChannel encryptedPrivateChannel(String name) {
    if (this.channels['private-encrypted-$name'] == null) {
      this.channels['private-encrypted-$name'] = new PusherPrivateChannel(
        this.pusher,
        'private-encrypted-$name',
        this.options,
      );
    }

    return this.channels['private-encrypted-$name'];
  }

  /// Get a presence channel instance by name.
  @override
  PusherPresenceChannel presenceChannel(String name) {
    if (this.channels['presence-$name'] == null) {
      this.channels['presence-$name'] = new PusherPresenceChannel(
        this.pusher,
        'presence-$name',
        this.options,
      );
    }
    return this.channels['presence-$name'];
  }

  /// Leave the given channel, as well as its private and presence variants.
  @override
  void leave(String name) {
    dynamic channels = [name, 'private-$name', 'presence-$name'];

    channels.forEach((name) {
      this.leaveChannel(name);
    });
  }

  /// Leave the given channel.
  @override
  void leaveChannel(String name) {
    if (this.channels[name] != null) {
      this.channels[name].unsubscribe();
      this.channels.remove(name);
    }
  }

  /// Get the socket ID for the connection.
  @override
  String socketId() {
    return this.pusher.getSocketId();
  }

  /// Disconnect Pusher connection.
  @override
  void disconnect() {
    this.pusher.disconnect();
  }
}
