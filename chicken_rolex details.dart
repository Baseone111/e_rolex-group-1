import 'package:flutter/material.dart';
import 'package:helloworld/provider/cart_provider.dart';
import 'package:provider/provider.dart';

class ChickenRolexDetailsPage extends StatefulWidget {
  final Map<String, dynamic> product;

  ChickenRolexDetailsPage({required this.product});

  @override
  _ChickenRolexDetailsPageState createState() =>
      _ChickenRolexDetailsPageState();
}

class _ChickenRolexDetailsPageState extends State<ChickenRolexDetailsPage> {
  int _quantity = 1;

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
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              'Price: ${widget.product['price']} UGX',
              style: TextStyle(fontSize: 20, color: Colors.grey),
            ),
            SizedBox(height: 10),
            Text(widget.product['description']),
            SizedBox(height: 20),
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
                        icon: Icon(Icons.remove),
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
                        style: TextStyle(fontSize: 18),
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
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
                child: const Text('ADD TO CART'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  minimumSize: Size(double.infinity, 56), // Full width button
                ),
              ),
          ],
        ),
      ),
    );
  }
}
