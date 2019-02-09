import 'package:laravel_echo/src/channel/socketio-channel.dart';

///
/// This class represents a Socket.io presence channel.
///
class SocketIoPrivateChannel extends SocketIoChannel {
  SocketIoPrivateChannel(dynamic socket, String name, dynamic options) : super(socket, name, options);

  /// Trigger client event on the channel.
  SocketIoChannel whisper(String eventName, dynamic data) {
    this.socket.emit('client event', {
      'channel': this.name,
      'event': 'client-$eventName',
      'data': data,
    });

    return this;
  }
}
