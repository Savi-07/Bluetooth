// import 'package:flutter/material.dart';

// class Register extends StatefulWidget {
//   const Register({super.key});

//   @override
//   State<Register> createState() => _RegisterState();
// }

// class _RegisterState extends State<Register> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         decoration: BoxDecoration(
//             image: DecorationImage(
//                 image: AssetImage('assets/register.png'), fit: BoxFit.cover)),
//         child: Scaffold(
//           backgroundColor: Colors.transparent,
//           body: Stack(
//             children: [
//               Container(
//                 padding: EdgeInsets.only(left: 40, top: 130),
//                 child: Text(
//                   'Welcome\nBack',
//                   style: TextStyle(color: Colors.white, fontSize: 33),
//                 ),
//               ),
//               SingleChildScrollView(
//                 child: Container(
//                   padding: EdgeInsets.only(
//                       top: MediaQuery.of(context).size.height * 0.4,
//                       right: 35,
//                       left: 35),
//                   child: Column(
//                     children: [
//                       TextField(
//                         decoration: InputDecoration(
//                             hintText: 'Email',
//                             fillColor: Colors.grey.shade100,
//                             filled: true,
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             )),
//                       ),
//                       SizedBox(
//                         height: 30,
//                       ),
//                       TextField(
//                         obscureText: true,
//                         decoration: InputDecoration(
//                             hintText: 'Password',
//                             fillColor: Colors.grey.shade100,
//                             filled: true,
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             )),
//                       ),
//                       SizedBox(
//                         height: 30,
//                       ),
//                       TextField(
//                         obscureText: true,
//                         decoration: InputDecoration(
//                             hintText: 'Confirm Password',
//                             fillColor: Colors.grey.shade100,
//                             filled: true,
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             )),
//                       ),
//                       SizedBox(
//                         height: 30,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             "Sign Up",
//                             style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 27,
//                                 fontWeight: FontWeight.w700),
//                           ),
//                           CircleAvatar(
//                             radius: 30,
//                             backgroundColor: Color(0xff4c505b),
//                             child: IconButton(
//                                 color: Colors.white,
//                                 onPressed: () {},
//                                 icon: Icon(Icons.arrow_forward)),
//                           )
//                         ],
//                       ),
//                       SizedBox(height: 10),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           TextButton(
//                               onPressed: () {
//                                 Navigator.pushNamed(context, 'login');
//                               },
//                               child: Text(
//                                 'Sign In',
//                                 style: TextStyle(
//                                   fontSize: 18,
//                                   color: Colors.white,
//                                 ),
//                               )),
//                         ],
//                       )
//                     ],
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ));
//   }
// }
