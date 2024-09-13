import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
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
              Navigator.of(context).pushReplacement(
                  CupertinoPageRoute(builder: (context) => MainScreen()));
            }
          },
          child: Icon(Icons.arrow_forward_ios),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(
              color: Colors.transparent,
              height: 80,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "New To Do",
                style: TextStyle(fontSize: 35),
              ),
            ),
            const Divider(
              color: Colors.transparent,
              height: 70,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                autofocus: false,
                controller: titleController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    labelText: "Title"),
              ),
            ),
            const Divider(
              color: Colors.transparent,
              height: 17,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                autofocus: false,
                controller: descriptionController,
                maxLines: 7,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    labelText: "Description"),
              ),
            ),
            const Divider(
              color: Colors.transparent,
              height: 70,
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
            const Divider(
              color: Colors.transparent,
              height: 35,
            ),
            Center(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey.shade800,
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
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
