import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/utilities/utils.dart';

import 'views/home_view.dart';

import 'package:device_preview/device_preview.dart';

void main() => runApp(
      DevicePreview(
        enabled: !kReleaseMode,
        builder: (context) => MyApp(), // Wrap your app
      ),
    );

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      title: 'Todo',
      theme: ThemeData(
          textTheme: const TextTheme(bodyText1: TextStyle(color: customBlue)),
          shadowColor: Colors.white38,
          primaryColor: Colors.white,
          scaffoldBackgroundColor: const Color.fromRGBO(249, 251, 255, 1),
          appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              elevation: 0,
              iconTheme: IconThemeData(color: customBlue),
              titleTextStyle: TextStyle(
                  color: customBlue, fontSize: 21, fontWeight: FontWeight.w600),
              actionsIconTheme: IconThemeData(color: customBlue)),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Color.fromRGBO(229, 232, 249, 1),
          )),
      darkTheme: ThemeData.dark().copyWith(
          textTheme: const TextTheme(bodyText1: TextStyle(color: Colors.white)),
          shadowColor: Colors.grey,
          primaryColor: Colors.black,
          appBarTheme: const AppBarTheme(
              elevation: 0,
              titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 21,
                  fontWeight: FontWeight.w600),
              actionsIconTheme: IconThemeData(color: Colors.white)),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Color.fromRGBO(229, 232, 249, .5),
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Colors.grey)),
      themeMode: ThemeMode.system,
      home: const HomeView(),
    );
  }
}
