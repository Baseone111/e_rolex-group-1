import 'package:flutter/material.dart';

class SearchInputWidget extends StatelessWidget {
  const SearchInputWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: const TextField(
          decoration: InputDecoration(
              fillColor: Color(0xfff9f3f3),
              filled: true,
              hintText: 'search for products',
              border: OutlineInputBorder(borderSide: BorderSide.none),
              prefixIcon: Icon(Icons.search)),
        ),
      ),
    );
  }
}
