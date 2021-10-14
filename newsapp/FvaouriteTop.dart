// import 'dart:convert';
// import 'package:intl/intl.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:newsapp/Authentication/signUp.dart';
// import 'package:newsapp/Home/Categories/detail.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:uuid/uuid.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class TopStories extends StatefulWidget {
//   @override
//   _TopStoriesState createState() => _TopStoriesState();
// }

// class _TopStoriesState extends State<TopStories> {
//   final currentUser = FirebaseAuth.instance.currentUser;
//   var docId = Uuid();
//   var favouriteHeart = [];
//   getUser() async {
//     var dateTo = DateTime.now();
//     var dateFrom;
//     if (dateTo.day >= 3) {
//       dateFrom = '${dateTo.year}-${dateTo.month}-${dateTo.day - 2}';
//     } else if (dateTo.day == 2) {
//       if (dateTo.month == 1 ||
//           dateTo.month == 3 ||
//           dateTo.month == 5 ||
//           dateTo.month == 7 ||
//           dateTo.month == 10 ||
//           dateTo.month == 12) {
//         dateFrom = '${dateTo.year}-${dateTo.month - 1}-${30}';
//       } else if (dateTo.month == 2 ||
//           dateTo.month == 4 ||
//           dateTo.month == 6 ||
//           dateTo.month == 8 ||
//           dateTo.month == 9 ||
//           dateTo.month == 11) {
//         dateFrom = '${dateTo.year}-${dateTo.month - 1}-${31}';
//       }
//     } else if (dateTo.day == 1) {
//       if (dateTo.month == 1 ||
//           dateTo.month == 3 ||
//           dateTo.month == 5 ||
//           dateTo.month == 7 ||
//           dateTo.month == 10 ||
//           dateTo.month == 12) {
//         dateFrom = '${dateTo.year}-${dateTo.month - 1}-${29}';
//       } else if (dateTo.month == 2 ||
//           dateTo.month == 4 ||
//           dateTo.month == 6 ||
//           dateTo.month == 8 ||
//           dateTo.month == 9 ||
//           dateTo.month == 11) {
//         dateFrom = '${dateTo.year}-${dateTo.month - 1}-${30}';
//       }
//     }

//     var db = FirebaseFirestore.instance;
//     var response = await http.get(Uri.parse(
//         'https://newsapi.org/v2/everything?qInTitle=stories&from=$dateFrom&sortBy=top&pageSize=30&apiKey=2d994719819c49a483538246c73c74ab'));
//     final body = json.decode(response.body);
//     List data = body['articles'];
//     if (FirebaseAuth.instance.currentUser != null) {
//       var favouriteCheck = await db
//           .collection('Users')
//           .doc('${FirebaseAuth.instance.currentUser!.uid}')
//           .collection('Favourite')
//           .get()
//           .then((querySnapshot) =>
//               querySnapshot.docs.map((e) => e['articles']).toList());
//       for (var i = 0; i < data.length; i++) {
//         data[i]['fav'] = 'off';
//         for (var fI = 0; fI < favouriteCheck.length; fI++) {
//           if (favouriteCheck[fI]['title'] == data[i]['title']) {
//             data[i] = favouriteCheck[fI];
//           }
//         }
//         favouriteHeart = [...favouriteHeart, data[i]['fav']];
//       }
//     }
//     return data;
//   }

//   favouriteAdd(item, index) async {
//     var id = docId.v4();
//     FirebaseFirestore firestore = FirebaseFirestore.instance;
//     try {
//       item['id'] = id;
//       item['fav'] = 'on';
//       await firestore
//           .collection('Users')
//           .doc('${FirebaseAuth.instance.currentUser!.uid}')
//           .collection('Favourite')
//           .doc('$id')
//           .set({'articles': item});
//       setState(() {
//         favouriteHeart[index] = 'on';
//       });
//     } catch (e) {
//       print(e);
//     }
//   }

//   favouriteRemove(item, index) async {
//     FirebaseFirestore firestore = FirebaseFirestore.instance;
//     try {
//       await firestore
//           .collection('Users')
//           .doc('${FirebaseAuth.instance.currentUser!.uid}')
//           .collection('Favourite')
//           .doc('${item['id']}')
//           .delete();
//       setState(() {
//         favouriteHeart[index] = 'off';
//       });
//     } catch (e) {
//       print(e);
//     }
//   }

