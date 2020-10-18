import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:zmcpanel/data_shared.dart';
import 'package:zmcpanel/rutas.dart';

void main() {

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  
  final Rutas rutas = Rutas();

  @override
  Widget build(BuildContext context) {

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
       statusBarColor: Color(0xff002f51).withAlpha(100),
       systemNavigationBarColor: Color(0xff002f51)
    ));
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DataShared())
      ],
      child: MaterialApp(
        title: 'ZmCpanel',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('es', 'MX'),
        ],
        initialRoute: 'login_asesor_page',
        routes: rutas.getRutas(context),
      ),
    );
  }
}