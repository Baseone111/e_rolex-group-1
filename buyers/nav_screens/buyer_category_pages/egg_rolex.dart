
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:new_erolex_app/chats/chat_page.dart';
import 'package:new_erolex_app/provider/cart_provider.dart';
import 'package:new_erolex_app/views/buyers/nav_screens/buyer_category_pages/detailsPage/egg_rolex_details_page.dart';
import 'package:provider/provider.dart';

class EggRolex extends StatelessWidget {
  const EggRolex({super.key});

  Stream<List<Map<String, dynamic>>> _fetchProducts() {
    return FirebaseFirestore.instance
        .collection('Egg Rolex')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              return {
                'productName': doc['productName'],
                'price': doc['price'],
                'quantity': doc['quantity'],
                'description': doc['description'],
                'imageUrl': doc['imageUrl'],
                'vendorId': doc['vendorId'],
              };
            }).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow.shade900,
        title: const Text('Egg Rolex'),
        actions: [
          Consumer<CartProvider>(
            builder: (context, cartProvider, child) {
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    onPressed: () {
                      // Navigate to the cart page or show cart details
                    },
                  ),
                  if (cartProvider.cartItemCount > 0)
                    Positioned(
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 12,
                          minHeight: 12,
                        ),
                        child: Text(
                          '${cartProvider.cartItemCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _fetchProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching products'));
          }
          final products = snapshot.data;
          if (products == null || products.isEmpty) {
            return const Center(child: Text('No products found'));
          }
          return GridView.builder(
            padding: const EdgeInsets.all(8.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              childAspectRatio: 0.65,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EggRolexDetailsPage(product: product),
                          ),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(10.0)),
                        child: AspectRatio(
                          aspectRatio: 1.5,
                          child: Image.network(
                            product['imageUrl'],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product['productName'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text('Price: ${product['price']} UGX'),
                          const SizedBox(height: 4),
                          Text('Quantity: ${product['quantity']}'),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Consumer<CartProvider>(
                                builder: (context, cartProvider, child) {
                                  final isInCart = cartProvider.cartItems.any(
                                      (item) =>
                                          item['product']['productName'] ==
                                          product['productName']);
                                  if (isInCart) {
                                    final cartItem = cartProvider.cartItems
                                        .firstWhere((item) =>
                                            item['product']['productName'] ==
                                            product['productName']);
                                    final quantity = cartItem['quantity'];
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                        Text(
                                          '$quantity',
                                          style: const TextStyle(fontSize: 18),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.add),
                                          onPressed: () {
                                            cartProvider.updateItemQuantity(
                                                product, quantity + 1);
                                          },
                                        ),
                                      ],
                                    );
                                  } else {
                                    return ElevatedButton(
                                      onPressed: () {
                                        cartProvider.addItem(product, 1);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.orange,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                      ),
                                      child: const Text('ADD TO CART'),
                                    );
                                  }
                                },
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(Icons.message),
                                onPressed: () {
                                  final String chatId =
                                      '${product['vendorId']}_${product['productName']}'; // Example chatId construction
                                  const String userId =
                                      'someUserId'; // Replace with actual user ID
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ChatPageAll(
                                            chatId: chatId,
                                            userId: userId,
                                            product: product)),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
