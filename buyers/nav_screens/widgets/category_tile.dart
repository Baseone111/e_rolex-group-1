
import 'package:flutter/material.dart';
import 'package:new_erolex_app/views/buyers/nav_screens/buyer_category_pages/chicken_rolex.dart';
import 'package:new_erolex_app/views/buyers/nav_screens/buyer_category_pages/egg_rolex.dart';
import 'package:new_erolex_app/views/buyers/nav_screens/buyer_category_pages/kikomando.dart';
import 'package:new_erolex_app/views/buyers/nav_screens/buyer_category_pages/meat_rolex.dart';
import 'package:new_erolex_app/views/buyers/nav_screens/buyer_category_pages/pork_rolex.dart';
import 'package:new_erolex_app/views/buyers/nav_screens/buyer_category_pages/samosa_rolex.dart';
import 'package:new_erolex_app/views/buyers/nav_screens/buyer_category_pages/vegetable_rolex.dart';


class CategoeryGrid extends StatelessWidget {
  CategoeryGrid({super.key});

  final List<Map<String, dynamic>> categories = [
    {
      'name': 'Vegetable Rolex',
      'image': 'assets/images/chapati vegetable rolex.jpg',
      'page': const VegetableRolex()
    },
    {
      'name': 'Chicken Rolex',
      'image': 'assets/images/chicken rolex.jpg',
      'page': const ChickenRolex()
    },
    {
      'name': 'Egg Rolex',
      'image': 'assets/images/egg rolex.jpg',
      'page':const EggRolex()
    },
    {
      'name': 'Kikomando',
      'image': 'assets/images/kikomando.jpg',
      'page': const Kikomando()
    },
    {
      'name': 'Meat Rolex',
      'image': 'assets/images/meat rolex.jpg',
      'page': const MeatRolexPage()
    },
    {
      'name': 'Pork Rolex',
      'image': 'assets/images/porkrolex.jpg',
      'page': const PorkRolex()
    },
    {
      'name': 'Samosa Rolex',
      'image': 'assets/images/sumbusa chapati.jpg',
      'page': const SamosaRolex()
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Categories',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 3 / 2,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              var category = categories[index];
              return GestureDetector(
                onTap: () {
                  // Navigate to the specific category page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => category['page'],
                    ),
                  );
                },
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: AssetImage(category['image']!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      category['name']!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
