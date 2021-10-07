import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:newsapp/Home/Categories/detail.dart';

class PopularNews extends StatefulWidget {
  @override
  _PopularNewsState createState() => _PopularNewsState();
}

class _PopularNewsState extends State<PopularNews> {
  List favourite = [];

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

    var response = await http.get(Uri.parse(
        'https://newsapi.org/v2/everything?language=en&q=news&from=$dateFrom&to=${dateTo.year}-${dateTo.month}-${dateTo.day}&pageSize=50&sortBy=popularity&apiKey=2d994719819c49a483538246c73c74ab'));
    // 'https://newsapi.org/v2/top-headlines?country=sa&pageSize=30&sortBy=popularity&apiKey=b07df34d71074362a01eac1014c09def'));
    // 'https://newsapi.org/v2/everything/sources?pageSize=30&from=2021-10-05&sortBy=popularity&apiKey=b07df34d71074362a01eac1014c09def'));
    // 'https://newsapi.org/v2/everything?q=bitcoin&from=2021-10-05&sortBy=popularity&apiKey=b07df34d71074362a01eac1014c09def'));
    // 'https://newsapi.org/v2/top-headlines?country=sa&category=sports&apiKey=b07df34d71074362a01eac1014c09def'));
    final body = json.decode(response.body);
    List takingData = body['articles'];
    // takingData.map((e) => e).toList();
    print(takingData.length);
    return takingData;
  }

  checkingfavourite(item) {
    setState(() {
      // favourite = [item, ...favourite];
      favourite.add(item);
    });
    print(favourite.length);
    print(favourite);
    //  for (var iIndex = 0; iIndex < items.length; iIndex++) {
    //                 for (var i = 0; i < favourite.length; i++) {
    //                   if (items[iIndex] == favourite[i]) {
    //                     return favorite(context, item);
    //                   } else {
    //                     return testing(context, item);
    //                   }
    //                 }
    //               }
  }

  Widget testing(context, item) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var time = '';
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
            Positioned(
              right: width * 0.02,
              bottom: height * 0.005,
              child: GestureDetector(
                onTap: () => checkingfavourite(item),
                child: Icon(
                  Icons.favorite_border,
                  color: Colors.red,
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
                            // decoration: BoxDecoration(
                            //     border: Border.all(color: Colors.black)),
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

  Widget favorite(context, item) {
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
        child: Stack(
          children: [
            Positioned(
              right: width * 0.02,
              bottom: height * 0.005,
              child: GestureDetector(
                onTap: () => checkingfavourite(item),
                child: Icon(
                  // Icons.favorite_border,
                  Icons.favorite_outlined,

                  color: Colors.red,
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
                      image: NetworkImage(item['urlToImage']),
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
                          Text(item['title']),
                        ],
                      )
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
                if (snapshort.hasData) {
                  var articles = snapshort.data as List;
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
                            return GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          Detail(item: item)));
                                },
                                child: item['urlToImage'] != null &&
                                        item['content'] != null &&
                                        item['author'] != null
                                    ? testing(context, item)
                                    : Container());
                          },
                          childCount: articles.length,
                        )),
                      )
                    ],
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }

                // if (favourite.length > 0) {
                //   for (var iIndex = 0; iIndex < items.length; iIndex++) {
                //     for (var i = 0; i < favourite.length; i++) {
                //       if (items[iIndex]==favourite[i]) {
                //         return favorite(context, item);
                //       } else {
                //         return testing(context, item);
                //       }
                //     }
                //   }
                // } else {
                // }
                // }
                // return

                // )
                // ;

                //  Hero(
                //   transitionOnUserGestures: true,
                //   tag: item,
                //   child: Material(child:
                // ));
                //   },
              })),
    );
  }
}
