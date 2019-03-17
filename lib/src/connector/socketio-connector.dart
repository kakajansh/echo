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
  @override
  void connect() {
    dynamic io = this.getSocketIO();

    this.socket = io(this.options['host'], this.options);

    this.socket.connect();

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
  @override
  SocketIoChannel channel(String name) {
    if (this.channels[name] == null) {
      this.channels[name] = new SocketIoChannel(this.socket, name, this.options);
    }

    return this.channels[name];
  }

  /// Get a private channel instance by name.
  @override
  SocketIoPrivateChannel privateChannel(String name) {
    if (this.channels['private-$name'] == null) {
      this.channels['private-$name'] = new SocketIoPrivateChannel(
        this.socket,
        'private-$name',
        this.options,
      );
    }

    return this.channels['private-$name'];
  }

  /// Get a presence channel instance by name.
  @override
  SocketIoPresenceChannel presenceChannel(String name) {
    if (this.channels['presence-$name'] == null) {
      this.channels['presence-$name'] = new SocketIoPresenceChannel(
        this.socket,
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
    return this.socket.id;
  }

  /// Disconnect Socketio connection.
  @override
  void disconnect() {
    this.socket.disconnect();
  }
}