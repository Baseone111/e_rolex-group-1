
import 'package:flutter/material.dart';
import 'package:new_erolex_app/views/buyers/nav_screens/widgets/banner_widget.dart';
import 'package:new_erolex_app/views/buyers/nav_screens/widgets/category_tile.dart';
import 'package:new_erolex_app/views/buyers/nav_screens/widgets/commons/custom_appbar.dart';
import 'package:new_erolex_app/views/buyers/nav_screens/widgets/search_input_widget.dart';
import 'package:new_erolex_app/views/buyers/nav_screens/widgets/welcome_text.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    int cartItemsCount = 0;
    return Scaffold(
      backgroundColor: Colors.green.shade100,
      appBar: RoundedAppBar(
          appBar: AppBar(
            toolbarHeight: 60,
            centerTitle: true,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.yellow.shade700,
            title: Text(
              'Home',
              style: TextStyle(
                color: Colors.red.shade900,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          borderRadius:
              const BorderRadius.vertical(bottom: Radius.elliptical(30, 30))),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WelcomeText(cartItemsCount: cartItemsCount),
            const SizedBox(height: 20),
            const SearchInputWidget(),
            const SizedBox(height: 20),
            BannerWidget(),
            CategoeryGrid(),
          ],
        ),
      ),
    );
  }
}
