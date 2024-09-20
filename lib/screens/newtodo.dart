import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:habittracker/data/model.dart';
import 'package:habittracker/main.dart';
import 'package:habittracker/screens/loadingscreen.dart';
import 'package:habittracker/screens/loginscreen.dart';
import 'package:habittracker/screens/mainscreen.dart';

class NewToDo extends StatefulWidget {
  const NewToDo({super.key});

  @override
  State<NewToDo> createState() => _NewToDoState();
}

class _NewToDoState extends State<NewToDo> {
  Color color = Colors.white;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (titleController.text == "") {
              showInformationDialog(
                  context: context, description: "Please Write A Title");
            } else {
              modelList.add(ToDoModel(
                  name: titleController.text,
                  description: descriptionController.text,
                  color: color));
              firestore
                  .collection("users")
                  .doc(savedID)
                  .update({"todo": modelsToList()});
              Navigator.of(context).pushAndRemoveUntil(
                  CupertinoPageRoute(builder: (context) => MainScreen()),
                  (context) => false);
            }
          },
          child: Icon(Icons.arrow_forward_ios),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(
              color: Colors.transparent,
              height: 80.h,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0).w,
              child: Text(
                "New To Do",
                style: TextStyle(fontSize: 35.sp),
              ),
            ),
            Divider(
              color: Colors.transparent,
              height: 70.h,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0).w,
              child: TextField(
                keyboardType: TextInputType.text,
                autofocus: false,
                controller: titleController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20).w,
                    ),
                    labelText: "Title"),
              ),
            ),
            Divider(
              color: Colors.transparent,
              height: 17.h,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0).w,
              child: TextField(
                keyboardType: TextInputType.text,
                autofocus: false,
                controller: descriptionController,
                maxLines: 7,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20).w,
                    ),
                    labelText: "Description"),
              ),
            ),
             Divider(
              color: Colors.transparent,
              height: 70.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    onPressed: () {
                      showCupertinoDialog(
                          context: context,
                          builder: (context) => CupertinoAlertDialog(
                                content: BlockPicker(
                                    pickerColor: color,
                                    onColorChanged: (changedColor) {
                                      color = changedColor;
                                      //print(color.toHexString());
                                      setState(() {});
                                    }),
                                actions: [
                                  CupertinoButton(
                                      child: Text("Okay"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      })
                                ],
                                title: Text("Select A Color"),
                              ));
                    },
                    child: Text("Select A Color")),
                CircleAvatar(backgroundColor: color)
              ],
            ),
            Divider(
              color: Colors.transparent,
              height: 35.h,
            ),
            Center(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey.shade800,
                    borderRadius: BorderRadius.circular(12).w),
                child: Padding(
                  padding: const EdgeInsets.all(8.0).w,
                  child: Text("You must add a title to create a new to do"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
