///
/// This class represents a basic channel.
///
abstract class Channel {
  /// The Echo options.
  dynamic options;

  // void subscribe();
  // void unsubscribe();

  /// Listen for an event on the channel instance.
  Channel listen(String event, Function callback);

  /// Listen for a whisper event on the channel instance.
  Channel listerForWhisper(String event, Function callback) {
    return this.listen('.client-$event', callback);
  }

  /// Listen for an event on the channel instance.
  Channel notification(Function callback) {
    return this.listen(
        '.Illuminate\\Notifications\\Events\\BroadcastNotificationCreated',
        callback);
  }

  /// Stop listening to an event on the channel instance.
  Channel stopListening(String event);

  /// Stop listening for a whispser event on the channel instance.
  Channel stopListeningForWhisper(String event) {
    return this.stopListening('.client-$event');
  }
}
