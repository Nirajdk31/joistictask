import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../controller/api_fetch_contrloller.dart';
import 'login_page.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late Future<List<Map<String, dynamic>>> fetchData;

  ApiController apiController = ApiController();

  @override
  void initState() {
    super.initState();
    fetchData = apiController.fetchAlbumData();
  }


  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () async {
                showDialog(
                    context: context,
                    builder: (BuildContext context){
                      return Dialog(
                        backgroundColor: Colors.transparent,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          width: double.infinity,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                'assets/images/logout.jpg',
                                height: 120,
                              ),
                              const Padding(
                                padding: EdgeInsets.all(5),
                                child: Text(
                                  "Comeback Soon !",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  "Are you sure you want to logout?",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 17),
                                ),
                              ),
                              //SizedBox(height: 20,),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      child: TextButton(
                                        onPressed: () async {
                                            await GoogleSignIn().signOut();
                                            await FirebaseAuth.instance.signOut();

                                            SharedPreferences prefs = await SharedPreferences.getInstance();
                                            prefs.setBool('isLoggedIn', false);

                                            Navigator.pop(context);
                                            Get.to(()=>LoginPage());

                                        },
                                        child: Text("Yes, logout",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall
                                                ?.merge(const TextStyle(
                                                color: Colors.red,
                                                fontSize: 20))),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      decoration:  BoxDecoration(
                                        color: Colors.red.shade400,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                        ),
                                      ),
                                      child: TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text("No",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium
                                                ?.merge(const TextStyle(
                                                color: Colors.white,
                                                fontSize: 20))),
                                      ),
                                    ),
                                  ),
                                ],
                              )

                            ],
                          ),
                        ),
                      );
                    });
              },
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black12,width: 1),
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade100, Colors.blue.shade50],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                  child: Text("Logout",style: TextStyle(fontSize: 16,color: Colors.black),)),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        //title: Text("Welcome ${FirebaseAuth.instance.currentUser!.displayName!}",style: TextStyle(fontSize: 19,color: Colors.white,fontWeight: FontWeight.bold),),
        backgroundColor: Colors.white,
        leading: InkWell(
          onTap: (){
            _scaffoldKey.currentState!.openDrawer();
          },
            child: Icon(Icons.menu)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Icon(Icons.search_rounded),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: const Text("Find your Dream\nJob today", style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),),
          ),
          Expanded(
            child: FutureBuilder(
              future: fetchData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  List<Map<String, dynamic>> data = snapshot.data as List<Map<String, dynamic>>;

                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      Map<String, dynamic> item = data[index];

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 15,horizontal: 5),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12.withOpacity(0.1), // Color of the shadow
                                spreadRadius: 5, // Spread radius
                                blurRadius: 7, // Blur radius
                                offset: Offset(0, 2), // Changes position of shadow
                              ),
                            ],
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          child: ListTile(
                            leading: ClipOval(
                              child: Image.network(
                                  item['thumbnailUrl'],
                                  width: 60, // Adjust the width as needed
                                  height: 140, // Adjust the height as needed
                                  fit: BoxFit.cover,
                              ),
                            ),
                            title: Text(item['title'].split(' ').take(2).join(' '),maxLines: 1,),
                            subtitle: Text(item['title'],maxLines: 1,),
                            trailing: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle
                              ),
                                child: Icon(Icons.shopping_bag_rounded,color: Colors.white,)),
                            onTap: () {
                              showModalBottomSheet(
                                backgroundColor: Colors.transparent,
                                context: context,
                                builder: (BuildContext context) {
                                  return Stack(
                                    children: [
                                      Container(
                                        color: Colors.transparent,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SizedBox(height: 50,),
                                            Expanded(
                                              child: Container(
                                                width: double.maxFinite,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.only(
                                                      topLeft: Radius.circular(20),
                                                      topRight: Radius.circular(20)),
                                                ),
                                                child: SingleChildScrollView(
                                                  child: Padding(
                                                    padding: EdgeInsets.all(10),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        SizedBox(
                                                          height: 60,
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.only(left: 25, right: 25),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(item['title'].split(' ').take(2).join(' '),maxLines: 1, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                                                              SizedBox(height: 5,),
                                                              Text('Ney york', style: TextStyle(fontSize: 14, color: Colors.black45),),
                                                              SizedBox(height: 5,),
                                                              Text('Tech based company and the producer', style: TextStyle(fontSize: 14, color: Colors.black45, fontWeight: FontWeight.bold),),
                                                              SizedBox(height: 30,),
                                                              Text('Position', style: TextStyle(fontSize: 14, color: Colors.black45),),
                                                              SizedBox(height: 2,),
                                                              Text('Senior UI/UX Designer', style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),),
                                                              SizedBox(height: 30,),
                                                              Text('Description', style: TextStyle(fontSize: 14, color: Colors.black45),),
                                                              SizedBox(height: 4,),
                                                              Text('A UI/UX designer is a professional responsible for creating the user interface (UI) and user experience (UX) of digital products, such as websites, mobile applications, and software. Their role is crucial in ensuring that the product is visually appealing, easy to use, and provides a positive overall experience for the end-users.',
                                                                style: TextStyle(fontSize: 18, color: Colors.black54, fontWeight: FontWeight.bold),),
                                                              SizedBox(height: 10,),
                                                              InkWell(
                                                                onTap: (){
                                                                  final scaffold = ScaffoldMessenger.of(context);
                                                                  scaffold.removeCurrentSnackBar();
                                                                  scaffold.showSnackBar(
                                                                    SnackBar(
                                                                      content: Text('Applied Successfully'),
                                                                    ),
                                                                  );
                                                                  Navigator.pop(context);
                                                                },
                                                                child: Container(
                                                                  width: double.infinity,
                                                                  height: 50,
                                                                  decoration: BoxDecoration(
                                                                      boxShadow: [
                                                                        BoxShadow(
                                                                          color: Colors.blue.withOpacity(0.5),
                                                                          spreadRadius: 5,
                                                                          blurRadius: 7,
                                                                          offset: Offset(0, 3), // changes position of shadow
                                                                        ),
                                                                      ],
                                                                    color: Colors.blue,
                                                                    borderRadius: BorderRadius.all(Radius.circular(8))
                                                                  ),
                                                                  child: Center(child: Text("Apply Now", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 20),)),
                                                                ),
                                                              ),
                                                              SizedBox(height: 20,),
                                                            ],
                                                          ),
                                                        ),

                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Positioned(
                                        top: 12,
                                        left: 30,
                                        child: CircleAvatar(
                                          backgroundColor: Colors.white,
                                          radius: 50,
                                          child: ClipOval(
                                            child: Image.network(
                                              item['thumbnailUrl'],
                                              width: 80, // Adjust the width as needed
                                              height: 80,// Adjust the height as needed
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}



