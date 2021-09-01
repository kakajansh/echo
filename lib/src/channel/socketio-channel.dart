import 'package:laravel_echo/src/util/event-formatter.dart';
import 'package:laravel_echo/src/channel/channel.dart';

///
/// This class represents a Socket.io channel.
///
class SocketIoChannel extends Channel {
  /// The Socket.io client instance.
  dynamic socket;

  /// The name of the channel.
  late String name;

  /// Channel options.
  late Map<String, dynamic> options;

  /// The event formatter.
  late EventFormatter eventFormatter;

  /// The event callbacks applied to the socket.
  Map<String, dynamic> events = {};

  /// User supplied callbacks for events on this channel
  Map<String, List> _listeners = {};

  /// Create a new class instance.
  SocketIoChannel(dynamic socket, String name, Map<String, dynamic> options) {
    this.name = name;
    this.socket = socket;
    this.options = options;
    this.eventFormatter = new EventFormatter(this.options['namespace']);

    this.subscribe();
  }

  /// Subscribe to a Socket.io channel.
  void subscribe() {
    this.socket.emit('subscribe', {
      'channel': this.name,
      'auth': this.options['auth'] ?? {},
    });
  }

  /// Unsubscribe from channel and ubind event callbacks.
  void unsubscribe() {
    this.unbind();

    this.socket.emit('unsubscribe', {
      'channel': this.name,
      'auth': this.options['auth'] ?? {},
    });
  }

  /// Listen for an event on the channel instance.
  SocketIoChannel listen(String event, Function callback) {
    this.on(this.eventFormatter.format(event), callback);

    return this;
  }

  /// Stop listening for an event on the channel instance.
  @override
  SocketIoChannel stopListening(String event, [Function? callback]) {
    this._unbindEvent(this.eventFormatter.format(event), callback);

    return this;
  }

  /// Register a callback to be called anytime a subscription succeeds.
  SocketIoChannel subscribed(Function callback) {
    this.on('connect', (socket) => callback(socket));

    return this;
  }

  /// Register a callback to be called anytime an error occurs.
  SocketIoChannel error(Function callback) {
    return this;
  }

  /// Bind the channel's socket to an event and store the callback.
  SocketIoChannel on(String event, Function callback) {
    this._listeners[event] = this._listeners[event] ?? [];

    if (this.events[event] == null) {
      this.events[event] = (props) {
        String channel = props[0];
        dynamic data = props[1];
        if (this.name == channel && this._listeners[event]!.isNotEmpty) {
          this._listeners[event]!.forEach((cb) => cb(data));
        }
      };

      this.socket.on(event, this.events[event]);
    }

    this._listeners[event]?.add(callback);

    return this;
  }

  /// Unbind the channel's socket from all stored event callbacks.
  void unbind() {
    List.from(events.keys).forEach((event) => this._unbindEvent(event));
  }

  /// Unbind the listeners for the given event.
  void _unbindEvent(String event, [Function? callback]) {
    this._listeners[event] = this._listeners[event] ?? [];

    if (callback != null) {
      this._listeners[event] =
          this._listeners[event]!.where((cb) => cb != callback).toList();
    }

    if (callback == null || this._listeners[event]!.isEmpty) {
      if (this.events[event] != null) {
        this.socket.off(event, this.events[event]);

        this.events.remove(event);
      }

      this._listeners.remove(event);
    }
  }
}
