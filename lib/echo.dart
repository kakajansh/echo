library echo;

import './channel/channel.dart';
import './channel/presence-channel.dart';
import './connector/socketio-connector.dart';
import './connector/null-connector.dart';

///
/// This class is the primary API for interacting with broadcasting.
///
class Echo {
  /// The broadcasting connector.
  dynamic connector;

  /// The Echo options.
  Map<String, dynamic> options;

  /// Create a new class instance.
  Echo(dynamic options) {
    this.options = options;
    this.connect();
    // TODO:
    // this.registerInterceptors();
  }

  /// Get a channel instance by name.
  Channel channel(String channel) {
    return this.connector.channel(channel);
  }

  /// Create a new connection.
  void connect() {
    if (this.options['broadcaster'] == 'socket.io') {
      this.connector = new SocketIoConnector(this.options);
    } else if (this.options['broadcaster'] == 'null') {
      this.connector = new NullConnector(this.options);
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

  /// Leave the given channel.
  void leave(String channel) {
    this.connector.leave(channel);
  }

  /// Listen for an event on a channel instance.
  Channel listen(String channel, String event, Function callback) {
    return this.connector.listen(channel, event, callback);
  }

  /// Get a private channel instance by name.
  Channel private(String channel) {
    return this.connector.privateChannel(channel);
  }

  /// Get the Socket ID for the connection.
  String sockedId() {
    return this.connector.socketId();
  }

  // TODO:
}
