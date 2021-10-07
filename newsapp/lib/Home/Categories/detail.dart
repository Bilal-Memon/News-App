import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:newsapp/Home/home.dart';

class Detail extends StatefulWidget {
  final item;
  const Detail({this.item});
  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var datebaseTime = DateTime.parse(widget.item['publishedAt']);
    final dateString = DateFormat('dd-MM-yyyy h:mma').format(datebaseTime);
    final datemonth = DateFormat('dd-MM-yyyy').format(datebaseTime);

    DateTime notificationDate =
        DateFormat("dd-MM-yyyy h:mma").parse(dateString);
    final date2 = DateTime.now();
    final difference = date2.difference(notificationDate);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Container(
            color: Colors.white,
            child: SafeArea(
                child: NestedScrollView(
              floatHeaderSlivers: true,
              headerSliverBuilder: (hContext, innerBoxIsScrolled) => [
                SliverAppBar(
                  floating: true,
                  snap: true,
                  leading: BackButton(
                      color: Colors.white,
                      onPressed: () => Navigator.pop(context)),
                  // Navigator.pushReplacement(context,
                  //     MaterialPageRoute(builder: (context) => Home()))),
                  title: Text('TopStories'),
                  backgroundColor: Colors.blue[300],
                  centerTitle: true,
                ),
              ],
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                        width: width * 1,
                        height: height * 0.3,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(widget.item['urlToImage']),
                          ),
                          // color: Colors.white,
                          // border: Border.all(color: Colors.black),
                        )),
                    SizedBox(
                      height: height * 0.03,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: width * 0.05,
                          right: width * 0.05,
                          bottom: height * 0.05),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${widget.item['title']}',
                            style: TextStyle(fontSize: 22, color: Colors.black),
                          ),
                          SizedBox(
                            height: height * 0.005,
                          ),
                          Text('By ${widget.item['author']}',
                              style: TextStyle(
                                  fontSize: 17, color: Colors.black54)),
                          SizedBox(
                            height: height * 0.005,
                          ),
                          Row(children: [
                            difference.inDays > 8
                                ? Text('$datemonth')
                                : (difference.inDays / 7).floor() >= 1
                                    // ? Text('1w')
                                    ? Text('1 week ago')
                                    : difference.inDays >= 2
                                        // ? Text('${difference.inDays}d')
                                        ? Text('${difference.inDays} days ago')
                                        : difference.inDays >= 1
                                            ? Text('Yesterday')
                                            : difference.inHours >= 1
                                                // ? Text( '${difference.inHours}h')
                                                ? Text(
                                                    '${difference.inHours} hours ago')
                                                : difference.inMinutes >= 1
                                                    // ? Text('${difference.inMinutes}m')
                                                    ? Text(
                                                        '${difference.inMinutes} minutes ago')
                                                    : difference.inSeconds >= 3
                                                        ? Text(
                                                            '${difference.inSeconds} seconds ago')
                                                        // ? Text(
                                                        //     '${difference.inSeconds}s')
                                                        : Text('Just now'),
                            Container(
                              height: 18,
                              child: VerticalDivider(
                                color: Colors.grey,
                                width: width * 0.06,
                                thickness: 1.3,
                              ),
                            ),
                            Text('${widget.item['source']['name']}'),
                          ]),
                          SizedBox(
                            height: height * 0.007,
                          ),
                          Text(
                            '${widget.item['description']}',
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(
                            height: height * 0.025,
                          ),
                          Divider(
                            height: 1,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            height: height * 0.025,
                          ),
                          Text(
                            '${widget.item['content']}',
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )),
          ),
        ));
  }
}
