import 'package:flutter/material.dart';

class SearchBarmain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        filled: true,
        fillColor: Color.fromARGB(219, 255, 255, 255),
        hintText: 'Search for events, resources, or groups...',
        prefixIcon: const Icon(Icons.search, color: Colors.blueAccent),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
      ),
    );
  }
}
