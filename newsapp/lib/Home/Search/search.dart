import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;
import 'package:newsapp/Home/Categories/detail.dart';
import 'package:newsapp/Home/Search/searchResult.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  var searchController = TextEditingController();
  var search = '';
  final customCacheManager = CacheManager(
      Config('searchCacheKey', stalePeriod: Duration(minutes: 30)));

  checking(item) async {
    await precacheImage(
        CachedNetworkImageProvider('${item['urlToImage']}'), context);
  }

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
        'https://newsapi.org/v2/everything?qInTitle=$search&from=$dateFrom&sortBy=top&pageSize=30&apiKey=2d994719819c49a483538246c73c74ab'));
    final body = json.decode(response.body);
    List takingData = body['articles'].cast<dynamic>();
    return takingData;
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.grey[100],
            leading: BackButton(
                color: Colors.black,
                onPressed: () =>
                    Navigator.popUntil(context, ModalRoute.withName('/'))),
            titleSpacing: 0,
            title: TextFormField(
              onChanged: (e) => {
                setState(() {
                  search = e;
                })
              },
              style: TextStyle(fontSize: 17, color: Colors.black),
              enableSuggestions: true,
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Anything...',
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
              ),
            ),
            centerTitle: true,
            actions: [
              search.length != 0
                  ? GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    SearchResult(result: search)));
                      },
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: width * 0.03, right: width * 0.03),
                        child: Icon(
                          Icons.search,
                          color: Colors.black,
                        ),
                      ),
                    )
                  : Container()
            ],
          ),
          body: search.length != 0
              ? FutureBuilder(
                  future: getUser(),
                  builder: (context, snapshort) {
                    switch (snapshort.connectionState) {
                      case ConnectionState.waiting:
                        return Center(child: CircularProgressIndicator());
                      default:
                        if (snapshort.hasError) {
                          return Center(
                            child: Text(
                              'Something went wrong!',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                          );
                        }
                        //  else if (snapshort) {
                        //   return Center(child: Text('No Suggestion'));
                        // }
                        else {
                          var articles = snapshort.data as List;
                          return ListView.builder(
                              itemCount: articles.length,
                              itemBuilder: (context, index) {
                                var item = articles[index];
                                item['urlToImage'] != null
                                    ? checking(item)
                                    : null;
                                return item['urlToImage'] != null &&
                                        item['content'] != null &&
                                        item['author'] != null
                                    ? GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            searchController.text = '';
                                            search = '';
                                          });
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Detail(item: item)));
                                        },
                                        child: ListTile(
                                            leading: Padding(
                                              padding: EdgeInsets.only(
                                                  right: width * 0.01),
                                              child: 
                                                 ClipRRect(
                                                   borderRadius: BorderRadius.circular(25),
                                                   child: CachedNetworkImage(
                                                      cacheManager:
                                                          customCacheManager,
                                                      key: UniqueKey(),
                                                      imageUrl:
                                                          '${item['urlToImage']}',
                                                      width: 40,
                                                      height: 40,
                                                      fit: BoxFit.cover,
                                                      placeholder: (context,
                                                              item) =>
                                                          Container(
                                                            color: Colors.black12,
                                                          ),
                                                      errorWidget: (context, item,
                                                              error) =>
                                                          Container(
                                                            color: Colors.black12,
                                                            child: Icon(
                                                                Icons.error,
                                                                color:
                                                                    Colors.red),
                                                          )),
                                                 ),
                                            ),
                                            title: Text(
                                              '${item['title']}',
                                              maxLines: 1,
                                            ),
                                            horizontalTitleGap: 0,
                                            trailing: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    searchController.text =
                                                        item['title'];
                                                    search = item['title'];
                                                  });
                                                },
                                                child: Icon(
                                                  Icons.arrow_upward,
                                                  color: Colors.grey,
                                                ))))
                                    : Container();
                              });
                        }
                    }
                    // } else {
                    //   return Center(child: CircularProgressIndicator());
                    // }
                  })
              : Container()),
      // : Center(child: Text('Nothing'))),
    );
  }
}
