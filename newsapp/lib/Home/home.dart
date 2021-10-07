import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:newsapp/Authentication/signUp.dart';
import 'package:newsapp/Home/Categories/TopStories.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:newsapp/Home/Categories/headLines.dart';
import 'package:newsapp/Home/Categories/popularNews.dart';
import 'package:newsapp/Home/Categories/sportsNews.dart';
import 'package:newsapp/Home/Search/search.dart';
import 'package:newsapp/Home/profile.dart';
import 'Categories/detail.dart';

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
                              print('favourite');
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
                                    backgroundImage:
                                        NetworkImage('${user.photoURL}'),
                                    radius: 25,
                                  ),
                                ),
                              )
                            : Container(
                                // height: height * 0.07,
                                // width: width * 0.2,
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
                                      // fontSize: 17,
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
                  //// title end
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

Widget testing(context) {
  var width = MediaQuery.of(context).size.width;
  var height = MediaQuery.of(context).size.height;

  return Padding(
    padding: EdgeInsets.only(top: height * 0.01),
    child: Container(
      width: width * 1,
      height: height * 0.12,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black),
      ),
      child: Row(
        children: [
          Container(
            width: width * 0.4,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                    'https://image.shutterstock.com/image-photo/confident-intelligence-grey-hair-senior-260nw-261010109.jpg'),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: height * 0.01,
              bottom: height * 0.01,
              left: width * 0.01,
              right: width * 0.01,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: width * 0.57,
                  child: Text(
                    '‘Strategy  of terror’:  116 dead as Ecuador prisons become battlegrounds for gangs - The Guardian',
                    maxLines: 2,
                    softWrap: true,
                  ),
                ),
                Row(
                  children: [
                    Text('9h'),
                    Container(
                      height: 18,
                      child: VerticalDivider(
                        color: Colors.grey,
                        width: width * 0.06,
                        thickness: 1.3,
                      ),
                    ),
                    Text('categories'),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
