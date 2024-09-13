import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';

class ToDoModel {
  String name;
  String description;
  Color color;
  ToDoModel({required this.name,required this.description,required this.color,});
}
