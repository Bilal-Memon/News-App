import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:newsapp/Home/Categories/detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class TopStories extends StatefulWidget {
  @override
  _TopStoriesState createState() => _TopStoriesState();
}

class _TopStoriesState extends State<TopStories> {
  var docId = Uuid();
  var testFavourite = [];
  var favouriteHeart = [];
  getUser() async {
    var dateTo = DateTime.now();
    var dateFrom;
    if (dateTo.day >= 3) {
      dateFrom = '${dateTo.year}-${dateTo.month}-${dateTo.day - 2}';
    } else if (dateTo.day == 2) {
      if (dateTo.month == 1 ||
          dateTo.month == 3 ||
          dateTo.month == 5 ||
          dateTo.month == 7 ||
          dateTo.month == 10 ||
          dateTo.month == 12) {
        dateFrom = '${dateTo.year}-${dateTo.month - 1}-${30}';
      } else if (dateTo.month == 2 ||
          dateTo.month == 4 ||
          dateTo.month == 6 ||
          dateTo.month == 8 ||
          dateTo.month == 9 ||
          dateTo.month == 11) {
        dateFrom = '${dateTo.year}-${dateTo.month - 1}-${31}';
      }
    } else if (dateTo.day == 1) {
      if (dateTo.month == 1 ||
          dateTo.month == 3 ||
          dateTo.month == 5 ||
          dateTo.month == 7 ||
          dateTo.month == 10 ||
          dateTo.month == 12) {
        dateFrom = '${dateTo.year}-${dateTo.month - 1}-${29}';
      } else if (dateTo.month == 2 ||
          dateTo.month == 4 ||
          dateTo.month == 6 ||
          dateTo.month == 8 ||
          dateTo.month == 9 ||
          dateTo.month == 11) {
        dateFrom = '${dateTo.year}-${dateTo.month - 1}-${30}';
      }
    }

    var db = FirebaseFirestore.instance;
    var add = await db.collection('Add').get().then((querySnapshot) =>
        querySnapshot.docs.map((e) => e['articles']).toList());
    var favourite = await db.collection('Favourite').get().then(
        (querySnapshot) =>
            querySnapshot.docs.map((e) => e['articles']).toList());
    var favouriteCheck = await db
        .collection('Users')
        .doc('1092a8e8-fd2f-4b64-abfb-2a0fde7a4562')
        .collection('Favourite')
        .get()
        .then((querySnapshot) =>
            querySnapshot.docs.map((e) => e['articles']).toList());
    for (var i = 0; i < favourite.length; i++) {
      favourite[i]['fav'] = 'off';
      for (var aI = 0; aI < favouriteCheck.length; aI++) {
        if (favouriteCheck[aI]['title'] == favourite[i]['title']) {
          favourite[i] = favouriteCheck[aI];
        }
      }
      testFavourite = [...testFavourite, favourite[i]['fav']];
    }
    // for (var i = 0; i < favourite.length; i++) {
    //   favourite[i]['fav'] = 'off';
    //   for (var aI = 0; aI < add.length; aI++) {
    //     if (add[aI]['title'] == favourite[i]['title']) {
    //       favourite[i] = add[aI];
    //     }
    //   }
    //   testFavourite = [...testFavourite, favourite[i]['fav']];
    // }

    return favourite;
    // for (var i = 0; i < favourite.length; i++) {
    //   if (favourite[i]['title'] == data[index]['title']) {}
    // }
// var response = await http.get(Uri.parse(
//         'https://newsapi.org/v2/everything?qInTitle=football&from=$dateFrom&sortBy=top&pageSize=30&apiKey=2d994719819c49a483538246c73c74ab'));
//     final body = json.decode(response.body);
//     List data = body['articles'];
//     for (var i = 0; i < data.length; i++) {
//       testFavourite = [...testFavourite, 'off'];
//     }
    // return data;
  }

