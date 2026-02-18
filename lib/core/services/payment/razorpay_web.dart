import 'dart:async';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'package:web/web.dart' as web;

class RazorpayWeb {
  Future<Map<String, dynamic>> open(Map<String, dynamic> options) async {
    final completer = Completer<Map<String, dynamic>>();

    void startCheckout() {
      final jsOptions = options.jsify() as JSObject;

      // SUCCESS HANDLER
      void successHandler(JSObject response) {
        if (!completer.isCompleted) {
          completer.complete({
            "status": "success",
            "razorpay_payment_id": response
                .getProperty('razorpay_payment_id'.toJS)
                .dartify(),
            "razorpay_order_id": response
                .getProperty('razorpay_order_id'.toJS)
                .dartify(),
            "razorpay_signature": response
                .getProperty('razorpay_signature'.toJS)
                .dartify(),
          });
        }
      }

      jsOptions.setProperty('handler'.toJS, successHandler.toJS);

      // Proper modal object creation
      final modalObject = {}.jsify() as JSObject;

      modalObject.setProperty(
        'ondismiss'.toJS,
        (() {
          if (!completer.isCompleted) {
            completer.complete({
              "status": "cancelled",
              "message": "Payment cancelled",
            });
          }
        }).toJS,
      );

      jsOptions.setProperty('modal'.toJS, modalObject);

      final razorpay = Razorpay(jsOptions);

      // FAILURE HANDLER
      razorpay.on(
        'payment.failed',
        ((JSObject response) {
          final error = response.getProperty('error'.toJS) as JSObject;

          if (!completer.isCompleted) {
            completer.complete({
              "status": "error",
              "code": error.getProperty('code'.toJS).dartify(),
              "message": error.getProperty('description'.toJS).dartify(),
            });
          }
        }).toJS,
      );

      razorpay.open();
    }

    // Load script safely
    if (web.document.getElementById('rzp-script') == null) {
      final script =
          web.document.createElement('script') as web.HTMLScriptElement;
      script.id = 'rzp-script';
      script.src = 'https://checkout.razorpay.com/v1/checkout.js';

      script.onLoad.listen((_) => startCheckout());
      web.document.head!.append(script);
    } else {
      startCheckout();
    }

    return completer.future;
  }
}

@JS('Razorpay')
extension type Razorpay._(JSObject _) implements JSObject {
  external Razorpay(JSAny options);

  external void open();

  external void on(String event, JSFunction callback);
}
