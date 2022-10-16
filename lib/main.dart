import 'package:flutter/material.dart';

import 'package:quote_app/colors.dart';
import 'package:quote_app/screens/author_screen.dart';

void main() async {
  //initialize hive
  // await Hive.initFlutter();

  // open the box
  // var box = await Hive.openBox('myBox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quotes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: primaryDarkColorDark,
      ),
      home: AuthorsScreen(),
    );
  }
}
