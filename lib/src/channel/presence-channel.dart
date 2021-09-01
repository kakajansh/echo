import 'package:laravel_echo/src/channel/channel.dart';

///
/// This interface represents a presence channel.
///
abstract class PresenceChannel extends Channel {
  /// Register a callback to be called anytime the member list changes.
  PresenceChannel here(Function callback);

  /// Listen for someone joining the channel.
  PresenceChannel joining(Function callback);

  /// Listen for someone leaving the channel.
  PresenceChannel leaving(Function callback);
}
