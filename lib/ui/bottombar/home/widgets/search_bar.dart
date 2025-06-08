import 'package:flutter/material.dart';

import '../controller/home_controller.dart';

class CustomSearchBar extends StatelessWidget {
  final HomeController controller;

  CustomSearchBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: TextField(
        onChanged: (value) => controller.searchText.value = value,
        decoration: InputDecoration(
            icon: Icon(Icons.search),
            hintText: "Search for..",
            border: InputBorder.none,
            suffixIcon: Icon(Icons.tune, color: Colors.blue)),
      ),
    );
  }
}
