import 'package:laravel_echo/src/channel/channel.dart';
import 'package:laravel_echo/src/channel/presence-channel.dart';

abstract class Connector {
  /// Default connector options.
  Map<String, dynamic> _defaultOptions = {
    'auth': {
      'headers': {},
    },
    'authEndpoint': '/api/broadcasting/auth',
    'host': 'http://localhost:6001',
    'key': null,
    'namespace': 'App.Events',
    'autoConnect': false
  };

  /// Connector options.
  late Map<String, dynamic> options;

  /// Create a new class instance.
  Connector(Map<String, dynamic> options) {
    this.options = _defaultOptions..addAll(options);
    this.connect();
  }

  /// Create a fresh connection.
  void connect();

  /// Get a channel instance by name.
  Channel channel(String channel);

  /// Get a private channel instance by name.
  Channel privateChannel(String channel);

  /// Get a presence channel instance by name.
  PresenceChannel presenceChannel(String channel);

  /// Leave the given channel, as well as its private and presence variants.
  void leave(String channel);

  /// Leave the given channel.
  void leaveChannel(String channel);

  /// Get the socket_id of the connection.
  String? socketId();

  /// Disconnect from the Echo server.
  void disconnect();
}
