import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:habittracker/main.dart';
import 'package:habittracker/screens/edittodo.dart';
import 'package:habittracker/screens/loadingscreen.dart';
import 'package:habittracker/screens/loginscreen.dart';
import 'package:habittracker/screens/signupscreen.dart';

import '../data/model.dart';
import 'newtodo.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int navBarIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: navBarIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                // Add new To Do
                Navigator.of(context).push(
                    CupertinoPageRoute(builder: (context) => const NewToDo()));
              },
              child: const Icon(Icons.add),
            )
          : null,
      appBar: AppBar(
        title: const Text("To Do List"),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(splashFactory: NoSplash.splashFactory),
        child: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.checklist), label: "To Do"),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: "Settings")
          ],
          currentIndex: navBarIndex,
          onTap: (change) {
            setState(() {
              navBarIndex = change;
            });
          },
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey.shade600,
          showSelectedLabels: true,
          showUnselectedLabels: true,
        ),
      ),
      body: selectBody(navBarIndex),
    );
  }

  Widget selectBody(int navBarIndex) {

    return navBarIndex == 0
        ? ReorderableListView.builder(
            itemBuilder: (context,index){
              return Dismissible(
                key: ValueKey(modelList[index]),
  onDismissed: (direction){
    showDeletedSnackBar(todo: modelList[index]);
    modelList.removeAt(index);
    firestore
        .collection("users")
        .doc(savedID)
        .update({"todo": modelsToList()});
    setState(() {});
  },
                child: Padding(
                  padding: const EdgeInsets.all(12.0).w,
                  child: Card(
                    child: ListTile(
                      onTap: () {
                        Navigator.of(context).push(CupertinoPageRoute(
                            builder: (context) => EditToDo(
                              title: modelList[index].name,
                              description: modelList[index].description,
                              color: modelList[index].color,
                              index: index,
                            )));
                      },
                      title: Center(child: Text(modelList[index].name)),
                      subtitle: modelList[index].description != ""
                          ? Center(child: Text(modelList[index].description))
                          : null,
                      leading: CircleAvatar(
                        backgroundColor: modelList[index].color,
                      ),
                      tileColor: Colors.grey.shade800,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12).w),
                    ),
                  ),
                ),
              );
            },
            itemCount: modelList.length,
            onReorder: (oldIndex,newIndex)async{
              ToDoModel movingModel = modelList[oldIndex];
              if(newIndex > oldIndex){
                newIndex--;
              }
              modelList.removeAt(oldIndex);
              modelList.insert(newIndex, movingModel);
              await firestore
                  .collection("users")
                  .doc(savedID)
                  .update({"todo": modelsToList()});

            })
        : Column(
            children: [
              Divider(
                color: Colors.transparent,
                height: 51.5.h,
              ),
              Center(
                child: CircleAvatar(
                  radius: 50.r,
                  backgroundImage: const AssetImage("images/avatar.png"),
                ),
              ),
              Divider(
                color: Colors.transparent,
                height: 27.h,
              ),
              GestureDetector(
                  onTap: () {
                    //copy ID
                    Clipboard.setData(ClipboardData(text: savedID)).then((_) {
                      showAccountCreationSnackBar(context: context);
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0).w,
                        child: Text(
                          savedID,
                          style: TextStyle(fontSize: 17.sp),
                        ),
                      ),
                      Icon(Icons.copy)
                    ],
                  )),
              Divider(
                color: Colors.transparent,
                height: 27.h,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0).w,
                child: ListTile(
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: deleteAllToDos,
                  leading: const Text("Delete All To Do's"),
                  tileColor: const Color(4282532418),
                  shape: const StadiumBorder(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0).w,
                child: ListTile(
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: signOut,
                  leading: const Text("Sign Out"),
                  tileColor: const Color(4282532418),
                  shape: const StadiumBorder(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0).w,
                child: ListTile(
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: deleteAccount,
                  leading: const Text("Delete Account"),
                  tileColor: const Color(4282532418),
                  shape: const StadiumBorder(),
                ),
              )
            ],
          );
  }

  void deleteAllToDos() {
    modelList = [];
    firestore.collection("users").doc(savedID).update({"todo": {}});
    showSnackBarWithText(text: "All To Do's deleted", context: context);
  }

  void signOut() {
    savedID = "";
    pref!.setString("id", "");
    Navigator.of(context).pushAndRemoveUntil(
        CupertinoPageRoute(builder: (context) => const MyApp()),
        (context) => false);
  }

  void deleteAccount() {
    firestore.collection("users").doc(savedID).delete();
    showSnackBarWithText(text: "Account Deleted ", context: context);
    Navigator.of(context).pushAndRemoveUntil(
        CupertinoPageRoute(builder: (context) => const LoginScreen()),
        (context) => false);
  }

  void showDeletedSnackBar({required ToDoModel todo}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      shape: StadiumBorder(),
      action: SnackBarAction(
          label: "Undo",
          onPressed: () {
            modelList.add(todo);
            firestore
                .collection("users")
                .doc(savedID)
                .update({"todo": modelsToList()});
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            setState(() {});
          }),
      content: Text("Deleted To Do succesfully!"),
    ));
  }
}

Map modelsToList() {
  Map newList = {};
  for (int i = 0; i < modelList.length; i++) {
    newList.addEntries([
      MapEntry(i.toString(), [
        modelList[i].name,
        modelList[i].description,
        modelList[i].color.value
      ])
    ]);
    print(newList.toString());
  }
  return newList;
}

void showSnackBarWithText(
    {required String text, required BuildContext context}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    padding: const EdgeInsets.all(16).w,
    content: Text(text),
    shape: const StadiumBorder(),
  ));
}
