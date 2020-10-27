import 'package:laravel_echo/src/channel/null-channel.dart';
import 'package:laravel_echo/src/channel/private-channel.dart';

///
/// This class represents a null private channel.
///
class NullPrivateChannel extends NullChannel implements PrivateChannel {
  /// Trigger client event on the channel.
  NullPrivateChannel whisper(String eventName, dynamic data) {
    return this;
  }
}
