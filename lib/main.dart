import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:habittracker/screens/loginscreen.dart';
import 'package:habittracker/screens/loadingscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
SharedPreferences? pref;
FirebaseFirestore firestore = FirebaseFirestore.instance;
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  pref = await SharedPreferences.getInstance();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  ScreenUtilInit(
      designSize: Size(412,915),
      builder: (child,a){
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          darkTheme: ThemeData.dark(),
          themeMode: ThemeMode.dark,
          home: selectDestination()
        );
      },
    );
  }
}
String savedID = "";
Widget selectDestination(){
  if(pref!.getBool("guest") != true && pref!.getString("id") == null){
    return LoginScreen();
  }else{
    savedID = pref!.getString("id")!;
    return LoadingScreen();
  }
} 
