import "package:flutter/material.dart";

class UserSearchBar extends StatelessWidget {
  final ValueChanged<String>? onChanged;

  const UserSearchBar({Key? key, this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 150,
          child: TextField(
            onChanged: onChanged,
            decoration: InputDecoration(
              labelText: 'Search',
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ),
      ],
    );
  }
}
