import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:joistic_task/controller/auth_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';


class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {

    AuthController authController = AuthController();

    return  Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.blue.shade300,
          title: Text("Login Page",style: TextStyle(fontSize: 19,color: Colors.white,fontWeight: FontWeight.bold),),
          centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // SizedBox(height: 100,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50,vertical: 5),
            child: InkWell(
              onTap: authController.signInWithGoogle,
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black12,width: 1),
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade100, Colors.blue.shade50],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 10,),
                    Image.asset("assets/images/googleiconn.png",height: 20,),
                    SizedBox(width: 50,),
                    Text("Signin with google",style: TextStyle(fontSize: 16,color: Colors.black),),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }


  // signInWithGoogle() async {
  //
  //   GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  //
  //   if (googleUser == null) {
  //     return; // User canceled the sign-in
  //   }
  //
  //   GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
  //
  //   AuthCredential credential = GoogleAuthProvider.credential(
  //     accessToken: googleAuth?.accessToken,
  //     idToken: googleAuth?.idToken
  //   );
  //
  //   UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
  //   print(userCredential.user?.displayName);
  //
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setBool('isLoggedIn', true);
  //
  //   Get.offAll(() => HomePage());
  // }

}
