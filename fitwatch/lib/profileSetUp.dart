import 'package:fitwatch/utilities/sharedPrefsUtils.dart';
import 'package:fitwatch/widgets/detailsTextField.dart';
import 'package:flutter/material.dart';

class ProfileSetUp extends StatefulWidget {
  const ProfileSetUp({super.key});

  @override
  State<ProfileSetUp> createState() => _ProfileSetUPState();
}

class _ProfileSetUPState extends State<ProfileSetUp> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();

  final formkey = GlobalKey<FormState>();

  // late String name, age, height, weight;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 236, 219, 1.0),
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(15.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "ENTER USER DETAILS",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    Material(
                      color: Colors.white,
                      elevation: 12,
                      borderRadius: BorderRadius.circular(15),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            SizedBox(height: 20),
                            Form(
                              key: formkey,
                              child: Column(
                                children: [
                                  buildTextField("Name", nameController),
                                  buildTextField("Age", ageController),
                                  buildTextField(
                                      "Height (ft)", heightController),
                                  buildTextField(
                                      "Weight (kg)", weightController),
                                ],
                              ),
                            ),
                            SizedBox(height: 20), // Space for button
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
                  onPressed: () async {
                    if (formkey.currentState!.validate()) {
                      print("form validated");
                      saveDetails(nameController.text, ageController.text,
                          heightController.text, weightController.text);
                      Navigator.pushNamed(context, 'home');
                    }
                  },
                  icon: Icon(Icons.arrow_forward),
                  iconSize: 28,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
