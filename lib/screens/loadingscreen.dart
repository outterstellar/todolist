import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:habittracker/data/model.dart';
import 'package:habittracker/main.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'mainscreen.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

Map userData = {};
List<ToDoModel> modelList = [];

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserToDo().then((docSnap) {
      userData = (docSnap.data() as Map<String, dynamic>);
      modelList = mapToModel(map: userData);
      if (modelList != []) {
        print("Mr. Frodo, we found the list\n ${modelList.toString()}");
        Navigator.of(context).pushAndRemoveUntil(
            CupertinoPageRoute(
                builder: (context) => MainScreen()),
                (context) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: SizedBox(
                height: 75.w,
                width: 75.w,
                child: LoadingAnimationWidget.staggeredDotsWave(
                    color: Colors.white, size: 75.w))));
  }
}

Future<DocumentSnapshot> getUserToDo() async {
  return firestore.collection("users").doc(savedID).get();
}

List<ToDoModel> mapToModel({required Map map}) {
  List<ToDoModel> list = [];
  print(map.toString());
  for (int i = 0; i < map["todo"].length; i++) {
    list.add(
      ToDoModel(
          name: map["todo"][i.toString()][0],
          description: map["todo"][i.toString()][1],
          color: stringToColor(map["todo"][i.toString()][2]),)
    );
  }
  return list;
}

Color stringToColor(int colorInt) {
  return Color(colorInt);
}
