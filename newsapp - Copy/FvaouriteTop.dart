// import 'dart:convert';
// import 'package:intl/intl.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:newsapp/Home/Categories/detail.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class TopStories extends StatefulWidget {
//   @override
//   _TopStoriesState createState() => _TopStoriesState();
// }

// class _TopStoriesState extends State<TopStories> {
//   var testFavourite = [];
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
//     // business
//     // var businessResponse = await http.get(Uri.parse(
//     //     'https://newsapi.org/v2/top-headlines?q=football&language=en&category=sports&pageSize=50&apiKey=2d994719819c49a483538246c73c74ab'));
//     // final businessBody = json.decode(businessResponse.body);
//     // List businessData = businessBody['articles'];

// //     //entertainment
// //     var entertainmentResponse = await http.get(Uri.parse(
// //         'https://newsapi.org/v2/top-headlines?q=Stock Market&language=en&category=entertainment&pageSize=50&apiKey=2d994719819c49a483538246c73c74ab'));
// //     final entertainmentBody = json.decode(entertainmentResponse.body);
// //     List entertainmentData = entertainmentBody['articles'];

// //     //general
// //     var generalResponse = await http.get(Uri.parse(
// //         'https://newsapi.org/v2/top-headlines?q=Stock Market&language=en&category=general&pageSize=50&apiKey=2d994719819c49a483538246c73c74ab'));
// //     final generalBody = json.decode(generalResponse.body);
// //     List generalData = generalBody['articles'];

// // //health
// //     var healthResponse = await http.get(Uri.parse(
// //         'https://newsapi.org/v2/top-headlines?q=Stock Market&language=en&category=health&pageSize=50&apiKey=2d994719819c49a483538246c73c74ab'));
// //     final healthBody = json.decode(healthResponse.body);
// //     List healthData = healthBody['articles'];

// // //science
// //     var scienceResponse = await http.get(Uri.parse(
// //         'https://newsapi.org/v2/top-headlines?q=Stock Market&language=en&category=science&pageSize=50&apiKey=2d994719819c49a483538246c73c74ab'));
// //     final scienceBody = json.decode(scienceResponse.body);
// //     List scienceData = scienceBody['articles'];

// // //sports
// //     var sportsResponse = await http.get(Uri.parse(
// //         'https://newsapi.org/v2/top-headlines?q=Stock Market&language=en&category=sports&pageSize=50&apiKey=2d994719819c49a483538246c73c74ab'));
// //     final sportsBody = json.decode(sportsResponse.body);
// //     List sportsData = sportsBody['articles'];

// // //technology
// //     var technologyResponse = await http.get(Uri.parse(
// //         'https://newsapi.org/v2/top-headlines?q=Stock Market&language=en&category=technology&pageSize=50&apiKey=2d994719819c49a483538246c73c74ab'));
// //     final technologyBody = json.decode(technologyResponse.body);
// //     List technologyData = technologyBody['articles'];
//     // if (businessData.length > entertainmentData.length &&
//     //     businessData.length > generalData.length &&
//     //     businessData.length > healthData.length &&
//     //     businessData.length > scienceData.length &&
//     //     businessData.length > sportsData.length &&
//     //     businessData.length > technologyData.length) {
//     // }
//     // var response = await http.get(Uri.parse(
//     //     'https://newsapi.org/v2/everything?qInTitle=football&from=$dateFrom&sortBy=top&pageSize=50&apiKey=2d994719819c49a483538246c73c74ab'));
//     // final body = json.decode(response.body);
//     // List Data = body['articles'];

//     // (Data.length);
//     // return Data;
//     // (entertainmentData.length);
//     // (generalData.length);
//     // (healthData.length);
//     // (scienceData.length);
//     // (sportsData.length);
//     // (technologyData.length);