//   Widget testing(context, item, index) {
//     var width = MediaQuery.of(context).size.width;
//     var height = MediaQuery.of(context).size.height;
//     var datebaseTime = DateTime.parse(item['publishedAt']);
//     final dateString = DateFormat('dd-MM-yyyy h:mma').format(datebaseTime);
//     final datemonth = DateFormat('dd-MM-yyyy').format(datebaseTime);
//     DateTime notificationDate =
//         DateFormat("dd-MM-yyyy h:mma").parse(dateString);
//     final date2 = DateTime.now();
//     final difference = date2.difference(notificationDate);
//     return Padding(
//       padding: EdgeInsets.only(top: height * 0.01),
//       child: Container(
//         width: width * 1,
//         height: height * 0.12,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           border: Border.all(color: Colors.black),
//         ),
//         child: Stack(
//           children: [
//             FirebaseAuth.instance.currentUser != null
//                 ? favouriteHeart[index] == 'on'
//                     ? Positioned(
//                         right: width * 0.02,
//                         bottom: height * 0.005,
//                         child: GestureDetector(
//                           onTap: () => {
//                             favouriteRemove(item, index),
//                           },
//                           child: Icon(
//                             Icons.favorite,
//                             color: Colors.red,
//                           ),
//                         ),
//                       )
//                     : Positioned(
//                         right: width * 0.02,
//                         bottom: height * 0.005,
//                         child: GestureDetector(
//                           onTap: () => {
//                             favouriteAdd(item, index),
//                           },
//                           child: Icon(
//                             Icons.favorite_border,
//                           ),
//                         ),
//                       )
//                 : Positioned(
//                     right: width * 0.02,
//                     bottom: height * 0.005,
//                     child: GestureDetector(
//                       onTap: () => {
//                         Navigator.of(context).push(
//                             MaterialPageRoute(builder: (context) => SignUp()))
//                       },
//                       child: Icon(
//                         Icons.favorite_border,
//                       ),
//                     ),
//                   ),
//             Row(
//               children: [
//                 Container(
//                   width: width * 0.4,
//                   decoration: BoxDecoration(
//                     image: DecorationImage(
//                       fit: BoxFit.cover,
//                       image: NetworkImage('${item['urlToImage']}'),
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.only(
//                     top: height * 0.01,
//                     bottom: height * 0.01,
//                     left: width * 0.01,
//                     right: width * 0.01,
//                   ),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Container(
//                         width: width * 0.57,
//                         child: Text(
//                           '${item['title']}',
//                           maxLines: 2,
//                           softWrap: true,
//                         ),
//                       ),
//                       Row(
//                         children: [
//                           difference.inDays > 8
//                               ? Text('$datemonth')
//                               : (difference.inDays / 7).floor() >= 1
//                                   ? Text('1w')
//                                   : difference.inDays >= 2
//                                       ? Text('${difference.inDays}d')
//                                       : difference.inDays >= 1
//                                           ? Text('1d')
//                                           : difference.inHours >= 1
//                                               ? Text('${difference.inHours}h')
//                                               : difference.inMinutes >= 1
//                                                   ? Text(
//                                                       '${difference.inMinutes}m')
//                                                   : difference.inSeconds >= 3
//                                                       ? Text(
//                                                           '${difference.inSeconds}s')
//                                                       : Text('Just now'),
//                           Container(
//                             height: 18,
//                             child: VerticalDivider(
//                               color: Colors.grey,
//                               width: width * 0.06,
//                               thickness: 1.3,
//                             ),
//                           ),
//                           Container(
//                             width: width * 0.35,
//                             child: Text(
//                               '${item['source']['name']}',
//                               maxLines: 1,
//                               softWrap: true,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     var width = MediaQuery.of(context).size.width;
//     var height = MediaQuery.of(context).size.height;
//     return SafeArea(
//       top: false,
//       bottom: false,
//       child: Builder(
//           builder: (context) => FutureBuilder(
//               future: getUser(),
//               builder: (context, snapshort) {
//                 if (snapshort.hasError) {
//                   return Center(child: Text('Something Went Wrong'));
//                 } else if (snapshort.hasData) {
//                   var articles = snapshort.data as List;
//                   return CustomScrollView(
//                     slivers: <Widget>[
//                       SliverOverlapInjector(
//                           handle:
//                               NestedScrollView.sliverOverlapAbsorberHandleFor(
//                                   context)),
//                       SliverPadding(
//                         padding: EdgeInsets.only(bottom: height * 0.004),
//                         sliver: SliverList(
//                             delegate: SliverChildBuilderDelegate(
//                           (context, index) {
//                             var item = articles[index];
//                             return GestureDetector(
//                                 onTap: () {
//                                   Navigator.of(context).push(MaterialPageRoute(
//                                       builder: (context) =>
//                                           Detail(item: item)));
//                                 },
//                                 child: item['urlToImage'] != null &&
//                                         item['content'] != null &&
//                                         item['author'] != null
//                                     ? testing(context, item, index)
//                                     : Container());
//                           },
//                           childCount: articles.length,
//                         )),
//                       )
//                     ],
//                   );
//                 } else {
//                   return Center(child: CircularProgressIndicator());
//                 }
//               })),
//     );
//   }
// }
