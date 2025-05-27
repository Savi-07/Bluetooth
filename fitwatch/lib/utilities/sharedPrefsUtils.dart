import 'package:shared_preferences/shared_preferences.dart';
import 'package:fitwatch/globals.dart' as globals;

Future<String> getInitialRoute() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if ((prefs.containsKey('uid')) &&
      (prefs.containsKey('name')) &&
      prefs.containsKey('age') &&
      (prefs.containsKey('height')) &&
      (prefs.containsKey('weight'))) {
    return 'home';
  } else {
    return 'login';
  }
}

saveUid(String uid) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('uid', uid);
}

Future<void> saveDetails(
    String name, String age, String height, String weight) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  await prefs.setString('name', name);
  await prefs.setString('age', age);
  await prefs.setString('height', height);
  await prefs.setString('weight', weight);
  print("values stored in shared prefs");
}

Future<void> getDateFromSharedPref() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  globals.name = prefs.getString('name') ?? "";
  globals.age = prefs.getString('age') ?? "";
  globals.height = prefs.getString('height') ?? "";
  globals.weight = prefs.getString('weight') ?? "";
  globals.uid = prefs.getString('uid') ?? "";
}
