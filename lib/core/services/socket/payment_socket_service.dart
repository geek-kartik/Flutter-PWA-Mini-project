import 'package:universal_html/html.dart';

class PaymentSocketService {
  WebSocket? _socket;

  void connect({
    required Function(String status) onStatus,
  }) {
    _socket = WebSocket('wss://echo.websocket.events');

    _socket!.onOpen.listen((event) {
      print("WebSocket Connected");
    });

    _socket!.onMessage.listen((event) {
      onStatus(event.data);
    });

    _socket!.onError.listen((event) {
      print("WebSocket Error");
    });
  }

  void sendSuccessStatus() {
    _socket?.send("PAYMENT_SUCCESS");
  }

  void sendFailStatus() {
    _socket?.send("PAYMENT_FAIL");
  }

  void dispose() {
    _socket?.close();
  }
}
