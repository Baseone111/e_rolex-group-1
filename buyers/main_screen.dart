
import 'package:flutter/material.dart';
import 'package:new_erolex_app/chats/chat_page_vender.dart';
import 'package:new_erolex_app/views/buyers/nav_screens/account_screen.dart';
import 'package:new_erolex_app/views/buyers/nav_screens/help_screen.dart';
import 'package:new_erolex_app/views/buyers/nav_screens/home_screen.dart';


class MainScreen extends StatefulWidget {
  final String customerId;

  const MainScreen({required this.customerId, super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _pageIndex = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    // Placeholder product object
    Map<String, dynamic> placeholderProduct = {
      'productName': 'Sample Product',
      'price': 1000,
      'quantity': 1,
      'description': 'This is a sample product.',
      'imageUrl': 'https://via.placeholder.com/150',
      'vendorId': 'someVendorId',
    };

    String vendorId = 'someVendorId';
    String chatId = '${widget.customerId}_$vendorId';

    _pages = [
      const HomeScreen(),
      ChatPageVendor(userId: widget.customerId), // Use widget.customerId here
      const HelpScreen(),
      const AccountScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BottomNavigationBar(
          backgroundColor: Colors.yellow.shade400,
          type: BottomNavigationBarType.fixed,
          currentIndex: _pageIndex,
          onTap: (value) {
            setState(() {
              _pageIndex = value;
            });
          },
          unselectedItemColor: Colors.black,
          selectedItemColor: Colors.pink,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'HOME'),
            BottomNavigationBarItem(
                icon: Icon(Icons.chat_sharp), label: 'Chat'),
            BottomNavigationBarItem(
                icon: Icon(Icons.help_center), label: 'Help'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'ACCOUNT')
          ],
        ),
      ),
      body: _pages[_pageIndex],
    );
  }
}
