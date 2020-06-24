import 'dart:async';
import 'package:pusher_websocket_flutter/pusher.dart' show Pusher;

import '../util/event-formatter.dart';
import 'channel.dart';

///
/// This class represents a pusher channel.
///
class PusherChannel extends Channel {
  /// The Pusher client instance.
  dynamic pusher;

  /// The name of the channel.
  dynamic name;

  /// Channel options.
  dynamic options;

  /// The event formatter.
  EventFormatter eventFormatter;

  /// The subscription of the channel.
  dynamic subscription;

  /// Create a new class instance.
  PusherChannel(dynamic pusher, String name, dynamic options) {
    this.pusher = pusher;
    this.name = name;
    this.options = options;
    this.eventFormatter = new EventFormatter(this.options['namespace']);

    this.subscribe();
  }

  /// Subscribe to a Pusher channel.
  void subscribe() {
    if (this.pusher.toString() == 'Pusher') {
      this.subscription = Pusher.subscribe(this.name);
    }
  }

  /// Unsubscribe from a channel.
  Future<void> unsubscribe() async {
    if (this.pusher.toString() == 'Pusher') {
      await Pusher.unsubscribe(this.name);
    }
  }

  /// Listen for an event on the channel instance.
  PusherChannel listen(String event, Function callback) {
    this.on(this.eventFormatter.format(event), callback);

    return this;
  }

  /// Stop listening for an event on the channel instance.
  PusherChannel stopListening(String event) {
    this.subscription.unbind(this.eventFormatter.format(event));

    return this;
  }

  /// Bind a channel to an event.
  PusherChannel on(String event, Function callback) {
    if (this.subscription != null) {
      if (this.subscription is Future) {
        this.subscription.then((channel) => channel.bind(event, callback));
      } else {
        this.subscription.bind(event, callback);
      }
    }

    return this;
  }
}
