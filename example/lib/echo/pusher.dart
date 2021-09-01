import 'package:laravel_echo/laravel_echo.dart';
import 'package:pusher_client/pusher_client.dart';

const String PUSHER_KEY = 'local';
// const String PUSHER_KEY = 'YOUR_PUSHER_KEY_HERE';
const String PUSHER_CLUSTER = 'eu';
const String AUTH_URL = 'http://echo.test/api/broadcasting/auth';
const String BEARER_TOKEN = 'YOUR_BEARER_TOKEN_HERE';

Echo initPusherClient() {
  PusherOptions options;

  if (PUSHER_KEY == 'local') {
    //
    // Sample configuration for laravel-websockets
    //
    options = PusherOptions(
      host: '127.0.0.1',
      wsPort: 6001,
      encrypted: false,
      auth: PusherAuth(
        AUTH_URL,
        headers: {
          'Authorization': 'Bearer $BEARER_TOKEN',
        },
      ),
    );
  } else {
    //
    // Sample configuration for pusher
    //
    options = PusherOptions(
      cluster: PUSHER_CLUSTER,
      encrypted: false,
      auth: PusherAuth(
        AUTH_URL,
        headers: {
          'Authorization': 'Bearer $BEARER_TOKEN',
        },
      ),
    );
  }

  PusherClient pusherClient = PusherClient(
    PUSHER_KEY,
    options,
    autoConnect: false,
    enableLogging: true,
  );

  pusherClient.onConnectionError((error) {
    print(error?.message);
  });

  Echo echo = new Echo(
    broadcaster: EchoBroadcasterType.Pusher,
    client: pusherClient,
  );

  return echo;
}
