import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:new_erolex_app/provider/cart_provider.dart';

import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderConfirmationPage extends StatefulWidget {
  final double totalPrice;

  const OrderConfirmationPage({super.key, required this.totalPrice});

  @override
  _OrderConfirmationPageState createState() => _OrderConfirmationPageState();
}

class _OrderConfirmationPageState extends State<OrderConfirmationPage> {
  String _locationUrl = '';
  bool _isFetchingLocation = false;

  Future<void> _fetchAndShowLocation() async {
    setState(() {
      _isFetchingLocation = true;
    });

    LatLng currentLocation = await _getCurrentLocation();
    _locationUrl =
        'https://www.google.com/maps/search/?api=1&query=${currentLocation.latitude},${currentLocation.longitude}';

    setState(() {
      _isFetchingLocation = false;
    });
  }

  Future<LatLng> _getCurrentLocation() async {
    LocationPermission permission;

    // Check location permission status
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permissions are denied');
        return const LatLng(0, 0); // Default location
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print(
          'Location permissions are permanently denied, we cannot request permissions.');
      return const LatLng(0, 0); // Default location
    }

    try {
      // Get current location
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      return LatLng(position.latitude, position.longitude);
    } catch (e) {
      print('Error getting current location: $e');
      return const LatLng(0, 0); // Default location if error occurs
    }
  }

  Future<void> _confirmOrder() async {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final cartItems = cartProvider.cartItems;

    try {
      // Save order details to Firestore
      CollectionReference orders =
          FirebaseFirestore.instance.collection('orders');
      await orders.add({
        'totalPrice': widget.totalPrice,
        'locationUrl': _locationUrl,
        'items': cartItems.map((item) {
          return {
            'productName': item['product']['productName'],
            'quantity': item['quantity'],
            'price': item['product']['price'],
            'imageUrl': item['product']['imageUrl'],
            'userId': item['product']['userId'],
            'vendorId': item['product']['vendorId'], // Ensure 'userId' is saved
          };
        }).toList(),
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Clear cart
      cartProvider.clearCart();

      // Optionally navigate back or show a success message
      Navigator.pop(context);
    } catch (e) {
      print('Error confirming order: $e');
      // Optionally show an error message
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.cartItems;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Confirmation'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Receipt Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Receipt',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      final product = item['product'];
                      final quantity = item['quantity'];

                      double price = product['price'] is String
                          ? double.tryParse(product['price']) ?? 0.0
                          : product['price'];

                      return ListTile(
                        title: Text(product['productName']),
                        subtitle: Text('Quantity: $quantity'),
                        trailing: Text('Price: ${price * quantity} UGX'),
                      );
                    },
                  ),
                  const Divider(),
                  Row(
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
                        '${widget.totalPrice} UGX',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Location Picker Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select Delivery Location',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Center(
                    child: _isFetchingLocation
                        ? const CircularProgressIndicator()
                        : IconButton(
                            icon: const Icon(Icons.map, size: 50, color: Colors.blue),
                            onPressed: () async {
                              await _fetchAndShowLocation();
                            },
                          ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Tap the map icon to fetch your current location.',
                    style: TextStyle(fontSize: 16),
                  ),
                  if (_locationUrl.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    const Text(
                      'Your location URL:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SelectableText(
                      _locationUrl,
                      style: const TextStyle(color: Colors.blue),
                    ),
                  ]
                ],
              ),
            ),
            // Confirm Order Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  _confirmOrder();
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  'Confirm Order',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
