import 'private-channel.dart';
import 'socketio-channel.dart';

///
/// This class represents a Socket.io presence channel.
///
class SocketIoPrivateChannel extends SocketIoChannel implements PrivateChannel {
  SocketIoPrivateChannel(dynamic socket, String name, dynamic options)
      : super(socket, name, options);

  /// Trigger client event on the channel.
  SocketIoPrivateChannel whisper(String eventName, dynamic data) {
    this.socket.emit('client event', {
      'channel': this.name,
      'event': 'client-$eventName',
      'data': data,
    });

    return this;
  }
}
