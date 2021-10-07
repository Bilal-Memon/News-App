import 'package:flutter/material.dart';
import 'package:newsapp/Authentication/login.dart';
import 'package:newsapp/Authentication/signUp.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:newsapp/Home/Categories/detail.dart';
import 'package:newsapp/Home/Search/search.dart';
import 'package:newsapp/Home/home.dart';
import 'package:intl/intl.dart';
import 'package:newsapp/Home/profile.dart';

import 'Home/Categories/TopStories.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // checkingdate() {
  //   var time = '';
  //   var datebaseTime = DateTime.parse('2021-10-03T23:21:00Z');
  //   final dateString = DateFormat('dd-MM-yyyy h:mma').format(datebaseTime);
  //   final datemonth = DateFormat('dd-MM-yyyy').format(datebaseTime);

  //   DateTime notificationDate =
  //       DateFormat("dd-MM-yyyy h:mma").parse(dateString);
  //   final date2 = DateTime.now();
  //   final difference = date2.difference(notificationDate);
  //   // var numericDates = false;
  //   if (difference.inDays > 8) {
  //     time = datemonth;
  //     // print( datemonth);
  //     // return dateString;
  //   } else if ((difference.inDays / 7).floor() >= 1) {
  //     time = '1 week ago';
  //     // print((numericDates) ? '1 week ago' : 'Last week');
  //     // return (numericDates) ? '1 week ago' : 'Last week';
  //   } else if (difference.inDays >= 2) {
  //     time = '${difference.inDays} days ago';
  //     // return '${difference.inDays} days ago';
  //   } else if (difference.inDays >= 1) {
  //     time = 'Yesterday';
  //     // print((numericDates) ? '1 day ago' : 'Yesterday');
  //     // return (numericDates) ? '1 day ago' : 'Yesterday';
  //   } else if (difference.inHours >= 1) {
  //     time = '${difference.inHours} hours ago';
  //     // return '${difference.inHours} hours ago';
  //   }
  //   // else if (difference.inHours >= 1) {
  //   //   print((numericDates) ? '1 hour ago' : 'An hour ago');
  //   //   // print((numericDates) ? '1 hour ago' : 'An hour ago');
  //   //   // return (numericDates) ? '1 hour ago' : 'An hour ago';
  //   // }
  //   else if (difference.inMinutes >= 1) {
  //     time = '${difference.inMinutes} minutes ago';
  //     // return '${difference.inMinutes} minutes ago';
  //   }
  //   // else if (difference.inMinutes >= 1) {
  //   //   print((numericDates) ? '1 minute ago' : 'A minute ago');
  //   //   // return (numericDates) ? '1 minute ago' : 'A minute ago';
  //   // }
  //   else if (difference.inSeconds >= 3) {
  //     time = '${difference.inSeconds} seconds ago';
  //     // return '${difference.inSeconds} seconds ago';
  //   } else {
  //     time = 'Just now';
  //     // return 'Just now';

  //   }
  //   print(time);
  // }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // var time = '09-10-2020 08:29AM';
    // print(TimeAgo.timeAgoSinceDate('2021-10-03 14:26:15Z'));
    // print(TimeAgo.timeAgoSinceDate('09-10-2020 08:29AM'));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
//       routes: {
//         '/home': (context) => Home(),
//         // '/topStories': (context) => TopStories(),
//         '/home/detail': (context) => Detail(),
// // '/home':(context)=>Home(),
//       },
      // Center(
      //     child: ElevatedButton(onPressed: checkingdate, child: Text('get'))
      //     //          Text(
      //     //   '${TimeAgo.timeAgoSinceDate(time)}',
      //     //   style: TextStyle(color: Colors.white),
      //     // )
      //     )
      // // )
    );
  }
}
