import 'package:flutter/material.dart';
import 'package:test_encurtar_link/constants/rgbcolor.constant.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:test_encurtar_link/class/route_generator.dart';

MaterialColor colorCustom = MaterialColor(0xFF00afdf, color);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Encurtador URL',
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: [
        const Locale('pt', 'BR'),
      ],
      locale: const Locale('pt'),
      theme: ThemeData(
        //
        primarySwatch: colorCustom,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
