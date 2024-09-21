import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:habittracker/main.dart';
import 'package:habittracker/screens/loadingscreen.dart';
import 'package:habittracker/screens/signupscreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}
//xsIVfaeLTlUpnypZxIE6 test account
// designSize 412 915
class _LoginScreenState extends State<LoginScreen> {
  String descriptionAboutIDs =
      "If you used this app before, you can write your id and login to your account. Or you can create a new account. You should save the code while creating a new account. If you lose it, you can't use your account no more. ";
  String errorIDNotFound = "There aren't any account that has this id. If you forgot your ID, you can create a new one. Don't forget that internet connection may cause that error too.";
  TextEditingController idController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            checkIdAvailibility(id: idController.text).then(
                (availible){
                  if(availible){
                    Navigator.of(context).pushAndRemoveUntil(
                        CupertinoPageRoute(
                            builder: (context) => LoadingScreen()),
                            (context) => false);
                  }else{
                    showInformationDialog(
                        context: context, description: errorIDNotFound);
                  }
                }
            );
          },
          child: const Icon(Icons.arrow_forward_ios_outlined),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Divider(
              color: Colors.transparent,
              height: 103.h,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0).w,
              child: Text(
                "New Type \nOf Living",
                style: TextStyle(fontSize: 35.sp),
              ),
            ),
             Divider(
              color: Colors.transparent,
              height: 103.h,
            ),
            Row(
              children: [
                Expanded(
                  flex: 6,
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(8.r, 8.r, 0, 8.r),
                      child: TextField(
                        controller: idController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20).w,
                            ),
                            label: const Text('ID')),
                      )),
                ),
                Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0).w,
                      child: IconButton(
                          onPressed: () {
                            showInformationDialog(
                                context: context,
                                description: descriptionAboutIDs);
                          },
                          icon: const Icon(Icons.question_mark_rounded)),
                    )),
              ],
            ),
            Divider(
              color: Colors.transparent,
              height: 51.5.h,
            ),
            Center(
              child: TextButton(
                  onPressed: () {
                    Navigator.of(context).push(CupertinoPageRoute(
                        builder: (context) => SignUpScreen()));
                  },
                  child: Text("I don't have an account")),
            ),
          ],
        ),
      ),
    );
  }
}

Future<bool> checkIdAvailibility({required String id}) async{
  DocumentSnapshot docSnap =await firestore.collection("users").doc(id).get();
  if(docSnap.exists){
    pref!.setString("id", id);
    savedID = id;
    return true;
  }else{
    return false;
  }

}

void showInformationDialog(
    {required BuildContext context, required String description}) {
  showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(description),
          actions: [
            CupertinoButton(
                child: Text("Okay"),
                onPressed: () {
                  Navigator.of(context).pop();
                })
          ],
        );
      });
}
