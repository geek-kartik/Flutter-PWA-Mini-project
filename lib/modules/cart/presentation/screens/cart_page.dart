import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_project_pwa/core/errors/error_handler.dart';
import 'package:mini_project_pwa/core/services/logger/logger_service.dart';
import 'package:mini_project_pwa/core/services/payment/razorpay_web.dart';
import 'package:mini_project_pwa/core/services/socket/payment_socket_service.dart';
import 'package:mini_project_pwa/core/widgets/common_app_bar.dart';
import 'package:mini_project_pwa/core/widgets/optimized_image.dart';
import 'package:mini_project_pwa/modules/cart/presentation/bloc/cart_state.dart';
import 'package:mini_project_pwa/modules/cart/presentation/widgets/cart_action_widget.dart';
import 'package:mini_project_pwa/modules/cart/presentation/widgets/invoice_dialog.dart';
import 'package:mini_project_pwa/modules/home/domain/entities/product_item.dart';
import 'package:mini_project_pwa/modules/home/presentation/bloc/home_bloc.dart';
import 'package:mini_project_pwa/modules/home/presentation/bloc/home_event.dart';
import 'package:mini_project_pwa/modules/home/presentation/bloc/home_state.dart';
import '../bloc/cart_bloc.dart';

/// Cart page that displays all products added in cart using [CartBloc].
class CartPage extends StatefulWidget {
  final String? productId;

  const CartPage({super.key, this.productId});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final socketService = PaymentSocketService();

  late RazorpayWeb _razorpay;

  String? invoiceUrl;

  @override
  void initState() {
    super.initState();

    _razorpay = RazorpayWeb();
  }

  /// Proceed to razorpay payment
  void openCheckout(BuildContext context) async {
    var options = {
      'key': 'rzp_test_1DP5mmOlF5G5ag',
      'amount': 100 * 100, // amount in paise
      'currency': 'INR',
      'name': 'GeekyAnts.',
      'description': 'Fine T-Shirt',
      'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'},
      'external': {
        'wallets': ['paytm'],
      },
    };

    try {
      final response = await _razorpay.open(options);

      if (response["status"] == "success") {
        _handlePaymentSuccess(response);
      } else if (response["status"] == "error") {
        _handlePaymentError(response);
      } else {
        _handlePaymentCancelled(response);
      }
    } catch (e) {
      ErrorHandler.showErrorDialog(context, e);
    }
  }

  void _handlePaymentSuccess(Map<String, dynamic> response) {
    LoggerService.instance.d('Success Response: $response');

    // Optional: trigger socket
    socketService.connect(
      onStatus: (status) {
        if (status == "PAYMENT_SUCCESS") {
          setState(() {
            invoiceUrl = "get_invoice_url_response";
          });
        }
      },
    );

    socketService.sendSuccessStatus();
  }

  void _handlePaymentError(Map<String, dynamic> response) {
    LoggerService.instance.d('Error Response: ${response["message"]}');
    showDummyInvoiceDialog();
  }

  void _handlePaymentCancelled(Map<String, dynamic> response) {
    LoggerService.instance.d('Error Response: ${response["message"]}');
    showDummyInvoiceDialog();
  }

  /// To show invoice dialog after payment success
  void showDummyInvoiceDialog() {
    // assigning fake invoiceUrl
    invoiceUrl = "https://morth.nic.in/sites/default/files/dd12-13_0.pdf";

    if (invoiceUrl != null) {
      showInvoiceDialog(context: context, invoiceUrl: invoiceUrl!);
    } else {
      // show error msg
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: "Cart", centerTitle: false),
      body: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) {
          if (widget.productId == null) return;

          final cartBloc = context.read<CartBloc>();
          if (state is ProductLoaded) {
            final product = state.products.firstWhere(
              (p) => p.id.toString() == widget.productId,
              orElse: () => ProductItem.empty(),
            );

            cartBloc.add(AddToCart(product));
          }
        },
        child: BlocBuilder<CartBloc, CartState>(
          builder: (context, cartState) {
            if (cartState.items.isEmpty) {
              return const Center(child: Text("Cart is empty"));
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartState.items.length,
                    itemBuilder: (context, index) {
                      final item = cartState.items[index];
                      return ListTile(
                        leading: OptimizedImage(
                          imageUrl: item.product.image,
                          fit: BoxFit.contain,
                          width: 48,
                        ),
                        title: Text(item.product.title),
                        subtitle: Text(
                          "\$${(item.product.price * item.quantity).toStringAsFixed(2)}",
                        ),
                        trailing: CartActionWidget(
                          product: cartState.items[index].product,
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.grey[300],
                  ),
                  child: Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      Text(
                        "Total: \$${cartState.totalAmount.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(Colors.green),
                          padding: WidgetStatePropertyAll(
                            EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                          ),
                        ),
                        onPressed: () {
                          openCheckout(context);
                        },
                        child: const Text(
                          "Proceed to Pay",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
