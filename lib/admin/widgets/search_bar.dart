import "package:flutter/material.dart";
import "package:pma/theme.dart";

class UserSearchBar extends StatelessWidget {
  final ValueChanged<String>? onChanged;
   void Function()? onTap;

   UserSearchBar({Key? key, this.onChanged, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
            

      child: Row(
        children: [
          Expanded(
            child: Container(
              width: 300,
                    decoration: BoxDecoration(
                     color: Colors.white,
                     borderRadius:BorderRadius.circular(8),
                    boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 2,
              offset: Offset(0, 1), 
            ),
                    ],
                  ),
              child: TextField(
                onChanged: onChanged,
                  style: TextStyle(
                    fontSize: 24, // Set the desired font size here
                    fontFamily: AppTheme.fontName,
                    fontWeight: FontWeight.w500
                    ),
                          decoration: InputDecoration(
                            labelText: 'Search...',
                            labelStyle: TextStyle(
                              color: Color.fromARGB(255, 99, 174, 189),
                              fontSize: 24,
                              fontFamily: AppTheme.fontName,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide.none,
            
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide.none,
                              
                            ),
                            prefixIcon: Icon(
                            Icons.search,
                              color: Color.fromARGB(255, 99, 174, 189),
                              size: 30,
                              ),
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                          ),
              ),
            ),
          ),
          SizedBox(width: 10),
          GestureDetector(
            onTap: onTap,
            child: CircleAvatar(
              radius: 30,
               backgroundColor: Colors.white,
              child: Icon(
                Icons.refresh,
                size: 50,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