//     // 'https://newsapi.org/v2/top-headlines?country=us&apiKey=2d994719819c49a483538246c73c74ab'));
//     // 'https://newsapi.org/v2/top-headlines?q=football&language=en&category=sports&pageSize=50&apiKey=2d994719819c49a483538246c73c74ab'));
//     // sports
//     //  'https://newsapi.org/v2/top-headlines?language=en&category=headlines&pageSize=50&apiKey=2d994719819c49a483538246c73c74ab'));

//     //main
//     // List favourite;
//     // print(User.articles);

//     // var response = await http.get(Uri.parse(
//     //     //     'https://newsapi.org/v2/everything?qInTitle=football&from=$dateFrom&sortBy=top&pageSize=50&apiKey=2d994719819c49a483538246c73c74ab'));
//     //     'https://newsapi.org/v2/everything?language=en&q=stories&from=$dateFrom&to=${dateTo.year}-${dateTo.month}-${dateTo.day}&pageSize=50&sortBy=top&apiKey=2d994719819c49a483538246c73c74ab'));
//     // final body = json.decode(response.body);
//     // List takingData = body['articles'];
//     var favourite = [
//       {
//         'articles': {
//           "source": {"id": null, "name": "BBC News"},
//           "author": "https://www.facebook.com/bbcnews",
//           "title":
//               "Sebastian Kurz: Austrian leader resigns amid corruption inquiry - BBC News",
//           "description":
//               "Sebastian Kurz denies allegations he used government money for party political purposes.",
//           "url": "https://www.bbc.com/news/world-europe-58856796",
//           "urlToImage":
//               "https://ichef.bbci.co.uk/news/1024/branded_news/9FB7/production/_118478804_kurz.jpg",
//           "publishedAt": "2021-10-09T18:13:27Z",
//           "content":
//               "Image source, Getty Images\r\nImage caption, Sebastian Kurz, 34, has denied wrongdoing\r\nAustrian Chancellor Sebastian Kurz has stepped down, after pressure triggered by a corruption scandal.\r\nHe has su… [+1240 chars]"
//         }
//       }
//     ];
//     // var checking = {'favouriteCheck': 'on'};
//     final CollectionReference profileList =
//         FirebaseFirestore.instance.collection('Favourite');
//     var data = await profileList.get().then((querySnapshot) =>
//         querySnapshot.docs.map((e) => e['favouriteArticles']).toList());

//     for (var i = 0; i < data.length + 1; i++) {
//       testFavourite = [...testFavourite, 'off'];
//     }

//     // var checking;
//     // for (var i = 0; i < data.length; i++) {
//     //   checking = [{
//     //     'publishedAt': data[i]['publishedAt'],
//     //     'author': data[i]['author'],
//     //     'urlToImage': data[i]['urlToImage'],
//     //     'description': data[i]['description'],
//     //     'source': {
//     //       'name': data[i]['source']['name'],
//     //       'id': data[i]['source']['id']
//     //     },
//     //     'title': data[i]['title'],
//     //     'url': data[i]['url'], 'content': data[i]['content'], 'favourite': 'off'
//     //   }];
//     // }
//     // print(data.length);

//     // // var mixData = {'data':data,'favourite': favourite};
//     // // // var mixData = {'data':data[1]['favouriteArticles'],'favourite': favourite[0]['articles']};
//     // // print();
//     return data;
//     // List mixData = [...data, favourite];
//     // print(data[0]['favouriteArticles']);
//     // print(favourite[0]['favouriteArticles']);
//     // print(data);
//     // print(favourite);
// //     for (var i = 0; i < data.length; i++) {
// //       setState(() {
// //         favouriteHeart = [...favouriteHeart, 'off'];
// //       });
// //     }
// // print(mixData['favouriteArticles']);
// // print(data.length);
//     // print(mixData[11][0]);
//     // return {data, favourite};
//     // return takingData;
//     // List mixData = [takingData, favourite];
// // print(favourite);
//     // if () {

