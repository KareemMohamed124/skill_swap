import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

<<<<<<< HEAD
import '../../../shared/common_ui/screen_manager/screen_manager.dart';
import '../../../shared/dependency_injection/injection.dart';
import '../../../shared/domain/repositories/booking_repository.dart';

=======
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
class PaymentWebViewScreen extends StatefulWidget {
  final String checkoutUrl;
  final String successUrl;
  final String cancelUrl;
<<<<<<< HEAD
  final String bookingId;
=======
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1

  const PaymentWebViewScreen({
    super.key,
    required this.checkoutUrl,
    required this.successUrl,
    required this.cancelUrl,
<<<<<<< HEAD
    required this.bookingId,
=======
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
  });

  @override
  State<PaymentWebViewScreen> createState() => _PaymentWebViewScreenState();
}

class _PaymentWebViewScreenState extends State<PaymentWebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
<<<<<<< HEAD
  bool _isProcessing = false;
=======
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() => _isLoading = true);
          },
          onPageFinished: (String url) {
            setState(() => _isLoading = false);
          },
          onNavigationRequest: (NavigationRequest request) {
            final url = request.url;

<<<<<<< HEAD
            // SUCCESS
            if (url.startsWith(widget.successUrl) ||
                url.startsWith('skillswap://payment/success')) {
              _handlePaymentSuccess();
              return NavigationDecision.prevent;
            }

            // CANCEL
            if (url.startsWith(widget.cancelUrl) ||
                url.startsWith('skillswap://payment/cancel')) {
              Get.back();

=======
            // Check if Stripe redirected to the success URL
            if (url.startsWith(widget.successUrl) ||
                url.startsWith('skillswap://payment/success')) {
              // Close WebView and navigate to success screen
              Get.off(() => const PaymentSuccessScreen());
              return NavigationDecision.prevent;
            }

            // Check if Stripe redirected to the cancel URL
            if (url.startsWith(widget.cancelUrl) ||
                url.startsWith('skillswap://payment/cancel')) {
              // Close WebView and show cancelled notification
              Get.back();
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
              Get.snackbar(
                'Payment Cancelled',
                'Your payment has been cancelled.',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.orange.withOpacity(0.9),
                colorText: Colors.white,
<<<<<<< HEAD
              );

=======
                duration: const Duration(seconds: 3),
              );
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
<<<<<<< HEAD
=======
          onWebResourceError: (WebResourceError error) {
            // Handle custom scheme redirects (skillswap://) that may
            // appear as errors on some platforms
            if (error.description.contains('skillswap://')) {
              return;
            }
          },
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
        ),
      )
      ..loadRequest(Uri.parse(widget.checkoutUrl));
  }

<<<<<<< HEAD
  Future<void> _handlePaymentSuccess() async {
    if (_isProcessing) return;
    _isProcessing = true;

    try {
      final repo = sl<BookingRepository>();

      final res = await repo.confirmPayment(widget.bookingId);

      final status = res['paymentStatus'];

      if (status == 'paid') {
        _showSuccessDialog();
      } else {
        Get.back();

        Get.snackbar(
          "Payment Pending",
          "Payment not confirmed yet",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.back();

      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }

    _isProcessing = false;
  }

  void _showSuccessDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          "Payment Successful",
          textAlign: TextAlign.center,
        ),
        content: const Text(
          "Your payment has been confirmed successfully.",
          textAlign: TextAlign.center,
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Get.back(); // close dialog

                Get.off(() => const PaymentSuccessScreen());
              },
              child: const Text("Continue"),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

=======
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Get.back();
<<<<<<< HEAD

=======
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
            Get.snackbar(
              'Payment Cancelled',
              'You closed the payment page.',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.orange.withOpacity(0.9),
              colorText: Colors.white,
<<<<<<< HEAD
=======
              duration: const Duration(seconds: 3),
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
            );
          },
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
<<<<<<< HEAD
          if (_isLoading) const Center(child: CircularProgressIndicator()),
=======
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
        ],
      ),
    );
  }
}

/// A simple "Payment Successful" screen shown after Stripe checkout completes.
class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: screenWidth * 0.3,
                  height: screenWidth * 0.3,
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle_rounded,
                    color: Colors.green,
                    size: screenWidth * 0.2,
                  ),
                ),
                SizedBox(height: screenWidth * 0.08),
                Text(
                  'Payment Successful!',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                SizedBox(height: screenWidth * 0.03),
                Text(
                  'Your booking has been paid successfully. You can now join your session when it starts.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.textTheme.bodySmall?.color,
                  ),
                ),
                SizedBox(height: screenWidth * 0.1),
                SizedBox(
                  width: double.infinity,
                  height: screenWidth * 0.12,
                  child: ElevatedButton(
                    onPressed: () {
<<<<<<< HEAD
                      Get.offAll(() => ScreenManager(
                            initialIndex: 3,
                            initialSessionTab: 0, // Requests
                          ));
=======
                      // Pop back to the sessions screen
                      Get.back();
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(screenWidth * 0.03),
                      ),
                    ),
                    child: Text(
                      'Back to Sessions',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: screenWidth * 0.04,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
