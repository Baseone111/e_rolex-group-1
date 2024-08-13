
import 'package:flutter/material.dart';
import 'package:new_erolex_app/views/buyers/nav_screens/widgets/order_confirmation.dart';


class PaymentOptionsPage extends StatelessWidget {
  final double totalPrice;

  const PaymentOptionsPage({super.key, required this.totalPrice});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Options'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Payment Method',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: Image.asset('assets/images/Airtel-MTN.jpg',
                  width: 24, height: 150),
              title: const Text('Mobile Money'),
              onTap: () {
                // Implement Airtel Money payment logic here
              },
            ),
            ListTile(
              leading: const Icon(Icons.local_shipping),
              title: const Text('Payment on Delivery'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => OrderConfirmationPage(
                            totalPrice:
                                totalPrice))); // Implement Payment on Delivery logic here
              },
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '$totalPrice UGX',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
