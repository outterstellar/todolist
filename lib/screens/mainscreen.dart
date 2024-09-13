import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habittracker/main.dart';
import 'package:habittracker/screens/loadingscreen.dart';

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
      floatingActionButton: navBarIndex == 0 ? FloatingActionButton(
        onPressed: () {
          // Add new To Do
          Navigator.of(context)
              .push(CupertinoPageRoute(builder: (context) => NewToDo()));
        },
        child: Icon(Icons.add),
      ): null,
      appBar: AppBar(
        title: Text("To Do List"),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(splashFactory: NoSplash.splashFactory),
        child: BottomNavigationBar(
          items: [
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
        ? ListView.builder(
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: Dismissible(
                  key: UniqueKey(),
                  onDismissed: (direction) {
                    modelList.removeAt(index);
                    firestore
                        .collection("users")
                        .doc(savedID)
                        .update({"todo": modelsToList()});
                    setState(() {});
                  },
                  child: Card(
                    child: ListTile(
                      title: Center(child: Text(modelList[index].name)),
                      subtitle: modelList[index].description != ""
                          ? Center(child: Text(modelList[index].description))
                          : null,
                      leading: CircleAvatar(
                        backgroundColor: modelList[index].color,
                      ),
                      tileColor: Colors.grey.shade800,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              );
            },
            itemCount: modelList.length,
          )
        : Placeholder();
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
