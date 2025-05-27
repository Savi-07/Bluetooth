import 'package:flutter/material.dart';
import 'package:fitwatch/utilities/sharedPrefsUtils.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final uidController = TextEditingController();
  late String uid;

  @override
  void dispose() {
    uidController.dispose();
    super.dispose();
  }

  bool verifyUid() {
    uid = uidController.text;
    uid = uid.trim();
    if (uid == "test1234") {
      saveUid(uid);
      // _saveUid(uid);
      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(188, 219, 242, 1),
      body: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Stack(children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "NEW USER LOGIN",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: uidController,
                  decoration: InputDecoration(
                      hintText: "UID",
                      fillColor: Colors.white,
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey, width: 2)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: Color.fromRGBO(96, 181, 255, 1),
                              width: 2))),
                ),
              ],
            ),
            Positioned(
              bottom: 25,
              right: 20,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 30,
                child: Material(
                  shape: CircleBorder(),
                  color: Colors.white,
                  elevation: 4,
                  child: IconButton(
                    onPressed: () {
                      if (verifyUid()) {
                        Navigator.pushNamed(context, 'profileSetUp');
                      } else {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Center(
                                    child: Text(
                                  "Invalid UID",
                                  style: TextStyle(fontSize: 20),
                                )),
                                titlePadding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                content: Text("Please enter correct uid"),
                              );
                            });
                      }
                    },
                    icon: Icon(Icons.arrow_forward),
                    iconSize: 28,
                    color: Color.fromRGBO(96, 181, 255, 1),
                    tooltip: "Set up Profile",
                  ),
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
