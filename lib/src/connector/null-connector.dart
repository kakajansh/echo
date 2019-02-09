import 'package:laravel_echo/src/connector/connector.dart';
import 'package:laravel_echo/src/channel/null-channel.dart';
import 'package:laravel_echo/src/channel/null-private-channel.dart';
import 'package:laravel_echo/src/channel/null-presence-channel.dart';

///
/// This class creates a null connector.
///
class NullConnector extends Connector {
  /// All of the subscribed channel names.
  dynamic channels = {};

  NullConnector(dynamic options) : super(options);

  /// Create a fresh connection.
  void connect() {
    //
  }

  /// Listen for an event on a channel instance.
  NullChannel listen(String name) {
    return new NullChannel();
  }

  /// Get a channel instance by name.
  NullChannel channel(String name) {
    return new NullChannel();
  }

  /// Get a private channel instance by name.
  NullPrivateChannel privateChannel(String name) {
    return new NullPrivateChannel();
  }

  /// Get a presence channel instance by name.
  NullPresenceChannel presenceChannel(String name) {
    return new NullPresenceChannel();
  }

  /// Leave the given channel, as well as its private and presence variants.
  void leave(String name) {
    //
  }

  /// Leave the given channel.
  void leaveChannel(String name) {
    //
  }

  /// Get the socket ID for the connection.
  String socketId() {
    return 'fake-socket-id';
  }

  /// Disconnect the connection.
  void disconnect() {
    //
  }
}