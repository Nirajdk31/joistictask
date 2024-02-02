import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late Future<List<Map<String, dynamic>>> fetchData;

  @override
  void initState() {
    super.initState();
    fetchData = fetchAlbumData();
  }

  Future<List<Map<String, dynamic>>> fetchAlbumData() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1/photos'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
       throw showToast('Failed to load album data');
    }
  }

   showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black,
      textColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //title: Text("Welcome ${FirebaseAuth.instance.currentUser!.displayName!}",style: TextStyle(fontSize: 19,color: Colors.white,fontWeight: FontWeight.bold),),
        backgroundColor: Colors.white,
        leading: Icon(Icons.menu),
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
                                context: context,
                                builder: (BuildContext context) {
                                  return Column(
                                    children:[
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.blue
                                        ),
                                        child: Container(
                                          height: 70,
                                          width: 50,
                                          padding: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle
                                          ),
                                          child: Image.network(
                                            item['thumbnailUrl'],
                                            width: 60,
                                            height: 140, // Adjust the height as needed
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Column(
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              topRight: Radius.circular(20),
                                            ),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                              SizedBox(height: 10),
                                              Text('ID: ${item['id']}'),
                                              Text('Title: ${item['title']}'),
                                              // Add more details as needed
                                            ],
                                          ),
                                        ),

                                      ],
                                    ),
                                    ]
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
          // InkWell(
          //   onTap: () async {
          //     showDialog(
          //         context: context,
          //         builder: (BuildContext context){
          //           return Dialog(
          //             backgroundColor: Colors.transparent,
          //             child: Container(
          //               decoration: BoxDecoration(
          //                   color: Colors.white,
          //                   borderRadius: BorderRadius.circular(10)),
          //               width: double.infinity,
          //               child: Column(
          //                 mainAxisSize: MainAxisSize.min,
          //                 children: [
          //                   Image.asset(
          //                     'assets/images/logout.jpg',
          //                     height: 120,
          //                   ),
          //                   const Padding(
          //                     padding: EdgeInsets.all(5),
          //                     child: Text(
          //                       "Comeback Soon !",
          //                       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          //                     ),
          //                   ),
          //                   const Padding(
          //                     padding: EdgeInsets.all(10),
          //                     child: Text(
          //                       "Are you sure you want to logout?",
          //                       textAlign: TextAlign.center,
          //                       style: TextStyle(fontSize: 17),
          //                     ),
          //                   ),
          //                   //SizedBox(height: 20,),
          //                   Row(
          //                     mainAxisAlignment:
          //                     MainAxisAlignment.spaceEvenly,
          //                     children: [
          //                       Expanded(
          //                         child: Container(
          //                           decoration: const BoxDecoration(
          //                               color: Colors.white,
          //                               borderRadius: BorderRadius.all(
          //                                   Radius.circular(10))),
          //                           child: TextButton(
          //                             onPressed: () async {
          //                               await GoogleSignIn().signOut();
          //                               FirebaseAuth.instance.signOut();
          //
          //                               SharedPreferences prefs = await SharedPreferences.getInstance();
          //                               prefs.setBool('isLoggedIn', false);
          //
          //                               Navigator.pop(context);
          //                             },
          //                             child: Text("Yes, logout",
          //                                 style: Theme.of(context)
          //                                     .textTheme
          //                                     .titleSmall
          //                                     ?.merge(const TextStyle(
          //                                     color: Colors.red,
          //                                     fontSize: 20))),
          //                           ),
          //                         ),
          //                       ),
          //                       Expanded(
          //                         child: Container(
          //                           decoration:  BoxDecoration(
          //                             color: Colors.red.shade400,
          //                             borderRadius: BorderRadius.only(
          //                               topLeft: Radius.circular(10),
          //                               bottomRight: Radius.circular(10),
          //                             ),
          //                           ),
          //                           child: TextButton(
          //                             onPressed: () {
          //                               Navigator.pop(context);
          //                             },
          //                             child: Text("No",
          //                                 style: Theme.of(context)
          //                                     .textTheme
          //                                     .titleMedium
          //                                     ?.merge(const TextStyle(
          //                                     color: Colors.white,
          //                                     fontSize: 20))),
          //                           ),
          //                         ),
          //                       ),
          //                     ],
          //                   )
          //
          //                   // SizedBox(
          //                   //   height: Get.height/2,
          //                   //   width: Get.width/1.2,
          //                   //
          //                   // )
          //                 ],
          //               ),
          //             ),
          //           );
          //         });
          //     },
          //   child: Container(
          //       padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          //       decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(10),
          //         border: Border.all(color: Colors.black12,width: 1),
          //         gradient: LinearGradient(
          //           colors: [Colors.blue.shade100, Colors.blue.shade50],
          //           begin: Alignment.centerLeft,
          //           end: Alignment.centerRight,
          //         ),
          //       ),
          //       child: Text("Logout",style: TextStyle(fontSize: 16,color: Colors.black),)),
          // ),
        ],
      ),
    );
  }
}

class CustomMenuClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Paint paint = Paint();
    paint.color = Colors.white;

    final width = size.width;
    final height = size.height;

    Path path = Path();
    path.moveTo(0, 0);
    path.quadraticBezierTo(0, 8, 10, 16);
    path.quadraticBezierTo(width-1, height/2-20, width, height/2);
    path.quadraticBezierTo(width+1, height/2+20, 10, height-16);
    path.quadraticBezierTo(0, height-8, 0, height);

    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }

}

