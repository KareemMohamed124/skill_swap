import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebViewScreen extends StatefulWidget {
  final String checkoutUrl;
  final String successUrl;
  final String cancelUrl;

  const PaymentWebViewScreen({
    super.key,
    required this.checkoutUrl,
    required this.successUrl,
    required this.cancelUrl,
  });

  @override
  State<PaymentWebViewScreen> createState() => _PaymentWebViewScreenState();
}

class _PaymentWebViewScreenState extends State<PaymentWebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

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
              Get.snackbar(
                'Payment Cancelled',
                'Your payment has been cancelled.',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.orange.withOpacity(0.9),
                colorText: Colors.white,
                duration: const Duration(seconds: 3),
              );
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
          onWebResourceError: (WebResourceError error) {
            // Handle custom scheme redirects (skillswap://) that may
            // appear as errors on some platforms
            if (error.description.contains('skillswap://')) {
              return;
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.checkoutUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Get.back();
            Get.snackbar(
              'Payment Cancelled',
              'You closed the payment page.',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.orange.withOpacity(0.9),
              colorText: Colors.white,
              duration: const Duration(seconds: 3),
            );
          },
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
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
                      // Pop back to the sessions screen
                      Get.back();
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
