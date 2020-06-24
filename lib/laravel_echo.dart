library laravel_echo;

import 'src/channel/channel.dart';
import 'src/channel/presence-channel.dart';
import 'src/channel/private-channel.dart';
import 'src/connector/null-connector.dart';
import 'src/connector/pusher-connector.dart';
import 'src/connector/socketio-connector.dart';

///
/// This class is the primary API for interacting with broadcasting.
///
class Echo {
  /// The broadcasting connector.
  dynamic connector;

  /// Socket instance
  get socket => this.connector.socket;

  /// The Echo options.
  Map<String, dynamic> options;

  /// Create a new class instance.
  Echo(dynamic options) {
    this.options = options;
    this.connect();
  }

  /// Get a channel instance by name.
  Channel channel(String channel) {
    return this.connector.channel(channel);
  }

  /// Create a new connection.
  void connect() {
    if (this.options['broadcaster'] == 'pusher') {
      this.connector = new PusherConnector(this.options);
    } else if (this.options['broadcaster'] == 'socket.io') {
      this.connector = new SocketIoConnector(this.options);
    } else if (this.options['broadcaster'] == 'null') {
      this.connector = new NullConnector(this.options);
    } else if (options['broadcaster'] is Function) {
      this.connector = options['broadcaster'](options);
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
  PrivateChannel private(String channel) {
    return this.connector.privateChannel(channel);
  }

  /// Get the Socket ID for the connection.
  String sockedId() {
    return this.connector.socketId();
  }
}