//     // } else {
//     // }
//     // print(mixData.length);
//     // if (favourite!=null) {
//     //   return

//     // } else {
//     // }
//     // 'https://newsapi.org/v2/top-headlines?country=sa&pageSize=30&sortBy=popularity&apiKey=b07df34d71074362a01eac1014c09def'));
//     // 'https://newsapi.org/v2/everything/sources?pageSize=30&from=2021-10-05&sortBy=popularity&apiKey=b07df34d71074362a01eac1014c09def'));
//     // 'https://newsapi.org/v2/everything?q=bitcoin&from=2021-10-05&sortBy=popularity&apiKey=b07df34d71074362a01eac1014c09def'));
//     // 'https://newsapi.org/v2/top-headlines?country=sa&category=sports&apiKey=b07df34d71074362a01eac1014c09def'));
//     // (body);
//     // takingData.map((e) => e).toList();
//     // return takingData;
//   }

//   // checkingfavourite(item) {
//   //   setState(() {
//   //     // favourite = [item, ...favourite];
//   //     favourite.add(item);
//   //   });
//   //   (favourite.length);
//   //   (favourite);
//   //   //  for (var iIndex = 0; iIndex < items.length; iIndex++) {
//   //   //                 for (var i = 0; i < favourite.length; i++) {
//   //   //                   if (items[iIndex] == favourite[i]) {
//   //   //                     return favorite(context, item);
//   //   //                   } else {
//   //   //                     return testing(context, item);
//   //   //                   }
//   //   //                 }
//   //   //               }
//   // }

//   favouriteAdd(item) async {
//     FirebaseFirestore firestore = FirebaseFirestore.instance;
//     try {
//       await firestore.collection('Add').add({'favouriteArticles': item});
//     } catch (e) {
//       print(e);
//     }
//   }

//   Widget testing(context, item, favourite, index) {
//     var width = MediaQuery.of(context).size.width;
//     var height = MediaQuery.of(context).size.height;
//     // print();
//     // var time = '';
//     var datebaseTime = DateTime.parse(item['publishedAt']);
//     final dateString = DateFormat('dd-MM-yyyy h:mma').format(datebaseTime);
//     final datemonth = DateFormat('dd-MM-yyyy').format(datebaseTime);
//     // print(item);
//     // print(index);
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
//             testFavourite[index] == 'on'
//                 ? Positioned(
//                     right: width * 0.02,
//                     bottom: height * 0.005,
//                     child: GestureDetector(
//                       onTap: () => {
//                         setState(() {
//                           testFavourite[index] = 'off';
//                         })
//                       },
//                       child: Icon(
//                         Icons.favorite,
//                         color: Colors.red,
//                       ),
//                     ),
//                   )
//                 : Positioned(
//                     right: width * 0.02,
//                     bottom: height * 0.005,
//                     child: GestureDetector(
//                       onTap: () => {
//                         favouriteAdd(item),
//                         setState(() {
//                           testFavourite[index] = 'on';
//                         }),
//                       },
//                       child: Icon(
//                         Icons.favorite_border,
//                         // color: Colors.grey,
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
//                             // decoration: BoxDecoration(
//                             //     border: Border.all(color: Colors.black)),
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

//   // Widget favorite(context, item) {
//   //   var width = MediaQuery.of(context).size.width;
//   //   var height = MediaQuery.of(context).size.height;

//   //   return Padding(
//   //     padding: EdgeInsets.only(top: height * 0.01),
//   //     child: Container(
//   //       width: width * 1,
//   //       height: height * 0.12,
//   //       decoration: BoxDecoration(
//   //         color: Colors.white,
//   //         border: Border.all(color: Colors.black),
//   //       ),
//   //       child: Stack(
//   //         children: [
//   //           Positioned(
//   //             right: width * 0.02,
//   //             bottom: height * 0.005,
//   //             child: GestureDetector(
//   //               onTap: () => checkingfavourite(item),
//   //               child: Icon(
//   //                 // Icons.favorite_border,
//   //                 Icons.favorite_outlined,

