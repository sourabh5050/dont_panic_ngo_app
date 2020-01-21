import 'package:dont_panic_ngo_app/components/audiorecorder.dart';
import 'package:dont_panic_ngo_app/pages/HomePage.dart';
import 'package:dont_panic_ngo_app/pages/location_fetch_page.dart';
import 'package:dont_panic_ngo_app/pages/loginpage.dart';
import 'package:dont_panic_ngo_app/pages/register.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
       routes: {
        '/': (context) => LoginPage(),
        '/homepage':(context)=>HomePage(),
        '/recorder':(context)=>AudioRecorder(),
        '/register':(context)=>Register(),
        '/locationFetch':(context)=>mapss(),
      },
    );
  }
}

