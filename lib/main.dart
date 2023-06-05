import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtubedioupload/providers/upload_provider.dart';
import 'package:youtubedioupload/screens/main_screen.dart';
import 'package:youtubedioupload/screens/provider_screen.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_)=>UploadProvider())
  ],child: const MyApp(),));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: true ? ProviderScreen() : MainScreen(),
    );
  }
}

