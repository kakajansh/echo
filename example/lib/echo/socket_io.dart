import 'package:laravel_echo/laravel_echo.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

const String BEARER_TOKEN = 'YOUR_BEARER_TOKEN_HERE';

Echo initSocketIOClient() {
  IO.Socket socket = IO.io(
    'http://localhost:6002',
    IO.OptionBuilder()
        .disableAutoConnect()
        .setTransports(['websocket']).build(),
  );

  Echo echo = new Echo(
    broadcaster: EchoBroadcasterType.SocketIO,
    client: socket,
    options: {
      'auth': {
        'headers': {
          'Authorization': 'Bearer $BEARER_TOKEN',
        }
      },
    },
  );
  
  log('Socket ID: ${socket.sockedId()}');
  return echo;
}
