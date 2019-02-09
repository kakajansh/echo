import './null-channel.dart';

///
/// This class represents a null private channel.
///
class NullPrivateChannel extends NullChannel {
  /// Trigger client event on the channel.
  NullPrivateChannel whisper(String eventName, var data) {
    return this;
  }
}
