import 'package:fitwatch/utilities/sharedPrefsUtils.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'dart:convert';
import 'package:fitwatch/globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  // late String? name, age, height, weight, uid;

  @override
  void initState() {
    super.initState();
    // getDateFromSharedPref();
  }

  // _getDateFromSharedPref() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   if (!mounted) return;
  //   setState(() {
  //     name = prefs.getString('name') ?? "";
  //     age = prefs.getString('age') ?? "";
  //     height = prefs.getString('height') ?? "";
  //     weight = prefs.getString('weight') ?? "";
  //     uid = prefs.getString('uid') ?? "";
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   backgroundColor: const Color.fromRGBO(96, 181, 255, 1),
        //   title: const Text(
        //     'User Profile',
        //     style: TextStyle(
        //       fontSize: 25,
        //       fontWeight: FontWeight.w600,
        //       color: Colors.white,
        //     ),
        //   ),
        //   actions: [
        //     // Optional network status icon
        //     // Icon(
        //     //   _status == "Connected" ? Icons.wifi : Icons.wifi_off,
        //     //   color: _status == "Connected" ? Colors.green : Colors.red,
        //     // ),
        //   ],
        // ),
        // backgroundColor: const Color.fromRGBO(245, 251, 255, 1.0), // Light background
        body: FutureBuilder<void>(
            future: getDateFromSharedPref(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.account_circle,
                            size: 100, color: Colors.blueGrey),
                        const SizedBox(height: 30),
                        userData("Username:", globals.name),
                        const SizedBox(height: 15),
                        userData("UID:", globals.uid),
                        const SizedBox(height: 15),
                        userData("Age:", globals.age),
                        const SizedBox(height: 15),
                        userData("Height (ft):", globals.height),
                        const SizedBox(height: 15),
                        userData("Weight (kg):", globals.weight),
                        const SizedBox(height: 40),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pushNamed(context, 'editProfile');
                          },
                          icon: Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                          label: Text(
                            "Edit Profile",
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromRGBO(96, 181, 255, 1),
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 12),
                            textStyle: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }));
  }

  Widget userData(String key, String value) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              key,
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
