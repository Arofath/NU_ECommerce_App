import 'package:e_commerce/Controllers/cart_controller.dart';
import 'package:e_commerce/Screen/bottom_navigation_bars.dart';
import 'package:e_commerce/Theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../auth/widget/gradient_button.dart';

class OrderConfirmationScreen extends StatefulWidget {
  const OrderConfirmationScreen({super.key});

  @override
  State<OrderConfirmationScreen> createState() =>
      _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> {
  final CartController cartController = Get.find<CartController>();

  String formatPrice(double amount) {
    // Use user's locale; fallback to USD
    return NumberFormat.currency(decimalDigits: 2).format(amount);
  }

  @override
  Widget build(BuildContext context) {
    final subtotal = cartController.subtotal;
    final shipping = cartController.shippingCost;
    final importBreakdown = cartController.getImportChargesBreakdown();
    final importTax = importBreakdown['importTax'] ?? 0.0;
    final customsDuty = importBreakdown['customsDuty'] ?? 0.0;
    final handlingFee = importBreakdown['handlingFee'] ?? 0.0;
    final total = subtotal + shipping + importTax + customsDuty + handlingFee;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildSteps(),
                _buildSuccessWidget(),
                _buildSectionCard(
                  title: "Order Details",
                  children: [
                    _detailRow('Order No',
                        '#ORD-${DateTime.now().millisecondsSinceEpoch ~/ 100000}'),
                    _detailRow('Order Date',
                        DateFormat.yMMMMd().format(DateTime.now())),
                    _detailRow('Total Amount', formatPrice(total)),
                    _detailRow('Status', 'Processing',
                        isBold: true, valueColor: warning),
                  ],
                ),
                _buildSectionCard(
                  title: "Payment Details",
                  children: [
                    _detailRow('Items Subtotal', formatPrice(subtotal)),
                    _detailRow('Shipping', formatPrice(shipping)),
                    _detailRow('Import Tax', formatPrice(importTax)),
                    _detailRow('Customs Duty', formatPrice(customsDuty)),
                    _detailRow('Handling Fee', formatPrice(handlingFee)),
                    const Divider(height: 24),
                    _detailRow('Total', formatPrice(total),
                        isBold: true, valueColor: primaryColor),
                  ],
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
      bottomSheet: _buildContinueShoppingButton(),
    );
  }

  SliverAppBar _buildAppBar() => SliverAppBar(
        foregroundColor: Colors.white,
        pinned: true,
        expandedHeight: 120,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: primaryGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const FlexibleSpaceBar(
            title: Text(
              "Order Confirmation",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),
        ),
      );

  Widget _buildSteps() => Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            _step(1, "Shipping", true),
            _stepConnector(true),
            _step(2, "Payment", true),
            _stepConnector(true),
            _step(3, "Confirm", true),
          ],
        ),
      );

  Widget _buildSuccessWidget() => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                  color: success.withOpacity(0.1), shape: BoxShape.circle),
              child: const Icon(Icons.check_circle, size: 80, color: success),
            ),
            const SizedBox(height: 20),
            const Text(
              "Order Placed Successfully",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: textPrimary),
            ),
            const SizedBox(height: 8),
            const Text(
              "Your order has been confirmed and will be delivered soon",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: textSecondary),
            ),
          ],
        ),
      );

  Widget _buildSectionCard(
      {required String title, required List<Widget> children}) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              offset: const Offset(0, 5),
              blurRadius: 10,
              color: Colors.black.withOpacity(0.05))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textPrimary)),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value,
      {bool isBold = false, Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                  color: textSecondary)),
          Text(value,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                  color: valueColor ?? textPrimary)),
        ],
      ),
    );
  }

  Widget _step(int num, String text, bool active) => Expanded(
        child: Column(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: active ? primaryColor : Colors.white,
                border: Border.all(
                    color: active ? primaryColor : textSecondary, width: 2),
              ),
              child: Center(
                  child: Text(num.toString(),
                      style: TextStyle(
                          color: active ? Colors.white : textSecondary,
                          fontWeight: FontWeight.bold))),
            ),
            const SizedBox(height: 4),
            Text(text,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: active ? FontWeight.bold : FontWeight.normal,
                    color: active ? primaryColor : textSecondary)),
          ],
        ),
      );

  Widget _stepConnector(bool active) => Container(
      width: 40,
      height: 2,
      color: active ? primaryColor : textSecondary.withOpacity(0.2));

  Widget _buildContinueShoppingButton() => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5))
        ]),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: GradientButton(
                  text: "Continue Shopping",
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (c) => const BottomNavigationBars()),
                      (route) => false,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
}
