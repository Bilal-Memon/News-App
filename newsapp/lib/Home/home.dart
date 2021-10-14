// import 'dart:convert';
// import 'dart:js';
// import 'package:intl/intl.dart';
// import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:newsapp/Authentication/signUp.dart';
import 'package:newsapp/Home/Categories/TopStories.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:newsapp/Home/Categories/headLines.dart';
import 'package:newsapp/Home/Categories/popularNews.dart';
import 'package:newsapp/Home/Categories/sportsNews.dart';
import 'package:newsapp/Home/Search/search.dart';
import 'package:newsapp/Home/favourite.dart';
import 'package:newsapp/Home/profile.dart';
// import 'Categories/detail.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var user = FirebaseAuth.instance.currentUser;
    // print(user.)
    return DefaultTabController(
        length: 4,
        child: Scaffold(
            // backgroundColor: Colors.blue[300],
            body: NestedScrollView(
          floatHeaderSlivers:
              true, //finger on the screen the appbar was not scroll down
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverAppBar(
                  pinned: true, //only title scroll up
                  floating: true, //scroll up
                  snap: true, //fast scroll down
                  backgroundColor: Colors.blue[300],
                  automaticallyImplyLeading: false,
                  // forceElevated:
                  //     innerBoxIsScrolled, //app bar same colour and when scroll the shadow appear under the app bar

                  title: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            print('News App');
                          },
                          child: Text(
                            'News App',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Search()));
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.35,
                            height: height * 0.06,
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              border: Border.all(color: Colors.grey),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                            ),
                            padding: EdgeInsets.only(
                              left: width * 0.01,
                              right: width * 0.01,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Anything....',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black),
                                ),
                                Icon(
                                  Icons.search,
                                  color: Colors.black,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                            onTap: () {
                              user != null
                                  ? Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) => Favourite()))
                                  : Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) => SignUp()));
                            },
                            child: Icon(
                              Icons.favorite,
                              color: Colors.white,
                              size: 28,
                            )),
                        user != null
                            ? GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => Profile()));
                                },
                                child: Container(
                                  height: height * 0.07,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.blue[300],
                                    backgroundImage:
                                        NetworkImage('${user.photoURL}'),
                                    radius: 25,
                                  ),
                                ),
                              )
                            : Container(
                                child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SignUp()));
                                },
                                child: Text(
                                  'Sign Up',
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold),
                                ),
                                style: ButtonStyle(
                                    padding:
                                        MaterialStateProperty.all<EdgeInsets>(
                                            EdgeInsets.only(
                                      left: width * 0.01,
                                      right: width * 0.01,
                                      top: height * 0.01,
                                      bottom: height * 0.01,
                                    )),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.white)),
                              ))
                      ],
                    ),
                  ),
                  bottom: TabBar(
                    isScrollable: true,
                    unselectedLabelColor: Colors.white60,
                    labelColor: Colors.white,
                    indicatorColor: Colors.white,
                    tabs: [
                      Tab(child: Text('Top Stories')),
                      Tab(child: Text('Head Lines')),
                      Tab(child: Text('Popular News')),
                      Tab(child: Text('Sports News')),
                    ],
                  )),
            )
          ],
          body: TabBarView(
            children: [TopStories(), HeadLines(), PopularNews(), SportsNews()],
          ),
        ))
        // )
        );
  }
}