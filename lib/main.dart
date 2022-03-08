import 'package:country_code_picker/country_localizations.dart';
import 'package:dicegram/providers/profile_provider.dart';
import 'package:dicegram/snake_ladder/stores/snakes-ladders.dart';
import 'package:dicegram/snake_ladder/view/snake_ladder.dart';
import 'package:dicegram/ui/screens/dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:dicegram/ui/screens/login_screen.dart';
import 'package:dicegram/utils/Color.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'providers/group_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  GetIt getIt = GetIt.instance;
  getIt.registerSingleton<SnakesLadders>(SnakesLadders());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ProfileProvider>(
            create: (context) => ProfileProvider()),
        ChangeNotifierProvider<GroupProvider>(
            create: (context) => GroupProvider()),
      ],
      child: Sizer(
        builder: (context, orientation, deviceType) { return MaterialApp(
    supportedLocales: const [
    Locale("af"),
    Locale("am"),
    Locale("ar"),
    Locale("az"),
    Locale("be"),
    Locale("bg"),
    Locale("bn"),
    Locale("bs"),
    Locale("ca"),
    Locale("cs"),
    Locale("da"),
    Locale("de"),
    Locale("el"),
    Locale("en"),
    Locale("es"),
    Locale("et"),
    Locale("fa"),
    Locale("fi"),
    Locale("fr"),
    Locale("gl"),
    Locale("ha"),
    Locale("he"),
    Locale("hi"),
    Locale("hr"),
    Locale("hu"),
    Locale("hy"),
    Locale("id"),
    Locale("is"),
    Locale("it"),
    Locale("ja"),
    Locale("ka"),
    Locale("kk"),
    Locale("km"),
    Locale("ko"),
    Locale("ku"),
    Locale("ky"),
    Locale("lt"),
    Locale("lv"),
    Locale("mk"),
    Locale("ml"),
    Locale("mn"),
    Locale("ms"),
    Locale("nb"),
    Locale("nl"),
    Locale("nn"),
    Locale("no"),
    Locale("pl"),
    Locale("ps"),
    Locale("pt"),
    Locale("ro"),
    Locale("ru"),
    Locale("sd"),
    Locale("sk"),
    Locale("sl"),
    Locale("so"),
    Locale("sq"),
    Locale("sr"),
    Locale("sv"),
    Locale("ta"),
    Locale("tg"),
    Locale("th"),
    Locale("tk"),
    Locale("tr"),
    Locale("tt"),
    Locale("uk"),
    Locale("ug"),
    Locale("ur"),
    Locale("uz"),
    Locale("vi"),
    Locale("zh")
    ],
    localizationsDelegates: const [
    CountryLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    ],
    title: 'Flutter Demo',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
    fontFamily: 'poppins',
    primarySwatch: Colors1.primaryApp,
    primaryColor: Colors1.primaryApp),
    //home: Home(),
    home: (FirebaseAuth.instance.currentUser == null)
    ? const LoginScreen()
        : const Dashboard(),
    );
    })
    );
  }
}
