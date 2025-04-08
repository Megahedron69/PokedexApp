// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_app/core/theme/DarkTheme.dart';
import 'package:new_app/core/theme/LightTheme.dart';
import 'package:new_app/routes/app_routes.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(ProviderScope(child: MyApp()));
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Color(0xFFFFDE00),
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "My pokemon app",
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
    );
  }
}

// class MyTapp extends StatelessWidget {
//   const MyTapp({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return CupertinoApp(
//       title: 'My iOS App',
//       theme: CupertinoThemeData(brightness: Brightness.light),
//       home: CupertinoPageScaffold(
//         navigationBar: CupertinoNavigationBar(middle: Text('Home')),
//         child: Center(child: Text('Hello, Cupertino!')),
//       ),
//     );
//   }
// }
