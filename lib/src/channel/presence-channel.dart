///
/// This interface represents a presence channel.
///
abstract class PresenceChannel {
  /// Register a callback to be called anytime the member list changes.
  PresenceChannel here(Function callback);

  /// Listen for someone joining the channel.
  PresenceChannel joining(Function callback);

  /// Listen for someone leaving the channel.
  PresenceChannel leaving(Function callback);
}