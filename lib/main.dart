import 'package:flutter/material.dart';
import 'package:flutter_achitecture/Bloc.dart';
import 'package:provider/provider.dart';
import 'package:splashscreen/splashscreen.dart';

import 'map_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BlocManager>(
      create: (_) => BlocManager(),
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Container(
          color: Colors.purple,
          child: SplashScreen(
              seconds: 2,
              navigateAfterSeconds: new MapView(),
              title: new Text('Restaurant Finder', style: TextStyle(fontSize: 30),),
              image: new Image.asset('assets/images/product_icon.png'),
              backgroundColor: Colors.white,
              photoSize: 100.0,
              loaderColor: Colors.white
          ),
        ),//MapView(),//SplashScreen(),//MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}