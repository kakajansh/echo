import 'package:laravel_echo/src/channel/channel.dart';
import 'package:laravel_echo/src/channel/presence-channel.dart';

abstract class Connector {
  /// Default connector options.
  var _defaultOptions = {
    'auth': {
      'headers': {},
    },
    'authEndpoint': '/broadcasting/auth',
    'broadcaster': 'socket.io',
    'crsfToken': null,
    'host': 'http://localhost:6001',
    'key': null,
    'namespace': 'App.Events',
    'transports': ['websocket'],
    'autoConnect': false
  };

  /// Connector options.
  dynamic options;

  /// Create a new class instance.
  Connector(dynamic options) {
    // this.options = options;
    this._setOptions(options);
    this.connect();
  }

  /// Merge the custom options with the defaults.
  void _setOptions(dynamic options) {
    _defaultOptions.addAll(options);
    this.options = this._defaultOptions;

    if (this._csrfToken() != null) {
      this.options['auth'].headers['X-CSRF-TOKEN'] = this._csrfToken();
    }
  }

  /// Extract the CSRF token from the page.
  String? _csrfToken() {
    if (this.options['csrfToken'] != null) {
      return this.options['csrfToken'];
    }

    return null;
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
  String socketId();

  /// Disconnect from the Echo server.
  void disconnect();
}
