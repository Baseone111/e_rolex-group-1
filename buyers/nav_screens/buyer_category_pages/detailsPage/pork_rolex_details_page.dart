import 'package:flutter/material.dart';
import 'package:new_erolex_app/provider/cart_provider.dart';

import 'package:provider/provider.dart';


class PorkRolexDetailsPage extends StatefulWidget {
  final Map<String, dynamic> product;

  const PorkRolexDetailsPage({super.key, required this.product});

  @override
  _PorkRolexDetailsPageState createState() => _PorkRolexDetailsPageState();
}

class _PorkRolexDetailsPageState extends State<PorkRolexDetailsPage> {
  final int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    final isInCart = cartProvider.cartItems.any((item) =>
        item['product']['productName'] == widget.product['productName'] &&
        item['product']['vendorId'] ==
            widget.product['vendorId']); // Include vendorId check

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product['productName']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.network(widget.product['imageUrl']),
            Text(
              widget.product['productName'],
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              'Price: ${widget.product['price']} UGX',
              style: const TextStyle(fontSize: 20, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            Text(widget.product['description']),
            const SizedBox(height: 20),
            if (isInCart)
              Consumer<CartProvider>(
                builder: (context, cartProvider, child) {
                  final cartItem = cartProvider.cartItems.firstWhere((item) =>
                      item['product']['productName'] ==
                          widget.product['productName'] &&
                      item['product']['vendorId'] ==
                          widget.product['vendorId']); // Include vendorId check
                  final quantity = cartItem['quantity'];
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          if (quantity > 1) {
                            cartProvider.updateItemQuantity(
                                widget.product, quantity - 1);
                          } else {
                            cartProvider.removeItem(widget.product);
                          }
                        },
                      ),
                      Text(
                        '$quantity',
                        style: const TextStyle(fontSize: 18),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          cartProvider.updateItemQuantity(
                              widget.product, quantity + 1);
                        },
                      ),
                    ],
                  );
                },
              ),
            if (!isInCart)
              ElevatedButton(
                onPressed: () {
                  cartProvider.addItem(widget.product, _quantity);
                  setState(
                      () {}); // Trigger a rebuild to show quantity controls
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  minimumSize:
                      const Size(double.infinity, 56), // Full width button
                ),
                child: const Text('ADD TO CART'),
              ),
          ],
        ),
      ),
    );
  }
}