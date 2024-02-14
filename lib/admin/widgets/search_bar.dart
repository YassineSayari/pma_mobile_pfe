import "package:flutter/material.dart";

class UserSearchBar extends StatelessWidget {
  final ValueChanged<String>? onChanged;
   void Function()? onTap;

   UserSearchBar({Key? key, this.onChanged, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 100,
          child: TextField(
            onChanged: onChanged,
            decoration: InputDecoration(
              labelText: 'Search',
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Icon(
              Icons.refresh
          ),
        ),
      ],
    );
  }
}
