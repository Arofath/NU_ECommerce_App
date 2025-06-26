import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Controllers/cart_controller.dart';
import '../../Theme/theme.dart';
import '../auth/widget/gradient_button.dart';
import 'payment_screen.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({super.key});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  final CartController cartController = Get.find<CartController>();
  int _selectedAddressIndex = 0;
  int _selectedDeliveryMethod = 0;

  final deliveryMethods = [
    {
      'title': 'Standard Delivery',
      'duration': '3-5 business days',
      'icon': Icons.local_shipping_outlined,
      'price': 5.99,
    },
    {
      'title': 'Express Delivery',
      'duration': '1-2 business days',
      'icon': Icons.delivery_dining_outlined,
      'price': 9.99,
    },
  ];

  double _calculateTotal() {
    final shipping =
        deliveryMethods[_selectedDeliveryMethod]['price'] as double;
    final subtotal = cartController.subtotal;
    final import = cartController.importCharges;
    return subtotal + shipping + import;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            foregroundColor: Colors.white,
            pinned: true,
            expandedHeight: 120,
            backgroundColor: primaryColor,
            flexibleSpace: const FlexibleSpaceBar(
              title: Text(
                "Checkout",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      _buildStep(1, "Shipping", true),
                      _buildStepConnector(true),
                      _buildStep(2, "Payment", false),
                      _buildStepConnector(false),
                      _buildStep(3, "Confirm", false),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Shipping Address",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: darkColor,
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.add),
                            label: const Text("Add New"),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ...List.generate(
                        2,
                        (index) => _buildAddressCard(index),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Delivery Method",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: darkColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...List.generate(
                        2,
                        (index) => _buildDeliveryMethodCard(
                          index,
                          deliveryMethods[index],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Order Summary",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: darkColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildSummaryRow(
                        "Items (${cartController.totalQuantity})",
                        "\$${cartController.subtotal.toStringAsFixed(2)}",
                      ),
                      _buildSummaryRow(
                        "Shipping",
                        "\$${(deliveryMethods[_selectedDeliveryMethod]['price'] as double).toStringAsFixed(2)}",
                      ),
                      if (cartController.importCharges > 0) ...[
                        _buildSummaryRow(
                          "Import Tax",
                          "\$${cartController.getImportChargesBreakdown()['importTax']!.toStringAsFixed(2)}",
                        ),
                        _buildSummaryRow(
                          "Customs Duty",
                          "\$${cartController.getImportChargesBreakdown()['customsDuty']!.toStringAsFixed(2)}",
                        ),
                        _buildSummaryRow(
                          "Handling Fee",
                          "\$${cartController.getImportChargesBreakdown()['handlingFee']!.toStringAsFixed(2)}",
                        ),
                      ] else
                        _buildSummaryRow("Import Charges", "\$0.00"),
                      const Divider(height: 24),
                      _buildSummaryRow(
                        "Total",
                        "\$${_calculateTotal().toStringAsFixed(2)}",
                        isTotal: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10.0,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: GradientButton(
            text: "Continue to Payment",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PaymentScreen(),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? darkColor : greyColor,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? darkColor : greyColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryMethodCard(int index, Map<String, dynamic> method) {
    final isSelected = _selectedDeliveryMethod == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDeliveryMethod = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: isSelected ? primaryColor : Colors.transparent,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Radio(
              value: index,
              groupValue: _selectedDeliveryMethod,
              onChanged: (value) {
                setState(() {
                  _selectedDeliveryMethod = value as int;
                });
              },
              activeColor: primaryColor,
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                method['icon'] as IconData,
                color: primaryColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    method['title'] as String,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: darkColor,
                    ),
                  ),
                  Text(
                    method['duration'] as String,
                    style: const TextStyle(
                      color: greyColor,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '\$${(method['price'] as double).toStringAsFixed(2)}',
              style: const TextStyle(
                color: primaryColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressCard(int index) {
    final isSelected = _selectedAddressIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedAddressIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? primaryColor : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Radio(
              value: index,
              groupValue: _selectedAddressIndex,
              onChanged: (value) {
                setState(() {
                  _selectedAddressIndex = value as int;
                });
              },
              activeColor: primaryColor,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        "Dear Pro",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: darkColor,
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (index == 0)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            "Default",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "+1 234 567 890",
                    style: TextStyle(
                      fontSize: 14,
                      color: greyColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "123 Main St, Apt 48\n New York, NY 10001\nUnited States",
                    style: TextStyle(
                      fontSize: 14,
                      color: darkColor,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.edit_outlined,
                    color: primaryColor,
                  ),
                ),
                if (index != 0)
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepConnector(bool isActive) {
    return Container(
      width: 40,
      height: 2,
      color: isActive ? primaryColor : greyColor.withOpacity(0.2),
    );
  }

  Widget _buildStep(int number, String title, bool isActive) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive ? primaryColor : Colors.white,
              border: Border.all(
                color: isActive ? primaryColor : greyColor,
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                number.toString(),
                style: TextStyle(
                  color: isActive ? Colors.white : greyColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: isActive ? primaryColor : greyColor,
              fontSize: 12,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
