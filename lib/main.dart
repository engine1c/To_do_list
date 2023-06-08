import 'package:flutter/material.dart';
import 'package:baseshop/pages/home.dart';
import 'package:baseshop/pages/main_screen.dart';
import 'package:firebase_core/firebase_core.dart';


void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  // Подключаем Firebase для авторизации
  await Firebase.initializeApp();

   runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Demo',
        theme: ThemeData(
          primarySwatch: Colors.lightBlue,
        ),
        home: const MainScreen(),
        routes: <String, WidgetBuilder>{
          '/home': (BuildContext context) => const Home(),
        });
  }
}
