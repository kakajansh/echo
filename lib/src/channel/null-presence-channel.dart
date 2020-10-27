import 'package:laravel_echo/src/channel/null-channel.dart';
import 'package:laravel_echo/src/channel/presence-channel.dart';

///
/// This class represents a null presence channel.
///
class NullPresenceChannel extends NullChannel implements PresenceChannel {
  /// Register a callback to be called anytime the member list changes.
  NullPresenceChannel here(Function callback) {
    return this;
  }

  /// Listen for someone joining the channel.
  NullPresenceChannel joining(Function callback) {
    return this;
  }

  /// Listen for someone leaving the channel.
  NullPresenceChannel leaving(Function callback) {
    return this;
  }

  /// Trigger client event on the channel.
  NullPresenceChannel whisper(String eventName, dynamic data) {
    return this;
  }
}
