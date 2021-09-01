import 'package:laravel_echo/src/channel/channel.dart';

///
/// This interface represents a presence channel.
///
abstract class PrivateChannel extends Channel {
  /// Register a callback to be called anytime the member list changes.
  PrivateChannel whisper(String eventName, dynamic data);
}