  favouriteAdd(item) async {
    var id = docId.v4();
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      item['id'] = id;
      item['fav'] = 'on';
      await firestore
          .collection('Users')
          .doc('1092a8e8-fd2f-4b64-abfb-2a0fde7a4562')
          // .doc('$id')
          .collection('Favourite')
          .doc('$id')
          .set({'articles': item});
    } catch (e) {
      print(e);
    }
  }

  favouriteRemove(item, index) async {
    // print(item['id']);
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      // await firestore
      //     .collection('Add')
      //     .doc('1092a8e8-fd2f-4b64-abfb-2a0fde7a4562')
      //     .collection('Favourite')
      //     .doc('${item['id']}')
      //     .delete();
      print(firestore
          .collection('Add')
          .doc('1092a8e8-fd2f-4b64-abfb-2a0fde7a4562')
          .collection('Favourite')
          .doc('${item['id']}')
          .get()
          .then((value) => value));
      setState(() {
        testFavourite[index] = 'off';
      });
    } catch (e) {
      print(e);
    }
  }

  Widget testing(context, item, favourite, index) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var datebaseTime = DateTime.parse(item['publishedAt']);
    final dateString = DateFormat('dd-MM-yyyy h:mma').format(datebaseTime);
    final datemonth = DateFormat('dd-MM-yyyy').format(datebaseTime);
    DateTime notificationDate =
        DateFormat("dd-MM-yyyy h:mma").parse(dateString);
    final date2 = DateTime.now();
    final difference = date2.difference(notificationDate);

    return Padding(
      padding: EdgeInsets.only(top: height * 0.01),
      child: Container(
        width: width * 1,
        height: height * 0.12,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black),
        ),
        child: Stack(
          children: [
            testFavourite[index] == 'on'
                ? Positioned(
                    right: width * 0.02,
                    bottom: height * 0.005,
                    child: GestureDetector(
                      onTap: () => {
                        favouriteRemove(item, index),
                      },
                      child: Icon(
                        Icons.favorite,
                        color: Colors.red,
                      ),
                    ),
                  )
                : Positioned(
                    right: width * 0.02,
                    bottom: height * 0.005,
                    child: GestureDetector(
                      onTap: () => {
                        favouriteAdd(item),
                        setState(() {
                          testFavourite[index] = 'on';
                        }),
                      },
                      child: Icon(
                        Icons.favorite_border,
                        // color: Colors.grey,
                      ),
                    ),
                  ),
            Row(
              children: [
                Container(
                  width: width * 0.4,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage('${item['urlToImage']}'),
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
                          '${item['title']}',
                          maxLines: 2,
                          softWrap: true,
                        ),
                      ),
                      Row(
                        children: [
                          difference.inDays > 8
                              ? Text('$datemonth')
                              : (difference.inDays / 7).floor() >= 1
                                  ? Text('1w')
                                  : difference.inDays >= 2
                                      ? Text('${difference.inDays}d')
                                      : difference.inDays >= 1
                                          ? Text('1d')
                                          : difference.inHours >= 1
                                              ? Text('${difference.inHours}h')
                                              : difference.inMinutes >= 1
                                                  ? Text(
                                                      '${difference.inMinutes}m')
                                                  : difference.inSeconds >= 3
                                                      ? Text(
                                                          '${difference.inSeconds}s')
                                                      : Text('Just now'),
                          Container(
                            height: 18,
                            child: VerticalDivider(
                              color: Colors.grey,
                              width: width * 0.06,
                              thickness: 1.3,
                            ),
                          ),
                          Container(
                            width: width * 0.35,
                            child: Text(
                              '${item['source']['name']}',
                              maxLines: 1,
                              softWrap: true,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return SafeArea(
      top: false,
      bottom: false,
      child: Builder(
          builder: (context) => FutureBuilder(
              future: getUser(),
              builder: (context, snapshort) {
                if (snapshort.hasError) {
                  return Center(child: Text('Something Went Wrong'));
                } else if (snapshort.hasData) {
                  var articles = snapshort.data as List;
                  // var data = articles[0]['data'];
                  // var favourite = articles[0]['favourite'];
                  return CustomScrollView(
                    slivers: <Widget>[
                      SliverOverlapInjector(
                          handle:
                              NestedScrollView.sliverOverlapAbsorberHandleFor(
                                  context)),
                      SliverPadding(
                        padding: EdgeInsets.only(bottom: height * 0.004),
                        sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            var item = articles[index];
                            // var item = data[index];
                            // var fItem = data[index];
                            return GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          Detail(item: item)));
                                },
                                child: item['urlToImage'] != null &&
                                        item['content'] != null &&
                                        item['author'] != null
                                    ? testing(context, item, 'off', index)
                                    : Container());
                            // } else {
                            //   for (var i = 0; i < favourite.length; i++) {
                            //     if (favourite[i]['title'] ==
                            //         data[index]['title']) {
                            //       return GestureDetector(
                            //           onTap: () {
                            //             Navigator.of(context).push(
                            //                 MaterialPageRoute(
                            //                     builder: (context) =>
                            //                         Detail(item: dItem)));
                            //           },
                            //           child: dItem['urlToImage'] != null &&
                            //                   dItem['content'] != null &&
                            //                   dItem['author'] != null
                            //               ? testing(context, fItem, 'on', index)
                            //               : Container());
                            //     }
                            //   }

                            // return GestureDetector(
                            //     onTap: () {
                            //       Navigator.of(context).push(MaterialPageRoute(
                            //           builder: (context) =>
                            //               Detail(dItem: item)));
                            //     },
                            //     child: item['urlToImage'] != null &&
                            //             item['content'] != null &&
                            //             item['author'] != null
                            //         ? testing(context, item, 'off', index)
                            //         : Container());
                          },
                          childCount: articles.length,
                        )),
                      )
                    ],
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              })),
    );
  }
}
