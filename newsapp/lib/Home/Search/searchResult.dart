import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:newsapp/Authentication/signUp.dart';
import 'package:newsapp/Home/Categories/detail.dart';
import 'package:newsapp/Home/Search/search.dart';
import 'package:uuid/uuid.dart';

class SearchResult extends StatefulWidget {
  final result;
  const SearchResult({required this.result});
  @override
  _SearchResultState createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  final currentUser = FirebaseAuth.instance.currentUser;
  var docId = Uuid();
  var favouriteHeart = [];
  var dateNow = DateTime.now();
  var dayFController = TextEditingController();
  var monthFController = TextEditingController();
  var yearFController = TextEditingController();
  var dayF = FocusNode();
  var monthF = FocusNode();
  var yearF = FocusNode();
  var dayTController = TextEditingController();
  var monthTController = TextEditingController();
  var yearTController = TextEditingController();
  var dayT = FocusNode();
  var monthT = FocusNode();
  var yearT = FocusNode();
  var filterFrom = '';
  var filterTo = '';
  final customCacheManager = CacheManager(
      Config('searchResultCacheKey', stalePeriod: Duration(hours: 2)));

  var dateOfBirth = '';
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
    var db = FirebaseFirestore.instance;
    var response;
    filterFrom != ''
        ? response = await http.get(Uri.parse(
            'https://newsapi.org/v2/everything?q=${widget.result}&from=$filterFrom&top&pageSize=50&apiKey=2d994719819c49a483538246c73c74ab'))
        : filterFrom != '' && filterTo != ''
            ? response = await http.get(Uri.parse(
                'https://newsapi.org/v2/everything?q=${widget.result}&from=$filterFrom&to=$filterTo&top&pageSize=50&apiKey=2d994719819c49a483538246c73c74ab'))
            : response = await http.get(Uri.parse(
                'https://newsapi.org/v2/everything?q=${widget.result}&language&from=$dateFrom&sortBy=top&pageSize=50&apiKey=2d994719819c49a483538246c73c74ab'));
    final body = json.decode(response.body);
    List data = body['articles'];
    if (FirebaseAuth.instance.currentUser != null) {
      var favouriteCheck = await db
          .collection('Users')
          .doc('${FirebaseAuth.instance.currentUser!.uid}')
          .collection('Favourite')
          .get()
          .then((querySnapshot) =>
              querySnapshot.docs.map((e) => e['articles']).toList());
      for (var i = 0; i < data.length; i++) {
        data[i]['fav'] = 'off';
        for (var fI = 0; fI < favouriteCheck.length; fI++) {
          if (favouriteCheck[fI]['title'] == data[i]['title']) {
            data[i] = favouriteCheck[fI];
          }
        }
        favouriteHeart = [...favouriteHeart, data[i]['fav']];
      }
    }
    return data;
  }

  favouriteAdd(item, index) async {
    var id = docId.v4();
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      item['id'] = id;
      item['fav'] = 'on';
      await firestore
          .collection('Users')
          .doc('${FirebaseAuth.instance.currentUser!.uid}')
          .collection('Favourite')
          .doc('$id')
          .set({'articles': item});
      setState(() {
        favouriteHeart[index] = 'on';
      });
    } catch (e) {
      print(e);
    }
  }

  favouriteRemove(item, index) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      await firestore
          .collection('Users')
          .doc('${FirebaseAuth.instance.currentUser!.uid}')
          .collection('Favourite')
          .doc('${item['id']}')
          .delete();
      setState(() {
        favouriteHeart[index] = 'off';
      });
    } catch (e) {
      print(e);
    }
  }

  Widget testing(context, item, index) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var datebaseTime = DateTime.parse(item['publishedAt']);
    final dateString = DateFormat('dd-MM-yyyy h:mma').format(datebaseTime);
    final datemonth = DateFormat('dd-MM-yyyy').format(datebaseTime);
    DateTime notificationDate =
        DateFormat("dd-MM-yyyy h:mma").parse(dateString);
    final date2 = DateTime.now();
    final difference = date2.difference(notificationDate);
    checking() async {
      await precacheImage(
          CachedNetworkImageProvider('${item['urlToImage']}'), context);
    }

    checking();

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
            FirebaseAuth.instance.currentUser != null
                ? favouriteHeart[index] == 'on'
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
                            favouriteAdd(item, index),
                          },
                          child: Icon(
                            Icons.favorite_border,
                          ),
                        ),
                      )
                : Positioned(
                    right: width * 0.02,
                    bottom: height * 0.005,
                    child: GestureDetector(
                      onTap: () => {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => SignUp()))
                      },
                      child: Icon(
                        Icons.favorite_border,
                      ),
                    ),
                  ),
            Row(
              children: [
                Container(
                    width: width * 0.4,
                    height: height * 0.12,
                    child: CachedNetworkImage(
                      cacheManager: customCacheManager,
                      key: UniqueKey(),
                      imageUrl: '${item['urlToImage']}',
                      width: width * 0.4,
                      height: height * 0.12,
                      fit: BoxFit.cover,
                      placeholder: (context, item) => Container(
                        color: Colors.black12,
                      ),
                      errorWidget: (context, item, error) => Container(
                        color: Colors.black12,
                        child: Icon(Icons.error, color: Colors.red),
                      ),
                    )),
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

  changeDate(context) {
    Navigator.pop(context);
    //    both
    if (dayFController.text.length == 2 &&
        monthFController.text.length == 2 &&
        yearFController.text.length == 4 &&
        dayTController.text.length == 2 &&
        monthTController.text.length == 2 &&
        yearTController.text.length == 4) {
      if (dayFController.text.startsWith('0') == true &&
          dayTController.text.startsWith('0') == true) {
        var day1 = dayFController.text.substring(1);
        var day2 = dayTController.text.substring(1);
        setState(() {
          filterFrom = '${yearFController.text}-${monthFController.text}-$day1';
          filterTo = '${yearTController.text}-${monthTController.text}-$day2';
        });
      } else if (dayFController.text.startsWith('0') == true) {
        var day1 = dayFController.text.substring(1);
        setState(() {
          filterFrom = '${yearFController.text}-${monthFController.text}-$day1';
          filterTo =
              '${yearTController.text}-${monthTController.text}-${dayTController.text}';
        });
      } else if (dayTController.text.startsWith('0') == true) {
        var day2 = dayTController.text.substring(1);
        setState(() {
          filterFrom =
              '${yearFController.text}-${monthFController.text}-${dayFController.text}';
          filterTo = '${yearTController.text}-${monthTController.text}-$day2';
        });
      } else {
        setState(() {
          filterFrom =
              '${yearFController.text}-${monthFController.text}-${dayFController.text}';
          filterTo =
              '${yearTController.text}-${monthTController.text}-${dayTController.text}';
        });
      }
    }
    //   only from
    else if (dayFController.text.length == 2 &&
        monthFController.text.length == 2 &&
        yearFController.text.length == 4) {
      if (dayFController.text.startsWith('0') == true) {
        var day1 = dayFController.text.substring(1);
        setState(() {
          filterFrom = '${yearFController.text}-${monthFController.text}-$day1';
          dayTController.text = '';
          monthTController.text = '';
          yearTController.text = '';
        });
      } else {
        setState(() {
          filterFrom =
              '${yearFController.text}-${monthFController.text}-${dayFController.text}';
          dayTController.text = '';
          monthTController.text = '';
          yearTController.text = '';
        });
      }
    } else {
      dayFController.text = '';
      monthFController.text = '';
      yearFController.text = '';
      dayTController.text = '';
      monthTController.text = '';
      yearTController.text = '';
    }
    print('filterFrom===>$filterFrom');
    print('filterTo===>$filterTo');
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
              width: width * 0.8,
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
                                SizedBox(
                                  height: height * 0.02,
                                ),
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'From',
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      GestureDetector(
                                          onTap: () => FocusScope.of(context)
                                              .requestFocus(dayF),
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
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: width * 0.02),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      width: 20,
                                                      child: TextField(
                                                        controller:
                                                            dayFController,
                                                        onChanged: (e) => {
                                                          if (e.length == 2 &&
                                                              monthFController
                                                                      .text
                                                                      .length <
                                                                  2)
                                                            {
                                                              FocusScope.of(
                                                                      context)
                                                                  .requestFocus(
                                                                      monthF)
                                                            }
                                                          else if (e.length ==
                                                              2)
                                                            {
                                                              FocusScope.of(
                                                                      context)
                                                                  .requestFocus(
                                                                      FocusNode())
                                                            }
                                                        },
                                                        focusNode: dayF,
                                                        maxLength: 2,
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        decoration:
                                                            InputDecoration(
                                                          counterText: '',
                                                          hintText:
                                                              '${dateNow.day}',
                                                          border:
                                                              InputBorder.none,
                                                          focusedBorder:
                                                              InputBorder.none,
                                                          enabledBorder:
                                                              InputBorder.none,
                                                          errorBorder:
                                                              InputBorder.none,
                                                          disabledBorder:
                                                              InputBorder.none,
                                                        ),
                                                      ),
                                                    ),
                                                    Text(' - '),
                                                    Container(
                                                      width: 20,
                                                      child: Center(
                                                        child: TextField(
                                                          onChanged: (e) => {
                                                            if (e.length == 2 &&
                                                                yearFController
                                                                        .text
                                                                        .length <
                                                                    4)
                                                              {
                                                                FocusScope.of(
                                                                        context)
                                                                    .requestFocus(
                                                                        yearF)
                                                              }
                                                            else if (e.length ==
                                                                2)
                                                              {
                                                                FocusScope.of(
                                                                        context)
                                                                    .requestFocus(
                                                                        FocusNode())
                                                              }
                                                          },
                                                          controller:
                                                              monthFController,
                                                          focusNode: monthF,
                                                          maxLength: 2,
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          decoration:
                                                              InputDecoration(
                                                            counterText: '',
                                                            hintText: dateNow
                                                                        .month !=
                                                                    1
                                                                ? '0${dateNow.month - 1}'
                                                                : dateNow.month <
                                                                        10
                                                                    ? '0${dateNow.month}'
                                                                    : '${dateNow.month}',
                                                            border: InputBorder
                                                                .none,
                                                            focusedBorder:
                                                                InputBorder
                                                                    .none,
                                                            enabledBorder:
                                                                InputBorder
                                                                    .none,
                                                            errorBorder:
                                                                InputBorder
                                                                    .none,
                                                            disabledBorder:
                                                                InputBorder
                                                                    .none,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Text(' - '),
                                                    Container(
                                                      width: 40,
                                                      child: TextField(
                                                        onChanged: (e) => {
                                                          if (e.length == 4)
                                                            {
                                                              FocusScope.of(
                                                                      context)
                                                                  .requestFocus(
                                                                      FocusNode())
                                                            }
                                                        },
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        controller:
                                                            yearFController,
                                                        focusNode: yearF,
                                                        maxLength: 4,
                                                        decoration:
                                                            InputDecoration(
                                                          counterText: '',
                                                          hintText:
                                                              '${dateNow.year}',
                                                          border:
                                                              InputBorder.none,
                                                          focusedBorder:
                                                              InputBorder.none,
                                                          enabledBorder:
                                                              InputBorder.none,
                                                          errorBorder:
                                                              InputBorder.none,
                                                          disabledBorder:
                                                              InputBorder.none,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )))
                                    ]),
                                SizedBox(
                                  height: height * .01,
                                ),
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'To',
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      GestureDetector(
                                          onTap: () => FocusScope.of(context)
                                              .requestFocus(dayT),
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
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: width * 0.02),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      width: 20,
                                                      child: TextField(
                                                        onChanged: (e) => {
                                                          if (e.length == 2 &&
                                                              monthTController
                                                                      .text
                                                                      .length <
                                                                  2)
                                                            {
                                                              FocusScope.of(
                                                                      context)
                                                                  .requestFocus(
                                                                      monthT)
                                                            }
                                                          else if (e.length ==
                                                              2)
                                                            {
                                                              FocusScope.of(
                                                                      context)
                                                                  .requestFocus(
                                                                      FocusNode())
                                                            }
                                                        },
                                                        controller:
                                                            dayTController,
                                                        focusNode: dayT,
                                                        maxLength: 2,
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        decoration:
                                                            InputDecoration(
                                                          counterText: '',
                                                          hintText:
                                                              '${dateNow.day}',
                                                          border:
                                                              InputBorder.none,
                                                          focusedBorder:
                                                              InputBorder.none,
                                                          enabledBorder:
                                                              InputBorder.none,
                                                          errorBorder:
                                                              InputBorder.none,
                                                          disabledBorder:
                                                              InputBorder.none,
                                                        ),
                                                      ),
                                                    ),
                                                    Text(' - '),
                                                    Container(
                                                      width: 20,
                                                      child: Center(
                                                        child: TextField(
                                                          onChanged: (e) => {
                                                            if (e.length == 2 &&
                                                                yearTController
                                                                        .text
                                                                        .length <
                                                                    4)
                                                              {
                                                                FocusScope.of(
                                                                        context)
                                                                    .requestFocus(
                                                                        yearT)
                                                              }
                                                            else if (e.length ==
                                                                2)
                                                              {
                                                                FocusScope.of(
                                                                        context)
                                                                    .requestFocus(
                                                                        FocusNode())
                                                              }
                                                          },
                                                          controller:
                                                              monthTController,
                                                          focusNode: monthT,
                                                          maxLength: 2,
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          decoration:
                                                              InputDecoration(
                                                            counterText: '',
                                                            hintText:
                                                                '${dateNow.month}',
                                                            border: InputBorder
                                                                .none,
                                                            focusedBorder:
                                                                InputBorder
                                                                    .none,
                                                            enabledBorder:
                                                                InputBorder
                                                                    .none,
                                                            errorBorder:
                                                                InputBorder
                                                                    .none,
                                                            disabledBorder:
                                                                InputBorder
                                                                    .none,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Text(' - '),
                                                    Container(
                                                      width: 40,
                                                      child: TextField(
                                                        onChanged: (e) => {
                                                          if (e.length == 4)
                                                            {
                                                              FocusScope.of(
                                                                      context)
                                                                  .requestFocus(
                                                                      FocusNode())
                                                            }
                                                        },
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        controller:
                                                            yearTController,
                                                        focusNode: yearT,
                                                        maxLength: 4,
                                                        decoration:
                                                            InputDecoration(
                                                          counterText: '',
                                                          hintText:
                                                              '${dateNow.year}',
                                                          border:
                                                              InputBorder.none,
                                                          focusedBorder:
                                                              InputBorder.none,
                                                          enabledBorder:
                                                              InputBorder.none,
                                                          errorBorder:
                                                              InputBorder.none,
                                                          disabledBorder:
                                                              InputBorder.none,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )))
                                    ]),
                              ],
                            ),
                            actions: [
                              ElevatedButton(
                                onPressed: () => changeDate(context),
                                child: Text(
                                  'Filter',
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
                          return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => Detail(item: item)));
                              },
                              child: item['urlToImage'] != null &&
                                      item['content'] != null &&
                                      item['author'] != null
                                  ? testing(context, item, index)
                                  : Container());
                        });
                  }
              }
            }),
      ),
    );
  }
}
