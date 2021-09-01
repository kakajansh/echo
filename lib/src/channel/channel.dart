///
/// This class represents a basic channel.
///
abstract class Channel {
  /// The Echo options.
  late Map<String, dynamic> options;

  /// Listen for an event on the channel instance.
  Channel listen(String event, Function callback);

  /// Unsubscribe channel
  void unsubscribe();

  /// Listen for a whisper event on the channel instance.
  Channel listenForWhisper(String event, Function callback) {
    return this.listen('.client-$event', callback);
  }

  /// Listen for an event on the channel instance.
  Channel notification(Function callback) {
    return this.listen(
      '.Illuminate\\Notifications\\Events\\BroadcastNotificationCreated',
      callback,
    );
  }

  /// Stop listening to an event on the channel instance.
  Channel stopListening(String event, [Function? callback]);

  /// Stop listening for a whisper event on the channel instance.
  Channel stopListeningForWhisper(String event, [Function? callback]) {
    return stopListening('.client-$event', callback);
  }

  /// Register a callback to be called anytime a subscription succeeds.
  Channel subscribed(Function callback);

  /// Register a callback to be called anytime an error occurs.
  Channel error(Function callback);
}
