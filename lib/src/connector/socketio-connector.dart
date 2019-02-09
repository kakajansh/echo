import 'package:laravel_echo/src/connector/connector.dart';
import 'package:laravel_echo/src/channel/socketio-channel.dart';
import 'package:laravel_echo/src/channel/socketio-private-channel.dart';
import 'package:laravel_echo/src/channel/socketio-presence-channel.dart';

///
/// This class creates a connnector to a Socket.io server.
///
class SocketIoConnector extends Connector {
  /// The Socket.io connection instance.
  dynamic socket;

  /// All of the subscribed channel names.
  dynamic channels = {};

  SocketIoConnector(dynamic options) : super(options);

  /// Create a fresh Socket.io connection.
  void connect() {
    this.socket = this.getSocketIO();

    return this.socket;
  }

  /// Get socket.io module from options.
  dynamic getSocketIO() {
    if (this.options['client'] != null) {
      return this.options['client'];
    }

    throw new Exception('Socket.io client not found. Should be passed via options.client');
  }


  /// Listen for an event on a channel instance.
  SocketIoChannel listen(String name, String event, Function callback) {
    return this.channel(name).listen(event, callback);
  }

  /// Get a channel instance by name.
  SocketIoChannel channel(String name) {
    if (this.channels[name] == null) {
      this.channels[name] = new SocketIoChannel(this.socket, name, this.options);
    }

    return this.channels[name];
  }

  /// Get a private channel instance by name.
  SocketIoPrivateChannel privateChannel(String name) {
    if (this.channels['private-' + name]) {
      this.channels['private-' + name] = new SocketIoPrivateChannel(
        this.channel,
        'private-' + name,
        this.options,
      );
    }

    return this.channels['private-' + name];
  }

  /// Get a presence channel instance by name.
  SocketIoPresenceChannel presenceChannel(String name) {
    if (this.channels['presence-' + name]) {
      this.channels['presence-' + name] = new SocketIoPresenceChannel(
        this.socket,
        'presence-' + name,
        this.options,
      );
    }

    return this.channels['presence-' + name];
  }

  /// Leave the given channel, as well as its private and presence variants.
  void leave(String name) {
    dynamic channels = [name, 'private-' + name, 'presence-' + name];

    channels.forEach((name) {
      this.leaveChannel(name);
    });
  }

  /// Leave the given channel.
  void leaveChannel(String name) {
    if (this.channels[name] != null) {
      this.channels[name].unsubscribe();
      this.channels.remove(name);
    }
  }

  /// Get the socket ID for the connection.
  String socketId() {
    return this.socket.id;
  }

  /// Disconnect Socketio connection.
  void disconnect() {
    this.socket.disconnect();
  }
}