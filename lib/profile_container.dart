import 'package:flutter/material.dart';
import 'package:pma/models/user_model.dart';

const ip = "192.168.32.1";
const port = 3002;

class ProfileContainer extends StatelessWidget {
  final User user;


  ProfileContainer({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
           Expanded(flex: 2, child: _TopPortion(user: user)),
          Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Text(
                    "${user.fullName}",
                    style: TextStyle(fontSize: 50,fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      
                    ],
                  ),
                  const SizedBox(height: 16),
                  Information(user: user,)
                ],
            ),
            ),
          ),
        ],
      ),
    );
  }
}


class Information extends StatelessWidget {
  final User user;
  const Information({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
                padding:EdgeInsets.all(12.0),

      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 2,
              offset: Offset(0, 3),
            ),
          ],
        ),
      child:  Column(  
             children: [
              Row(
                children: [
                  
                  Text("Info",
                  style: TextStyle(fontSize: 35,fontWeight: FontWeight.bold),
                  ),
                  Spacer(),

                  Icon(
                     Icons.edit_outlined,
                     size: 35,
                     color: Color.fromARGB(255, 102, 31, 184),
                  ),                  
                ],
              ),

                Row(   
                children: [
                  Icon(Icons.home_outlined,size: 35,),
                  Text(
                    " ${user.address}",
                    style: TextStyle(fontSize: 25),
                    
                  ),
                ],
              ),

              Row(
                children: [
                  Text(
                    "Nationality : ${user.nationality}",
                      style: TextStyle(fontSize: 25),  
                    ),
                ],
              ),

              Row(
                children: [
                  Icon(Icons.email_outlined,size: 35,),
                  Text(
                    " ${user.email}",
                    style: TextStyle(fontSize: 25),
                    
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.phone,size: 35,),
                  Text(
                    " ${user.phone}",
                    style: TextStyle(fontSize: 25),
                  ),
                ],
              ),
             ],
            ),
            
    );
  }
}


class _TopPortion extends StatelessWidget {
   final User user;
  final String imageUrl = "http://$ip:$port/static/images";
  
  const _TopPortion({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 90),
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Color(0xff0043ba), Color(0xff006df1)]),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              )),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: 200,
            height: 200,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration:    BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                            '$imageUrl/${user.image}')
                            ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:pma/models/user_model.dart';

// const ip = "192.168.32.1";
// const port = 3002;

// class ProfileContainer extends StatelessWidget {
//   final User user;
//   final String imageUrl = "http://$ip:$port/static/images";
//   final String noImageUrl = "http://$ip:$port/static/images/16-02-2024--no-image.jpg";

//   ProfileContainer({required this.user});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start, 
//         children: [
//           Container(
//             child: ClipRRect(
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(8.0),
//                 topRight: Radius.circular(8.0),
//               ),
//               child: Image.network(
//                 "$imageUrl/${user.image}",
//                 width: double.infinity,
//                 height: 300.0,
//                 fit: BoxFit.cover,
//                 errorBuilder: (context, error, stackTrace) {
//                   return Image.network(
//                     noImageUrl,
//                     width: double.infinity,
//                     height: 350.0,
//                     fit: BoxFit.cover,
//                   );
//                 },
//               ),
//             ),
//           ),
//           SizedBox(height: 10),
//           Column(
//             children: [
//               Center(
//                 child: Text(
//                   user.fullName,
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 50,
//                   ),
//                 ),
//               ),
//               Text(
//                 user.roles[0],
//                 style: TextStyle(fontSize: 25, color: Colors.grey[500]),
//               ),
//             ],
//           ),
//           SizedBox(height: 10),
//           Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start, 
//             children: [


//                 Row(  
//                 children: [
//                   Icon(Icons.home_outlined),
//                   Text(
//                     " ${user.address}",
//                     style: TextStyle(fontSize: 25),
                    
//                   ),
//                 ],
//               ),

//               Text(
//                 "Nationality : ${user.nationality}",
//                   style: TextStyle(fontSize: 25),  
//                 ),
             

//               Row(
//                 children: [
//                   Icon(Icons.email_outlined),
//                   Text(
//                     " ${user.email}",
//                     style: TextStyle(fontSize: 25),
                    
//                   ),
//                 ],
//               ),
//               Row(
//                 children: [
//                   Icon(Icons.phone),
//                   Text(
//                     " ${user.phone}",
//                     style: TextStyle(fontSize: 25),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
