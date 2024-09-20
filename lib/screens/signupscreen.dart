import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:habittracker/main.dart';
import 'package:habittracker/screens/loginscreen.dart';
import 'package:habittracker/screens/loadingscreen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool acceptedTerms = false;
  String accountSystemDescription =
      "By generating a new account, you are accepting our privacy policy. You should save the ID that we will generate for you. If you forget it, you can't use your account and lose your all data. If you already have an account, you can use your account. By the way, you can continue to your saved habits.";
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(),
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (!acceptedTerms) {
            showInformationDialog(
                context: context,
                description: "Please accept our terms firstly.");
          } else {
            createAccount().then((id) {
              if (id != "") {
                showAccountCreationDialog(context: context, id: id);
              } else {
                showInformationDialog(
                    context: context,
                    description:
                        "An Error Occurred, Please Check Your Internet Connectivity and try again later");
              }
            });
          }
        },
        child: const Icon(Icons.arrow_forward_ios_outlined),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(
            color: Colors.transparent,
            height: 27.h,
          ),
           Padding(
            padding: const EdgeInsets.all(20.0).w,
            child: Text(
              "A Huge Step To\nThe New Life",
              style: TextStyle(fontSize: 35.sp),
            ),
          ),
          Divider(
            color: Colors.transparent,
            height: 70.h,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0).w,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey.shade800,
                  borderRadius: BorderRadius.circular(12).w),
              child: Padding(
                padding: const EdgeInsets.all(16.0).w,
                child: Text(
                  accountSystemDescription,
                  style:  TextStyle(fontSize: 18.sp),
                ),
              ),
            ),
          ),
          Divider(
            color: Colors.transparent,
            height: 51.5.h,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                  flex: 1,
                  child: Checkbox(
                      value: acceptedTerms,
                      onChanged: (newValue) {
                        setState(() {
                          acceptedTerms = newValue!;
                        });
                      })),
              Expanded(
                flex: 3,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      acceptedTerms = !acceptedTerms;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0).w,
                    child: Text(
                      "I accept those Terms",
                      style:  TextStyle(fontSize: 18.sp),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    ));
  }
}

Future<String> createAccount() async {
  String id = createNewID();
  debugPrint("Mr. Frodo, We found the ID of Sauron:\n$id");
  //await pref!.setString("id", id);
  return id;
}

showAccountCreationDialog({required BuildContext context, required String id}) {
  showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
            title: Text("Your Account Created Succesfully."),
            content: Column(
              children: [
                Text("Your Id Is"),
                GestureDetector(
                    onTap: () {
                      //copy ID
                      Clipboard.setData(ClipboardData(text: id)).then((_) {
                        showAccountCreationSnackBar(context: context);
                      });
                    },
                    child: Row(
                      children: [
                        Expanded(
                          flex: 19,
                          child: Text(
                            id,
                            style: TextStyle(fontSize: 17.sp),
                          ),
                        ),
                        Expanded(flex: 1, child: Icon(Icons.copy))
                      ],
                    )),
              ],
            ),
            actions: [
              CupertinoButton(
                  child: Text("Okay"),
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        CupertinoPageRoute(
                            builder: (context) => LoadingScreen()),
                        (context) => false);
                  })
            ],
          ));
}

void showAccountCreationSnackBar({required BuildContext context}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: const Text(
      "ID copied to clipboard",
      style: TextStyle(color: Colors.white),
    ),
    shape: const StadiumBorder(),
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.grey.shade800,
  ));
}

String createNewID() {
  bool error = false;
  String id = firestore.collection("users").doc().id;
  firestore
      .collection("users")
      .doc(id)
      .set({"todo": {}})
      .then((a) {})
      .catchError((a) {
        print("We Have A Problem Mr. Frodo " + a.toString());
        error = true;
      });
  savedID = id;
  pref!.setString("id", id);
  return error ? "" : id;
}
