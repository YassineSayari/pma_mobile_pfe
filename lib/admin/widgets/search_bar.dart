import "package:flutter/material.dart";

// ignore: must_be_immutable

class UserSearchBar extends StatelessWidget {
  final ValueChanged<String>? onChanged;
   void Function()? onTap;

   UserSearchBar({Key? key, this.onChanged, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
            color: Color.fromARGB(255, 250, 244, 244), 
            

      child: Row(
        children: [
          Expanded(
            child: Container(
              width: 300,
                    decoration: BoxDecoration(
                     color: Colors.white,
                     borderRadius:BorderRadius.circular(30),
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
                          decoration: InputDecoration(
                            labelText: 'Search...',
                            labelStyle: TextStyle(
                              color: Color.fromARGB(255, 99, 174, 189),
                              fontSize: 25,
                              fontFamily: 'Poppins',
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(30)),
                              borderSide: BorderSide.none,
            
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(30)),
                              borderSide: BorderSide.none,
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
               backgroundColor: Color.fromARGB(255, 65, 29, 196),
              child: Icon(
                Icons.refresh,
                size: 40,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
