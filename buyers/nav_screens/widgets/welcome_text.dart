
import 'package:flutter/material.dart';
import 'package:new_erolex_app/provider/cart_provider.dart';
import 'package:new_erolex_app/views/buyers/nav_screens/widgets/cart_dialogue_details.dart';

import 'package:provider/provider.dart'; // Import the new CartDetailsPage

class WelcomeText extends StatelessWidget {
  final int cartItemsCount;
  const WelcomeText({super.key, required this.cartItemsCount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        left: 25,
        right: 15,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Philbert, what are you \n looking for 🙄',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),
          Consumer<CartProvider>(
            builder: (context, cartProvider, child) {
              return IconButton(
                icon: Stack(
                  children: [
                    const Icon(Icons.shopping_cart, size: 30),
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
                              fontSize: 9,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CartDetailsPage(),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
