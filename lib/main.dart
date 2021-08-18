import 'package:flutter/material.dart';
import 'package:notes_app/screens/home.dart';
import 'models/user_prefrences.dart';

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await UserPrefrences.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 37, 37, 37),
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }
}