//   //                 color: Colors.red,
//   //               ),
//   //             ),
//   //           ),
//   //           Row(
//   //             children: [
//   //               Container(
//   //                 width: width * 0.4,
//   //                 decoration: BoxDecoration(
//   //                   image: DecorationImage(
//   //                     fit: BoxFit.cover,
//   //                     image: NetworkImage(item['urlToImage']),
//   //                   ),
//   //                 ),
//   //               ),
//   //               Padding(
//   //                 padding: EdgeInsets.only(
//   //                   top: height * 0.01,
//   //                   bottom: height * 0.01,
//   //                   left: width * 0.01,
//   //                   right: width * 0.01,
//   //                 ),
//   //                 child: Column(
//   //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   //                   crossAxisAlignment: CrossAxisAlignment.start,
//   //                   children: [
//   //                     Container(
//   //                       width: width * 0.57,
//   //                       child: Text(
//   //                         '‘Strategy  of terror’:  116 dead as Ecuador prisons become battlegrounds for gangs - The Guardian',
//   //                         maxLines: 2,
//   //                         softWrap: true,
//   //                       ),
//   //                     ),
//   //                     Row(
//   //                       children: [
//   //                         Text('9h'),
//   //                         Container(
//   //                           height: 18,
//   //                           child: VerticalDivider(
//   //                             color: Colors.grey,
//   //                             width: width * 0.06,
//   //                             thickness: 1.3,
//   //                           ),
//   //                         ),
//   //                         Text(item['title']),
//   //                       ],
//   //                     )
//   //                   ],
//   //                 ),
//   //               ),
//   //             ],
//   //           ),
//   //         ],
//   //       ),
//   //     ),
//   //   );
//   // }

//   @override
//   Widget build(BuildContext context) {
//     var width = MediaQuery.of(context).size.width;
//     var height = MediaQuery.of(context).size.height;

//     // print(favourite);
//     return SafeArea(
//       top: false,
//       bottom: false,
//       child: Builder(
//           builder: (context) => FutureBuilder(
//               future: getUser(),
//               builder: (context, snapshort) {
//                 if (snapshort.hasError) {
//                   return Center(child: Text('Something Went Wrong'));
//                   // return Center(child: Text('${snapshort.error}'));
//                 } else if (snapshort.hasData) {
//                   var articles = snapshort.data as List;
//                   // print(snapshort.data);
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

//                             // print(articles);
//                             // print(articles[index]['articles']);
//                             // for (var i = 0; i < articles.length; i++) {
//                             //   if(articles[i]['favouriteArticles']==articles[i]['articles']){
//                             //     print('yes');
//                             //   }
//                             //   else{
//                             // print('no');}

//                             // }
//                             return GestureDetector(
//                                 onTap: () {
//                                   Navigator.of(context).push(MaterialPageRoute(
//                                       builder: (context) =>
//                                           Detail(item: item)));
//                                 },
//                                 child: item['urlToImage'] != null &&
//                                         item['content'] != null &&
//                                         item['author'] != null
//                                     ? testing(context, item, 'on', index)
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

//                 // if (favourite.length > 0) {
//                 //   for (var iIndex = 0; iIndex < items.length; iIndex++) {
//                 //     for (var i = 0; i < favourite.length; i++) {
//                 //       if (items[iIndex]==favourite[i]) {
//                 //         return favorite(context, item);
//                 //       } else {
//                 //         return testing(context, item);
//                 //       }
//                 //     }
//                 //   }
//                 // } else {
//                 // }
//                 // }
//                 // return

//                 // )
//                 // ;

//                 //  Hero(
//                 //   transitionOnUserGestures: true,
//                 //   tag: item,
//                 //   child: Material(child:
//                 // ));
//                 //   },
//               })),
//     );
//   }
// }
