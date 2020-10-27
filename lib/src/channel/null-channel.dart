import 'package:laravel_echo/src/channel/channel.dart';

///
/// This class represents a null channel.
///
class NullChannel extends Channel {
  /// Subscribe to a channel.
  subscribe() {
    //
  }

  /// Unsubscribe from a channel.
  void unsubscribe() {
    //
  }

  /// Listen for an event on the channel instance.
  NullChannel listen(String event, Function callback) {
    return this;
  }

  /// Stop listening for an event on the channel instance.
  NullChannel stopListening(String event) {
    return this;
  }

  /// Register a callback to be called anytime a subscription succeeds.
  NullChannel subscribed(Function callback) {
    return this;
  }

  /// Register a callback to be called anytime an error occurs.
  NullChannel error(Function callback) {
    return this;
  }

  /// Bind a channel to an event.
  NullChannel on(String event, Function callback) {
    return this;
  }
}
