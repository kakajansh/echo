library laravel_echo;

import 'package:laravel_echo/src/channel/channel.dart';
import 'package:laravel_echo/src/channel/presence-channel.dart';
import 'package:laravel_echo/src/connector/socketio-connector.dart';
import 'package:laravel_echo/src/connector/pusher-connector.dart';

///
/// This class is the primary API for interacting with broadcasting.
///
class Echo {
  /// The broadcasting connector.
  dynamic connector;

  /// The Echo options.
  late Map<String, dynamic> options;

  // The broadcaster type.
  late EchoBroadcasterType broadcaster;

  /// Create a new class instance.
  Echo({
    EchoBroadcasterType broadcaster = EchoBroadcasterType.Pusher,
    required dynamic client,
    Map<String, dynamic>? options,
  }) {
    this.broadcaster = broadcaster;
    this.options = options ?? {};
    this.options['client'] = client;
    this.connect();
  }

  /// Get a channel instance by name.
  Channel channel(String channel) {
    return this.connector.channel(channel);
  }

  /// Create a new connection.
  void connect() {
    if (this.broadcaster == EchoBroadcasterType.Pusher) {
      this.connector = new PusherConnector(this.options);
    } else if (this.broadcaster == EchoBroadcasterType.SocketIO) {
      this.connector = new SocketIoConnector(this.options);
    }
  }

  /// Disconnect from the Echo server.
  void disconnect() {
    this.connector.disconnect();
  }

  /// Get a presence channel instance by name.
  PresenceChannel join(String channel) {
    return this.connector.presenceChannel(channel);
  }

  /// Leave the given channel, as well as its private and presence variants.
  void leave(String channel) {
    this.connector.leave(channel);
  }

  /// Leave the given channel.
  void leaveChannel(String channel) {
    this.connector.leaveChannel(channel);
  }

  /// Listen for an event on a channel instance.
  Channel listen(String channel, String event, Function callback) {
    return this.connector.listen(channel, event, callback);
  }

  /// Get a private channel instance by name.
  Channel private(String channel) {
    return this.connector.privateChannel(channel);
  }

  /// Get a private encrypted channel instance by name.
  Channel encryptedPrivate(String channel) {
    return this.connector.encryptedPrivateChannel(channel);
  }

  /// Get the Socket ID for the connection.
  String? socketId() {
    return this.connector.socketId();
  }
}

enum EchoBroadcasterType {
  SocketIO,
  Pusher,
}
