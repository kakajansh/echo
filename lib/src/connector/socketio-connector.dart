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
  Map<String, SocketIoChannel> channels = {};

  SocketIoConnector(Map<String, dynamic> options) : super(options);

  /// Create a fresh Socket.io connection.
  @override
  void connect() {
    this.socket = this.options['client'];
    this.socket.connect();

    this.socket.on('reconnect', (_) {
      this.channels.values.forEach((channel) => channel.subscribe());
    });
  }

  /// Listen for an event on a channel instance.
  SocketIoChannel listen(String name, String event, Function callback) {
    return this.channel(name).listen(event, callback);
  }

  /// Get a channel instance by name.
  @override
  SocketIoChannel channel(String name) {
    if (this.channels[name] == null) {
      this.channels[name] =
          new SocketIoChannel(this.socket, name, this.options);
    }

    return this.channels[name] as SocketIoChannel;
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

    return this.channels['private-$name'] as SocketIoPrivateChannel;
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

    return this.channels['presence-$name'] as SocketIoPresenceChannel;
  }

  /// Leave the given channel, as well as its private and presence variants.
  @override
  void leave(String name) {
    List<String> channels = [name, 'private-$name', 'presence-$name'];

    channels.forEach((name) => this.leaveChannel(name));
  }

  /// Leave the given channel.
  @override
  void leaveChannel(String name) {
    if (this.channels[name] != null) {
      this.channels[name]!.unsubscribe();
      this.channels.remove(name);
    }
  }

  /// Get the socket ID for the connection.
  @override
  String? socketId() {
    return this.socket.id;
  }

  /// Disconnect Socketio connection.
  @override
  void disconnect() {
    this.socket.disconnect();
  }
}
