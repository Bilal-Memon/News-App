import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:newsapp/Home/Categories/detail.dart';
import 'package:newsapp/Home/Search/search.dart';

class SearchResult extends StatefulWidget {
  final result;
  const SearchResult({this.result});
  @override
  _SearchResultState createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  var from = '';
  var to = '';
  var filterFrom = '';
  var filterTo = '';
  // var dateOfBirth = '';
  getUser() async {
    var dateTo = DateTime.now();
    final dateToString = DateFormat('yyyy-MM-d').format(dateTo);
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
    var response;
    filterFrom != ''
        ? response = await http.get(Uri.parse(
            'https://newsapi.org/v2/everything?q=${widget.result}&from=$filterFrom&to=$dateToString&top&pageSize=30&apiKey=2d994719819c49a483538246c73c74ab'))
        : filterFrom != '' && filterTo != ''
            ? response = await http.get(Uri.parse(
                'https://newsapi.org/v2/everything?q=${widget.result}&from=$filterFrom&to=$filterTo&top&pageSize=30&apiKey=2d994719819c49a483538246c73c74ab'))
            : response = await http.get(Uri.parse(
                'https://newsapi.org/v2/everything?q=${widget.result}&from=$dateFrom&to=$dateToString&top&pageSize=30&apiKey=2d994719819c49a483538246c73c74ab'));
    // 'https://newsapi.org/v2/everything?language=en&q=stories&from=$dateFrom&to=${dateTo.year}-${dateTo.month}-${dateTo.day}&pageSize=50&sortBy=top&apiKey=56c6fdfe8bed415480e0088f18c86c0f'));
    final body = json.decode(response.body);
    List takingData = body['articles'];
    // List takingData = body['articles'].cast<dynamic>();
    return takingData;
  }

  pickDate(name) async {
    FocusScope.of(context).unfocus();
    final initialDate = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(DateTime.now().year - 30),
      lastDate: DateTime(DateTime.now().year + 30),
    );
    final formatter = DateFormat('yyyy-MM-d');
    final String formatted = formatter.format(date!);
    setState(() {
      name == 'From' ? from = formatted : to = formatted;
    });
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
                onTap: () => {},
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

  Widget input(context, name, controll) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        name,
        style: TextStyle(
            fontSize: 15, color: Colors.white, fontWeight: FontWeight.w400),
      ),
      GestureDetector(
        onTap: () => pickDate(name),
        child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.07,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            child: ListTile(
              leading: Icon(
                Icons.calendar_today,
                color: Colors.black,
              ),
              title: Center(
                  child: Text(
                name == 'From' && from != ''
                    ? from
                    : name == 'To' && to != ''
                        ? to
                        : '',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                ),
              )),
              trailing: Icon(
                Icons.keyboard_arrow_down,
                color: Colors.black,
              ),
            )),
      )
    ]);
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
          // titleSpacing: 0,
          title: GestureDetector(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Search()));
            },
            child: Container(
              width: width*0.8,
              child: Text(
                widget.result,
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 17, color: Colors.black),
              ),
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                showDialog(
                    builder: (context) =>
                        StatefulBuilder(builder: (context, setState) {
                          return AlertDialog(
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Filter',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'From',
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      GestureDetector(
                                        onTap: () => pickDate('From'),
                                        child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.9,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.07,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Colors.black),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5)),
                                            ),
                                            child: ListTile(
                                              leading: Icon(
                                                Icons.calendar_today,
                                                color: Colors.black,
                                              ),
                                              title: Center(
                                                  child: Text(
                                                from != '' ? from : '',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 17,
                                                ),
                                              )),
                                              trailing: Icon(
                                                Icons.keyboard_arrow_down,
                                                color: Colors.black,
                                              ),
                                            )),
                                      )
                                    ]),
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'To',
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      GestureDetector(
                                        onTap: () => pickDate('To'),
                                        child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.9,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.07,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Colors.black),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5)),
                                            ),
                                            child: ListTile(
                                              leading: Icon(
                                                Icons.calendar_today,
                                                color: Colors.black,
                                              ),
                                              title: Center(
                                                  child: Text(
                                                to != '' ? to : '',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 17,
                                                ),
                                              )),
                                              trailing: Icon(
                                                Icons.keyboard_arrow_down,
                                                color: Colors.black,
                                              ),
                                            )),
                                      )
                                    ]),
                              ],
                            ),
                            actions: [
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    filterFrom = from;
                                    filterTo = to;
                                  });
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'Change',
                                ),
                              )
                            ],
                          );
                        }),
                    context: context,
                    barrierDismissible: true);
              },
              child: Padding(
                padding:
                    EdgeInsets.only(left: width * 0.03, right: width * 0.03),
                child: Icon(
                  Icons.filter_alt_outlined,
                  color: Colors.black,
                ),
              ),
            )
          ],
        ),
        body: FutureBuilder(
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
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    );
                  } else {
                    var articles = snapshort.data as List;
                    return ListView.builder(
                        itemCount: articles.length,
                        itemBuilder: (context, index) {
                          var item = articles[index];

                          return item['urlToImage'] != null &&
                                  item['content'] != null &&
                                  item['author'] != null
                              ? GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Detail(item: item)));
                                  },
                                  child: testing(context, item))
                              : Container();
                        });
                  }
              }
            }),
      ),
    );
  }
}
