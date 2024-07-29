import 'package:buyerapp/manager/vender_or_buyer.dart';
import 'package:buyerapp/provider/cart_provider.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyBWkmq0vogrCahGU4PBD1q2IFcUqqgeHCI",
          appId: "1:153527980072:android:98bacc7d21fc5cc288251d",
          messagingSenderId: "153527980072",
          projectId: "e-rolex-99f21",
          storageBucket: "e-rolex-99f21.appspot.com"));

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => CartProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        // Application name
        title: 'e_Rolex',
        // Application theme data, you can set the colors for the application as
        // you want
        theme: ThemeData(
          // useMaterial3: false,
          primarySwatch: Colors.blue,
        ),
        // A widget which will be started on application startup
        home: CoverPage());
  }
}
