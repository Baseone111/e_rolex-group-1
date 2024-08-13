
import 'package:flutter/material.dart';
import 'package:new_erolex_app/provider/cart_provider.dart';
import 'package:new_erolex_app/views/buyers/nav_screens/widgets/payment_options.dart';

import 'package:provider/provider.dart';

class CartDetailsPage extends StatelessWidget {
  const CartDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.cartItems;

    // Calculate the total price of items in the cart
    double totalPrice = 0.0;
    for (var item in cartItems) {
      double price = item['product']['price'] is String
          ? double.tryParse(item['product']['price']) ?? 0.0
          : item['product']['price'];
      int quantity = item['quantity'];
      totalPrice += price * quantity;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart Details'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '$totalPrice UGX',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                final product = item['product'];
                final quantity = item['quantity'];

                // Ensure price is correctly extracted again here
                double price = product['price'] is String
                    ? double.tryParse(product['price']) ?? 0.0
                    : product['price'];

                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    leading: Image.network(product['imageUrl']),
                    title: Text(product['productName']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                if (quantity > 1) {
                                  cartProvider.updateItemQuantity(
                                      product, quantity - 1);
                                } else {
                                  cartProvider.removeItem(product);
                                }
                              },
                            ),
                            Text('$quantity'),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                cartProvider.updateItemQuantity(
                                    product, quantity + 1);
                              },
                            ),
                          ],
                        ),
                        Text('Price: $price UGX'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        cartProvider.removeItem(product);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        PaymentOptionsPage(totalPrice: totalPrice),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize:
                    const Size(double.infinity, 50), // Makes the button full width
              ),
              child: const Text(
                'Checkout',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
