import 'package:flutter/material.dart';

class DashboardBox extends StatelessWidget {
  final String title;
  final int value;
  final Color background; // Add a Color parameter
  final double height; // Add a height parameter

  DashboardBox({required this.title, required this.value, required this.background, required this.height});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Container(
        height: height, // Set the height of the container
        color: background,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              Text(
                '$value',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
