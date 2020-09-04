import 'file:///D:/CGS/PBXAPP/igo-flutter/lib/src/utils/localizations.dart';
import 'package:IGO/src/ui/base/BaseState.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import './src/utils/SessionManager.dart';
import './src/constants/ConstantColor.dart';
import './src/ui/base/BaseState.dart';
import './src/ui/base/BaseSingleton.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_) => runApp(new SplashScreen()));
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        backgroundColor: ConstantColor.COLOR_WHITE,
      ),
      home: SplashScreenStateful(),
      localizationsDelegates: [
        const AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('de', ''),
        const Locale('fr', ''),
        const Locale('en', ''),
        const Locale('ta', ''),
      ],
      locale: new Locale("fr"),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplashScreenStateful extends StatefulWidget {
  SplashScreenStateful({Key key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends BaseStateStatefulState<SplashScreenStateful> {
  SessionManager sessionManager;

  SplashScreenState() {
    this.sessionManager = new SessionManager();
  }

  void forSomeDelay() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        if (BaseSingleton.shared.loginSession == "" ||
            BaseSingleton.shared.loginSession == null) {
          navigateBaseRouting(6);
        } else {
          navigateBaseRouting(6);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[containerAppLogo],
        ),
      ),
      backgroundColor: ConstantColor.COLOR_WHITE,
    );
  }

  @override
  void initState() {
    super.initState();
    if (this.mounted) {
      setState(() {
        forSomeDelay();
      });
    }
  }
}
