import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Categories/detail.dart';

class Favourite extends StatefulWidget {
  @override
  _FavouriteState createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {
  final currentUser = FirebaseAuth.instance.currentUser;
  final Stream<QuerySnapshot> favourite = FirebaseFirestore.instance
      .collection('Users')
      .doc('${FirebaseAuth.instance.currentUser!.uid}')
      .collection('Favourite')
      .snapshots();

  favouriteRemove(item) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      await firestore
          .collection('Users')
          .doc('${FirebaseAuth.instance.currentUser!.uid}')
          .collection('Favourite')
          .doc('${item['id']}')
          .delete();
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
                onTap: () => {
                  favouriteRemove(item),
                },
                child: Icon(
                  Icons.favorite,
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue[300],
            leading: BackButton(
                color: Colors.white, onPressed: () => Navigator.pop(context)),
            title: Text('Favourite',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold)),
            centerTitle: true,
          ),
          body: StreamBuilder(
              stream: favourite,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Something Went Wrong'));
                } else if (snapshot.hasData) {
                  var data =
                      snapshot.data!.docs.map((e) => e['articles']).toList();
                  print(data);
                  if (data.isEmpty) {
                    return Center(
                        child: Text("You haven't liked anything yet."));
                  } else {
                    return Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.height * 0.004),
                      child: ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            var item = data[index];
                            return GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          Detail(item: item)));
                                },
                                child: testing(context, item, index));
                          }),
                    );
                  }
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              })),
    );
  }
}
