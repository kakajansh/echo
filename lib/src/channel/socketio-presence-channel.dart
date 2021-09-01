import 'package:laravel_echo/src/channel/presence-channel.dart';
import 'package:laravel_echo/src/channel/socketio-private-channel.dart';

///
/// This class represents a Socket.io presence channel.
///
class SocketIoPresenceChannel extends SocketIoPrivateChannel
    implements PresenceChannel {
  SocketIoPresenceChannel(
    dynamic socket,
    String name,
    dynamic options,
  ) : super(socket, name, options);

  /// Register a callback to be called anytime the member list changes.
  SocketIoPresenceChannel here(Function callback) {
    this.on('presence:subscribed', (List<dynamic> members) {
      callback(members.map((member) => member['user_info']));
    });

    return this;
  }

  /// Listen for someone joining the channel.
  SocketIoPresenceChannel joining(Function callback) {
    this.on('presence:joining', (member) => callback(member['user_info']));

    return this;
  }

  /// Listen for someone leaving the channel.
  SocketIoPresenceChannel leaving(Function callback) {
    this.on('presence:leaving', (member) => callback(member['user_info']));

    return this;
  }
}
