import '../util/event-formatter.dart';
import './channel.dart';

///
/// This class represents a Socket.io channel.
///
class SocketIoChannel extends Channel {
  /// The Socket.io client instance.
  dynamic socket;

  /// The name of the channel.
  dynamic name;

  /// Channel options.
  dynamic options;

  /// The event formatter.
  EventFormatter eventFormatter;

  /// The event callbacks applied to the channel.
  dynamic events = {};

  /// Create a new class instance.
  SocketIoChannel(dynamic socket, String name, dynamic options) {
    this.name = name;
    this.socket = socket;
    this.options = options;
    this.eventFormatter = new EventFormatter(this.options['namespace']);

    this.subscribe();
    this.configureReconnector();
  }

  /// Subscribe to a Socket.io channel.
  void subscribe() {
    this.socket.emit('subscribe', {
      'channel': name,
      'auth': this.options['auth'] ?? {}
    });
  }

  /// Unsubscribe from channel and ubind event callbacks.
  void unsubscribe() {
    this.unbind();

    this.socket.emit('unsubscribe', {
      'channel': this.name,
      'auth': this.options['auth'] ?? {}
    });
  }

  /// Listen for an event on the channel instance.
  SocketIoChannel listen(String event, Function callback) {
    this.on(this.eventFormatter.format(event), callback);

    return this;
  }

  /// Stop listening for an event on the channel instance.
  SocketIoChannel stopListening(String event) {
    dynamic name = this.eventFormatter.format(event);
    this.socket.off(name);
    this.events.remove(name);

    return this;
  }

  /// Bind the channel's socket to an event and store the callback.
  void on(String event, Function callback) {
    dynamic listener = (data) {
      if (this.name == data[0]) {
        callback(data[1]);
      }
    };

    this.socket.on(event, listener);
    this.bind(event, listener);
  }

  /// Attach a 'reconnect' listener and bind the event.
  void configureReconnector() {
    dynamic listener = (_) {
      this.subscribe();
    };

    this.socket.on('reconnect', listener);
    this.bind('reconnect', listener);
  }

  /// Bind the channel's socket to an event and store the callback.
  void bind(String event, Function callback) {
    this.events[event] = this.events[event] ?? [];
    this.events[event].add(callback);
  }

  /// Unbind the channel's socket from all stored event callbacks.
  void unbind() {
    this.events.keys.forEach((event) {
      this.events[event].forEach((callback) {
        this.socket.off(event, callback);
      });

      this.events[event] = null;
    });
  }
}
