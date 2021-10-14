import 'package:flutter/material.dart';
import 'package:newsapp/Authentication/login.dart';
import 'package:newsapp/Authentication/signUp.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:newsapp/Home/Categories/detail.dart';
import 'package:newsapp/Home/Search/search.dart';
import 'package:newsapp/Home/Search/searchResult.dart';
import 'package:newsapp/Home/home.dart';
import 'package:intl/intl.dart';
import 'package:newsapp/Home/profile.dart';

import 'Home/Categories/TopStories.dart';
import 'Home/favourite.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}
