import 'dart:convert';
import 'package:flutter/material.dart';
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
    //main
    var response = await http.get(Uri.parse(
        'https://newsapi.org/v2/everything?qInTitle=$search&from=$dateFrom&sortBy=top&pageSize=30&apiKey=2d994719819c49a483538246c73c74ab'));
    // 'https://newsapi.org/v2/everything?language=en&q=stories&from=$dateFrom&to=${dateTo.year}-${dateTo.month}-${dateTo.day}&pageSize=50&sortBy=top&apiKey=56c6fdfe8bed415480e0088f18c86c0f'));
    final body = json.decode(response.body);
    List takingData = body['articles'].cast<dynamic>();
    // if(takingData!=null){
    return takingData;
    // return takingData as Map<String, dynamic>;
    // }
    // List takingData = body['articles'];
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
                color: Colors.black, onPressed: () =>
                Navigator.popUntil(context, ModalRoute.withName('/'))),
                //  Navigator.pop(context)),
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
                        //  else if (snapshort.connectionState==ConnectionState.none) {
                        //   return Center(child: Text('No Suggestion'));
                        // }
                        else
                        //  if (snapshort.hasData) {
                        {
                          // var articles = snapshort.data as List;
                          var articles = snapshort.data as List;
                          return ListView.builder(
                              itemCount: articles.length,
                              itemBuilder: (context, index) {
                                var item = articles[index];

                                return item['urlToImage'] != null &&
                                        item['content'] != null &&
                                        item['author'] != null
                                    //  &&
                                    // index <10
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
                                              child: CircleAvatar(
                                                backgroundColor: Colors.white,
                                                radius: 25,
                                                backgroundImage: NetworkImage(
                                                  '${item['urlToImage']}',
                                                ),
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

                      // }
                      // if (snapshort.hasError) {
                      //   return Center(child: Text('Nothing'));
                      //   // return Center(child: Text('${snapshort.error}'));
                      // }
                      // else if(snapshort.data==null){
                      //   return Center(child: Text('Nothing'));

                      // }
                      // else if (snapshort.hasData) {
                      //   var articles = snapshort.data as List;
                      //   return
                      //       //  Padding(
                      //       //     padding: EdgeInsets.only(bottom: height * 0.004),
                      //       //     child:
                      //       ListView.builder(
                      //           itemCount: articles.length,
                      //           itemBuilder: (context, index) {
                      //             var item = articles[index];
                      //             return GestureDetector(
                      //                 onTap: () {
                      //                   print(item['source']['name']);
                      //                   // Navigator.of(context).push(MaterialPageRoute(
                      //                   //     builder: (context) =>
                      //                   //         Detail(item: item)));
                      //                 },
                      //                 child: ListTile(
                      //                   title: Text('${item['title']}'),
                      //                   // title: Text('${item['source']['name']}'),
                      //                 ));
                      // }
                      // )
                      // return GestureDetector(
                      //     onTap: () {
                      //       // Navigator.of(context).push(MaterialPageRoute(
                      //       //     builder: (context) =>
                      //       //         Detail(item: item)));
                      //     },
                      //     child: item['urlToImage'] != null &&
                      //             item['content'] != null &&
                      //             item['author'] != null
                      //         ? testing(context, item)
                      //         : Container());

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
