import 'package:flutter/material.dart';
class DashboardBox extends StatelessWidget {
  final String title;
  final int value;

  DashboardBox({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Value: $value',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}